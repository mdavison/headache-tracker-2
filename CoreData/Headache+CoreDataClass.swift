//
//  Headache+CoreDataClass.swift
//  HeadacheTracker2
//
//  Created by Morgan Davison on 4/28/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//
//

import UIKit
import CoreData
import Charts

@objc(Headache)
public class Headache: NSManagedObject {

    var severityDisplayText: String {
        get {
            let severityInt = Int(severity)
            switch severityInt {
            case 1: return "❶"
            case 2: return "❷"
            case 3: return "❸"
            case 4: return "❹"
            case 5: return "❺"
            default: return ""
            }
        }
    }
    
    var severityDisplayColor: UIColor {
        get {
            let severityInt = Int(severity)
            switch severityInt {
            case 1: return UIColor(named: "Severity1")!
            case 2: return UIColor(named: "Severity2")!
            case 3: return UIColor(named: "Severity3")!
            case 4: return UIColor(named: "Severity4")!
            case 5: return UIColor(named: "Severity5")!
            default: return .black
            }
        }
    }
    
    // MARK: - Static functions
    
    class func prepareCSVData(coreDataStack: CoreDataStack) -> Data? {
        guard let headaches = Headache.getAll(coreDataStack: coreDataStack) else { return nil }
        
        var csvString = "Headache Date,Severity,Medications,Notes\n"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        for headache in headaches {
            var dateString = ""
            if let headacheDate = headache.date as Date? {
                dateString = dateFormatter.string(from: headacheDate)
            }
            
            let meds = headache.getMedicationsString()
            let headacheNote = headache.note ?? ""
            
            csvString = csvString + """
"\(dateString)",\(headache.severity),"\(meds)","\(headacheNote)"
"""
        }
        
        return csvString.data(using: String.Encoding.utf8, allowLossyConversion: false)
    }
    
    class func getAll(coreDataStack: CoreDataStack) -> [Headache]? {
        let fetchRequest: NSFetchRequest<Headache> = Headache.fetchRequest()
        let dateSort = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            let headaches = try coreDataStack.managedContext.fetch(fetchRequest)
            
            return headaches
        } catch let error as NSError {
            print("Headache+CoreDataClass: error fetching all headaches: \(error), \(error.userInfo)")
        }
        
        return nil
    }
    
    class func getAll(startDate: Date, endDate: Date, coreDataStack: CoreDataStack) -> [Headache]? {
        let fetchRequest: NSFetchRequest<Headache> = Headache.fetchRequest()
        let predicate = NSPredicate(format: "date >= %@ && date < %@", startDate as NSDate, endDate as NSDate)
        fetchRequest.predicate = predicate
        
        do {
            let headaches = try coreDataStack.managedContext.fetch(fetchRequest)
            
            return headaches
        } catch let error as NSError {
            print("Headache+CoreDataClass: error fetching all headaches for date: \(error), \(error.userInfo)")
        }
        
        return nil
    }
    
    class func getBarChartData(for year: Int, coreDataStack: CoreDataStack) -> BarChartData? {
        let calendar = Calendar.current
        guard let (startDate, endDate) = Headache.getDates(for: year) else { return nil }
        
        guard let headaches = Headache.getAll(startDate: startDate, endDate: endDate, coreDataStack: coreDataStack) else {
            return nil
        }
        
        var headachesPerMonth = [
            1: 0,
            2: 0,
            3: 0,
            4: 0,
            5: 0,
            6: 0,
            7: 0,
            8: 0,
            9: 0,
            10: 0,
            11: 0,
            12: 0
        ]
        
        for headache in headaches {
            let month = calendar.component(.month, from: headache.date)
            if let hpm = headachesPerMonth[month] {
                headachesPerMonth[month] = hpm + 1
            }
        }
        
        var dataEntries: [BarChartDataEntry] = []
        for (month, num) in headachesPerMonth {
            let dataEntry = BarChartDataEntry(x: Double(month), y: Double(num))
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Number of Headaches")
        let chartData = BarChartData(dataSets: [chartDataSet])
        
        return chartData
    }
    
    class func getPieChartData(for year: Int, coreDataStack: CoreDataStack) -> PieChartData? {
        guard let (startDate, endDate) = Headache.getDates(for: year) else { return nil }
        
        guard
            let headaches = Headache.getAll(startDate: startDate, endDate: endDate, coreDataStack: coreDataStack)
            else { return nil }
        
        var headachesPerSeverity = [
            1: 0,
            2: 0,
            3: 0,
            4: 0,
            5: 0
        ]
        
        for headache in headaches {
            if let numHeadaches = headachesPerSeverity[Int(headache.severity)] {
                headachesPerSeverity[Int(headache.severity)] = numHeadaches + 1
            }
        }
        
        var dataEntries: [PieChartDataEntry] = []
        var colors = [UIColor]()
        
        // Create the data entries in asc order by severity
        for i in 1...5 {
            for (severity, num) in headachesPerSeverity {
                if severity == i && num > 0 {
                    colors.append(UIColor(named: "Severity\(severity)")!)
                    let dataEntry = PieChartDataEntry(value: Double(num), data: severity)
                    dataEntries.append(dataEntry)
                }
            }
        }
        
        let chartDataSet = PieChartDataSet(entries: dataEntries, label: "Severity")
        chartDataSet.colors = colors
        chartDataSet.valueTextColor = NSUIColor.darkGray
        
        let chartData = PieChartData(dataSets: [chartDataSet])
        
        return chartData
    }
    
    class func getDates(for year: Int) -> (Date, Date)? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        
        guard
            let startDate = dateFormatter.date(from: "\(year)"),
            let endDate = dateFormatter.date(from: "\(year + 1)") else {
                return nil
        }
        
        return (startDate, endDate)
    }
    
    
    // MARK: - Public methods
    
    func getMedicationsString() -> String {
        guard let doses = getDoses() else { return "" }
        var displayArray = [String]()
        
        for dose in doses {
            displayArray.append("\(dose.quantity) " + dose.medication.name)
        }
        
        return displayArray.joined(separator: ", ")
    }
    
    func getMedicationsDoses() -> [Medication: Int]? {
        guard let doses = getDoses() else { return nil }
        var medicationDoseQuantities = [Medication: Int]()
        
        for dose in doses {
            medicationDoseQuantities[dose.medication] = Int(dose.quantity)
        }
        
        return medicationDoseQuantities
    }
    
    func updateDoses(coreDataStack: CoreDataStack, medicationQuantities: [Medication: Int]) {
        if let doses = getDoses(), doses.count > 0 {
            for (med, qty) in medicationQuantities {
                // Exists in doses: update quantity
                var exists = false
                for dose in doses {
                    if dose.medication.name == med.name {
                        if qty < 1 {
                            coreDataStack.managedContext.delete(dose)
                        } else {
                            dose.quantity = Int16(qty)
                        }
                        
                        exists = true
                    }
                }
                
                // Doesn't exist in doses: add it
                if exists == false && qty > 0 {
                    let dose = Dose(context: coreDataStack.managedContext)
                    dose.date = self.date
                    dose.medication = med
                    dose.quantity = Int16(qty)
                    dose.headache = self
                }
            }
        } else {
            addDoses(coreDataStack: coreDataStack, medicationQuantities: medicationQuantities)
        }
    }
    
    func addDoses(coreDataStack: CoreDataStack, medicationQuantities: [Medication: Int]) {
        for (med, qty) in medicationQuantities {
            if qty > 0 {
                let dose = Dose(context: coreDataStack.managedContext)
                dose.date = date
                dose.headache = self
                dose.medication = med
                dose.quantity = Int16(qty)
            }
        }
    }
    
    
    // MARK: - Private methods
    
    private func getDoses() -> [Dose]? {
        if let dosesOpt = doses?.allObjects as? [Dose]?, let doses = dosesOpt {
            return doses
        }
        
        return nil
    }
}
