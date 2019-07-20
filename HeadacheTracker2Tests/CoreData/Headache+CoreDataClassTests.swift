//
//  Headache+CoreDataClassTests.swift
//  HeadacheTracker2Tests
//
//  Created by Morgan Davison on 5/17/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//

import XCTest
@testable import HeadacheTracker2
import CoreData 

class HeadacheTests: XCTestCase {
    
    var coreDataStack: TestCoreDataStack?
    var headache: Headache?
    
    override func setUp() {
        super.setUp()
        
        coreDataStack = TestCoreDataStack(modelName: "HeadacheTracker2")
        
        guard let coreDataStack = coreDataStack else {
            XCTFail("Expected coreDataStack to be set")
            return
        }
        
        headache = Headache(context: coreDataStack.managedContext)
        
        // Make sure we start with an empty db
        clearDatabase()
    }

    override func tearDown() {
        super.tearDown()
        
        // Try to empty the db
        clearDatabase()
    }
    
    func testCheckEmpty() {
        if let coreDataStack = coreDataStack {
            let headaches = Headache.getAll(coreDataStack: coreDataStack)!
            XCTAssertEqual(headaches.count, 0)
        } else {
            XCTFail()
        }
    }
    
    func testSeverityDisplayText() {
        guard let headache = headache else {
            XCTFail("Expected headache to be set")
            return
        }
        
        headache.severity = 1
        XCTAssert(headache.severityDisplayText == "❶")

        headache.severity = 2
        XCTAssert(headache.severityDisplayText == "❷")

        headache.severity = 3
        XCTAssert(headache.severityDisplayText == "❸")

        headache.severity = 4
        XCTAssert(headache.severityDisplayText == "❹")

        headache.severity = 5
        XCTAssert(headache.severityDisplayText == "❺")
    }
    
    func testSeverityDisplayColor() {
        guard let headache = headache else {
            XCTFail("Expected headache to be set")
            return
        }
        
        headache.severity = 1
        XCTAssert(headache.severityDisplayColor == UIColor(named: "Severity1")!)
        
        headache.severity = 2
        XCTAssert(headache.severityDisplayColor == UIColor(named: "Severity2")!)
        
        headache.severity = 3
        XCTAssert(headache.severityDisplayColor == UIColor(named: "Severity3")!)
        
        headache.severity = 4
        XCTAssert(headache.severityDisplayColor == UIColor(named: "Severity4")!)
        
        headache.severity = 5
        XCTAssertTrue(headache.severityDisplayColor == UIColor(named: "Severity5")!)
    }
    
    func testGetAll() {
        guard let coreDataStack = coreDataStack else {
            XCTFail("Expected coreDataStack to be set")
            return
        }
        
        let _ = [
            Headache(context: coreDataStack.managedContext),
            Headache(context: coreDataStack.managedContext),
            Headache(context: coreDataStack.managedContext)
        ]
        
        coreDataStack.saveContext()
        
        let headaches = Headache.getAll(coreDataStack: coreDataStack)
        
        XCTAssertEqual(headaches?.count, 3)
    }
    
    func testUpdateDate() {
        guard let coreDataStack = coreDataStack else {
            XCTFail("Expected coreDataStack to be set")
            return
        }
        
        var headache = Headache(context: coreDataStack.managedContext)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let formattedDate = dateFormatter.date(from: "2019-07-01") else {
            XCTFail("Expected formatted date to return a Date object")
            return
        }
        headache.date = formattedDate
        
        coreDataStack.saveContext()
        
        guard
            let headaches = Headache.getAll(coreDataStack: coreDataStack),
            let firstHeadache = headaches.first
        else {
            XCTFail("Expected Headache.getAll() to return headaches")
            return
        }
        headache = firstHeadache
        
        XCTAssertEqual(dateFormatter.string(from: formattedDate), "2019-07-01")
        
        guard let newDate = dateFormatter.date(from: "2019-06-15") else {
            XCTFail("Expected newDate to be set")
            return
        }
        firstHeadache.date = newDate
        
        coreDataStack.saveContext()
        
        guard
            let headachesUpdated = Headache.getAll(coreDataStack: coreDataStack),
            let updatedHeadache = headachesUpdated.first
            else {
                XCTFail("Expected Headache.getAll() to return updated headache")
                return
        }
        headache = updatedHeadache
        
        XCTAssertEqual(dateFormatter.string(from: headache.date), "2019-06-15")
    }
    
    func testUpdateSeverity() {
        guard let coreDataStack = coreDataStack else {
            XCTFail("Expected coreDataStack to be set")
            return
        }
        
        var headache = Headache(context: coreDataStack.managedContext)
        headache.severity = Int16(3)
        coreDataStack.saveContext()
        
        guard
            let headaches = Headache.getAll(coreDataStack: coreDataStack),
            let firstHeadache = headaches.first
            else {
                XCTFail("Expected Headache.getAll() to return headaches")
                return
        }
        headache = firstHeadache
        
        XCTAssertEqual(headache.severity, 3)
        
        headache.severity = Int16(4)
        coreDataStack.saveContext()
        
        guard
            let headachesUpdated = Headache.getAll(coreDataStack: coreDataStack),
            let updatedHeadache = headachesUpdated.first
            else {
                XCTFail("Expected Headache.getAll() to return updated headache")
                return
        }
        headache = updatedHeadache
        
        XCTAssertEqual(headache.severity, 4)
    }
    
    func testUpdateNote() {
        guard let coreDataStack = coreDataStack else {
            XCTFail("Expected coreDataStack to be set")
            return
        }
        
        var headache = Headache(context: coreDataStack.managedContext)
        headache.note = "Testing gives me a headache."
        coreDataStack.saveContext()
        
        guard
            let headaches = Headache.getAll(coreDataStack: coreDataStack),
            let firstHeadache = headaches.first
            else {
                XCTFail("Expected Headache.getAll() to return headaches")
                return
        }
        headache = firstHeadache
        
        XCTAssertEqual(headache.note, "Testing gives me a headache.")
        
        headache.note = "Tests are terrific!"
        coreDataStack.saveContext()
        
        guard
            let headachesUpdated = Headache.getAll(coreDataStack: coreDataStack),
            let updatedHeadache = headachesUpdated.first
            else {
                XCTFail("Expected Headache.getAll() to return updated headache")
                return
        }
        headache = updatedHeadache

        XCTAssertEqual(headache.note, "Tests are terrific!")
    }
    
    func testUpdateDoses() {
        guard let coreDataStack = coreDataStack else {
            XCTFail("Expected coreDataStack to be set")
            return
        }
        
        var headache = Headache(context: coreDataStack.managedContext)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let formattedDate = dateFormatter.date(from: "2019-07-01") else {
            XCTFail("Expected formattedDate to return a Date object")
            return
        }
        
        headache.date = formattedDate
        
        let medication = Medication(context: coreDataStack.managedContext)
        medication.name = "Tylenol"
        
        let dose = Dose(context: coreDataStack.managedContext)
        dose.date = formattedDate
        dose.headache = headache
        dose.medication = medication
        dose.quantity = Int16(1)
        
        coreDataStack.saveContext()
        
        guard
            let headaches = Headache.getAll(coreDataStack: coreDataStack),
            let firstHeadache = headaches.first
            else {
                XCTFail("Expected Headache.getAll() to return headaches")
                return
        }
        headache = firstHeadache

        // Assert that headache only has 1 dose of 1 Tylenol
        XCTAssertEqual(headache.doses?.count, 1)
        guard let medicationDoses = headache.getMedicationsDoses() else {
            XCTFail("Expected medicationDoses to be set")
            return
        }
        for (med, qty) in medicationDoses {
            XCTAssertEqual(med.name, "Tylenol")
            XCTAssertEqual(qty, 1)
        }
        
        let headacheMedicationQuantities = [medication: 2]
        // When we call updateDoses with [Medication: Int] we should see new results
        headache.updateDoses(coreDataStack: coreDataStack, medicationQuantities: headacheMedicationQuantities)
        
        coreDataStack.saveContext()
        
        // Make sure we still only have 1 headache
        let allHeadaches = Headache.getAll(coreDataStack: coreDataStack)
        XCTAssertEqual(allHeadaches?.count, 1)
        
        guard let allHeadachesFirst = allHeadaches?.first else {
            XCTFail("Expected firstHeadache to be set")
            return
        }
        headache = allHeadachesFirst

        // Assert that headache still only has 1 dose
        XCTAssert(headache.doses?.count == 1)
        // Assert that headache now has 2 Tylenol
        guard let medicationDosesUpdated = headache.getMedicationsDoses() else {
            XCTFail("Expected medicationDosesUpdated to be set")
            return
        }
        for (med, qty) in medicationDosesUpdated {
            XCTAssertEqual(med.name, "Tylenol")
            XCTAssertEqual(qty, 2)
        }
    }
    
    func testGetDatesForLast() {
        guard let coreDataStack = coreDataStack else {
            XCTFail("Expected coreDataStack to be set")
            return
        }
        
        let today = Date()
        let dates = [
            today,
            Calendar.current.date(byAdding: .day, value: -3, to: today),
            Calendar.current.date(byAdding: .day, value: -7, to: today),
            Calendar.current.date(byAdding: .day, value: -20, to: today),
            Calendar.current.date(byAdding: .day, value: -30, to: today),
            Calendar.current.date(byAdding: .day, value: -60, to: today),
            Calendar.current.date(byAdding: .day, value: -365, to: today)
        ]
        
        var headache: Headache
        for date in dates {
            headache = Headache(context: coreDataStack.managedContext)
            headache.date = date!
            headache.severity = 3
            
            coreDataStack.saveContext()
        }
        
        var (startDate, endDate) = Headache.getDatesForLast(numDays: ChartInterval.week.rawValue)!
        var headaches = Headache.getAll(startDate: startDate, endDate: endDate, coreDataStack: coreDataStack)
        
        XCTAssertEqual(headaches?.count, 2)
        
        (startDate, endDate) = Headache.getDatesForLast(numDays: ChartInterval.month.rawValue)!
        headaches = Headache.getAll(startDate: startDate, endDate: endDate, coreDataStack: coreDataStack)
        
        XCTAssertEqual(headaches?.count, 4)
        
        (startDate, endDate) = Headache.getDatesForLast(numDays: ChartInterval.year.rawValue)!
        headaches = Headache.getAll(startDate: startDate, endDate: endDate, coreDataStack: coreDataStack)
        
        XCTAssertEqual(headaches?.count, 6)
    }

    
    // MARK: - Helper methods
    
    private func clearDatabase() {
        if let headaches = Headache.getAll(coreDataStack: coreDataStack!) {
            for headache in headaches {
                coreDataStack?.managedContext.delete(headache)
            }
        }
    }
}
