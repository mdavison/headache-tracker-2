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
            case 1: return UIColor.init(red: 212.0/255.0, green: 251.0/255.0, blue: 121.0/255.0, alpha: 1.0)
            case 2: return UIColor.init(red: 237.0/255.0, green: 252.0/255.0, blue: 121.0/255.0, alpha: 1.0)
            case 3: return UIColor.init(red: 255.0/255.0, green: 252.0/255.0, blue: 121.0/255.0, alpha: 1.0)
            case 4: return UIColor.init(red: 255.0/255.0, green: 173.0/255.0, blue: 121.0/255.0, alpha: 1.0)
            case 5: return UIColor.init(red: 255.0/255.0, green: 126.0/255.0, blue: 121.0/255.0, alpha: 1.0)
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        guard let startDate = dateFormatter.date(from: "\(year)") else { return nil }
        let endDateString = "\(year + 1)"
        guard let endDate = dateFormatter.date(from: endDateString) else { return nil }
        
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
