//
//  MADCalendarTests.swift
//  HeadacheTracker2Tests
//
//  Created by Morgan Davison on 7/3/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//

import XCTest
@testable import HeadacheTracker2
import CoreData

class MADCalendarTests: XCTestCase {
    
    var coreDataStack: TestCoreDataStack?
    var madCalendar: MADCalendar?

    override func setUp() {
        super.setUp()
        
        coreDataStack = TestCoreDataStack(modelName: "HeadacheTracker2")
        
        guard let coreDataStack = coreDataStack else {
            XCTFail("Expected coreDataStack to be set")
            return
        }
        
        madCalendar = MADCalendar(coreDataStack: coreDataStack)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetNumberOfDays() {
        guard let madCalendar = madCalendar else {
            XCTFail("Expected madCalendar to be set")
            return
        }
        
        var numDays = madCalendar.getNumberOfDays(for: 6, year: 2019)
        XCTAssertEqual(numDays, 30)
        
        numDays = madCalendar.getNumberOfDays(for: 2, year: 2016)
        XCTAssertEqual(numDays, 29)
        
        numDays = madCalendar.getNumberOfDays(for: 2, year: 2019)
        XCTAssertEqual(numDays, 28)
        
        numDays = madCalendar.getNumberOfDays(for: 2, year: 2024)
        XCTAssertEqual(numDays, 29)
    }
    
    func testGetNumberOfCells() {
        guard let madCalendar = madCalendar else {
            XCTFail("Expected madCalendar to be set")
            return
        }
        
        var numCells = madCalendar.getNumberOfCells(for: 6, year: 2019)
        XCTAssertEqual(numCells, 36)
        
        numCells = madCalendar.getNumberOfCells(for: 2, year: 2019)
        XCTAssertEqual(numCells, 33)
        
        numCells = madCalendar.getNumberOfCells(for: 9, year: 2019)
        XCTAssertEqual(numCells, 30)
        
        numCells = madCalendar.getNumberOfCells(for: 9, year: 2017)
        XCTAssertEqual(numCells, 35)
    }
    
    func testGetDayInfo() {
        guard let coreDataStack = coreDataStack else {
            XCTFail("Expected coreDataStack to be set")
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        
        let today = formatter.date(from: "2019-07-05")
        
        guard
            let startDate = today,
            let date1 = Calendar.current.date(byAdding: .day, value: -2, to: startDate),
            let date2 = Calendar.current.date(byAdding: .day, value: -20, to: startDate),
            let date3 = Calendar.current.date(byAdding: .day, value: -21, to: startDate)
            else {
                XCTFail("Expected dates to be set")
                return
        }
        
        let headache1 = Headache(context: coreDataStack.managedContext)
        headache1.date = date1
        headache1.severity = 1
        
        let headache2 = Headache(context: coreDataStack.managedContext)
        headache2.date = date2
        headache2.severity = 2
        
        // Multiple headaches on the same day
        let headache3 = Headache(context: coreDataStack.managedContext)
        headache3.date = date3
        headache3.severity = 3
        
        let headache4 = Headache(context: coreDataStack.managedContext)
        headache4.date = date3
        headache4.severity = 4
        
        coreDataStack.saveContext()
        
        // Need to initialize madCalendar again after we've added the headaches
        madCalendar = MADCalendar(coreDataStack: coreDataStack)
        
        var indexPath = IndexPath(row: 3, section: 0)
        var dayInfo = madCalendar?.getDayInfo(for: indexPath)
        
        XCTAssertEqual(dayInfo?.number, "3")
        XCTAssertEqual(dayInfo?.headache?.severity, 1)
        
        indexPath = IndexPath(row: 20, section: 1)
        dayInfo = madCalendar?.getDayInfo(for: indexPath)
        
        XCTAssertEqual(dayInfo?.number, "15")
        XCTAssertEqual(dayInfo?.headache?.severity, 2)
        
        indexPath = IndexPath(row: 19, section: 1)
        dayInfo = madCalendar?.getDayInfo(for: indexPath)
        
        XCTAssertEqual(dayInfo?.number, "14")
        // Severity should be the greater of the 2 headaches for this date
        XCTAssertEqual(dayInfo?.headache?.severity, 4)
    }
    
    func testGetMonthName() {
        guard let coreDataStack = coreDataStack else {
            XCTFail("Expected coreDataStack to be set")
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        
        let today = formatter.date(from: "2019-07-05")
        
        guard
            let startDate = today,
            let date1 = Calendar.current.date(byAdding: .day, value: -2, to: startDate),
            let date2 = Calendar.current.date(byAdding: .day, value: -20, to: startDate)
            else {
                XCTFail("Expected dates to be set")
                return
        }
        
        let headache1 = Headache(context: coreDataStack.managedContext)
        headache1.date = date1
        headache1.severity = 1
        
        let headache2 = Headache(context: coreDataStack.managedContext)
        headache2.date = date2
        headache2.severity = 2
        
        coreDataStack.saveContext()
        
        // Need to initialize madCalendar again after we've added the headaches
        madCalendar = MADCalendar(coreDataStack: coreDataStack)
        
        var indexPath = IndexPath(row: 3, section: 0)
        var monthName = madCalendar?.getMonthName(for: indexPath)
        
        XCTAssertEqual(monthName, "July 2019")
        
        indexPath = IndexPath(row: 20, section: 1)
        monthName = madCalendar?.getMonthName(for: indexPath)
        
        XCTAssertEqual(monthName, "June 2019")
    }

}
