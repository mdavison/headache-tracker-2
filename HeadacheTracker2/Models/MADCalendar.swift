//
//  MDCalendar.swift
//  HeadacheTracker2
//
//  Created by Morgan Davison on 5/23/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//

import Foundation
import CoreData

class MADCalendar {
    let calendar = Calendar.current
    weak var coreDataStack: CoreDataStack?
    var monthsYears = [(month: Int, year: Int)]()
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        
        populateMonthsYears()
    }
    
    func getNumberOfDays(for month: Int, year: Int) -> Int {
        let dateComponents = DateComponents(calendar: calendar, year: year, month: month)
        
        if let date = calendar.date(from: dateComponents) {
            let numberOfDaysInMonth = calendar.range(of: .day, in: .month, for: date)
            if let last = numberOfDaysInMonth?.last {
                return last
            }
        }
        
        return 0
    }
    
    func getNumberOfCells(for month: Int, year: Int) -> Int {
        let numDays = getNumberOfDays(for: month, year: year)
        
        let padding = getPadding(forMonth: month, year: year)
        
        return numDays + padding
    }
    
    func getDayInfo(for indexPath: IndexPath) -> (number: String, headache: Headache?) {
        // Construct arrays for the day number and the severity, then return the array indexes for the given indexPath
        var cells = [String]()
        var headaches = [Headache?]()
        
        let monthYear = monthsYears[indexPath.section]
        let numDays = getNumberOfDays(for: monthYear.month, year: monthYear.year)
        let numCells = getNumberOfCells(for: monthYear.month, year: monthYear.year)
        let paddingAmt = numCells - numDays
        for _ in 0..<paddingAmt {
            cells.append(" ")
            headaches.append(nil)
        }
        
        for day in 1...numDays {
            cells.append("\(day)")
            
            let headache = getWorstHeadache(for: day, month: monthYear.month, year: monthYear.year)
            headaches.append(headache)
        }
        
        return (cells[indexPath.row], headaches[indexPath.row])
    }
    
    func getMonthName(for indexPath: IndexPath) -> String {
        let monthYear = monthsYears[indexPath.section]
        let dateComponents = DateComponents(calendar: calendar, year: monthYear.year, month: monthYear.month)
        let date = calendar.date(from: dateComponents)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL YYYY"
        
        if let date = date {
            return dateFormatter.string(from: date)
        }
        
        return ""
    }
    
    
    // MARK: - Private helper methods
    
    private func populateMonthsYears() {
        guard
            let coreDataStack = coreDataStack,
            let headaches = Headache.getAll(coreDataStack: coreDataStack)
            else { return }
        
        for headache in headaches {
            let dateComponents = calendar.dateComponents([.year, .month], from: headache.date)
            guard let headacheMonth = dateComponents.month, let headacheYear = dateComponents.year else { continue }
            
            let contains = monthsYears.contains(where: { (month, year) -> Bool in
                return month == headacheMonth && year == headacheYear
            })
            if contains == false {
                monthsYears.append((month: headacheMonth, year: headacheYear))
            }
        }
    }
    
    private func getPadding(forMonth month: Int, year: Int) -> Int {
        guard let date = calendar.date(from: DateComponents(calendar: calendar, year: year, month: month, day: 1)) else { return 0 }
        
        let dateComponentsFirstDay = calendar.dateComponents([.weekday], from: date)
        if let weekday = dateComponentsFirstDay.weekday {
            // If weekday is 1, no padding
            if weekday > 1 {
                return weekday - 1
            }
        }
        
        return 0
    }
    
    private func getWorstHeadache(for day: Int, month: Int, year: Int) -> Headache? {
        // Get headache with highest severity for given date
        guard let coreDataStack = coreDataStack else { return nil }
        
        let startDateComponents = DateComponents(calendar: calendar, year: year, month: month, day: day)
        let endDateComponents = DateComponents(calendar: calendar, year: year, month: month, day: day + 1)
        let startDate = calendar.date(from: startDateComponents)
        let endDate = calendar.date(from: endDateComponents)
        
        guard let startDateFromComponents = startDate, let endDateFromComponents = endDate else { return nil }
        
        let headaches = Headache.getAll(startDate: startDateFromComponents, endDate: endDateFromComponents, coreDataStack: coreDataStack)
        var severity: Int16 = 0
        var worstHeadache: Headache?
        if let headaches = headaches {
            for headache in headaches {
                if headache.severity > severity {
                    severity = headache.severity
                    worstHeadache = headache
                }
            }
        }
        
        return worstHeadache
    }
}
