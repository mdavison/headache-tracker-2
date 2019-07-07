//
//  Medication+CoreDataClassTests.swift
//  HeadacheTracker2Tests
//
//  Created by Morgan Davison on 7/1/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//

import XCTest
@testable import HeadacheTracker2
import CoreData

class Medication_CoreDataClassTests: XCTestCase {

    var coreDataStack: TestCoreDataStack?
    var medication: Medication?
    
    override func setUp() {
        super.setUp()
        
        coreDataStack = TestCoreDataStack(modelName: "HeadacheTracker2")
        
        guard let coreDataStack = coreDataStack else {
            XCTFail("Expected coreDataStack to be set")
            return
        }
        
        medication = Medication(context: coreDataStack.managedContext)
        
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
            let medications = Medication.fetchAll(coreDataStack: coreDataStack)
            XCTAssertEqual(medications.count, 0)
        } else {
            XCTFail()
        }
    }
    
    func testFetchAll() {
        guard let coreDataStack = coreDataStack else {
            XCTFail("Expected coreDataStack to be set")
            return
        }
        
        let _ = [
            Medication(context: coreDataStack.managedContext),
            Medication(context: coreDataStack.managedContext),
        ]
        coreDataStack.saveContext()
        
        let medications = Medication.fetchAll(coreDataStack: coreDataStack)
        
        XCTAssertEqual(medications.count, 2)
    }
    
    func testSaveOrCreate() {
        guard let coreDataStack = coreDataStack else {
            XCTFail("Expected coreDataStack to be set")
            return
        }
        
        // Set up an existing medication and verify it's there
        let existingMedication = Medication(context: coreDataStack.managedContext)
        existingMedication.name = "Tylenol"
        coreDataStack.saveContext()
        
        var medications = Medication.fetchAll(coreDataStack: coreDataStack)
        guard let medication = medications.first else {
            XCTFail("Expected to get a Medication from the database")
            return
        }
        XCTAssertEqual(medications.count, 1)
        XCTAssertEqual(medication.name, "Tylenol")
        
        // Create a new medication
        let _ = Medication.saveOrCreate(name: "Cure-All Snake Oil", coreDataStack: coreDataStack)
        coreDataStack.saveContext()
        
        medications = Medication.fetchAll(coreDataStack: coreDataStack)
        XCTAssertEqual(medications.count, 2)
        
        for med in medications {
            XCTAssertTrue(["Tylenol", "Cure-All Snake Oil"].contains(med.name))
        }
        
        // Pass in a medication that already exists and make sure it doesn't get duplicated
        let _ = Medication.saveOrCreate(name: "Tylenol", coreDataStack: coreDataStack)
        coreDataStack.saveContext()
        
        XCTAssertEqual(medications.count, 2)
    }
    
    func testValidateNewBlank() {
        guard let coreDataStack = coreDataStack else {
            XCTFail("Expected coreDataStack to be set")
            return
        }
        
        let tylenol = Medication(context: coreDataStack.managedContext)
        tylenol.name = "Tylenol"
        
        let cureAll = Medication(context: coreDataStack.managedContext)
        cureAll.name = "Cure-All Snake Oil"
        
        coreDataStack.saveContext()
        
        let name = Medication.validate(name: " ", with: [tylenol, cureAll], against: nil)
        
        XCTAssertEqual("Name can't be blank.", name)
    }
    
    func testValidateNewDuplicate() {
        guard let coreDataStack = coreDataStack else {
            XCTFail("Expected coreDataStack to be set")
            return
        }
        
        let tylenol = Medication(context: coreDataStack.managedContext)
        tylenol.name = "Tylenol"
        
        let cureAll = Medication(context: coreDataStack.managedContext)
        cureAll.name = "Cure-All Snake Oil"
        
        coreDataStack.saveContext()
        
        let name = Medication.validate(name: "Tylenol", with: [tylenol, cureAll], against: nil)
        
        XCTAssertEqual("Name already exists", name)
    }
    
    func testValidateNewSuccess() {
        guard let coreDataStack = coreDataStack else {
            XCTFail("Expected coreDataStack to be set")
            return
        }
        
        let tylenol = Medication(context: coreDataStack.managedContext)
        tylenol.name = "Tylenol"
        
        let cureAll = Medication(context: coreDataStack.managedContext)
        cureAll.name = "Cure-All Snake Oil"
        
        coreDataStack.saveContext()
        
        let name = Medication.validate(name: "Advil", with: [tylenol, cureAll], against: nil)
        
        XCTAssertNil(name)
    }
    
    func testValidateExistingBlank() {
        guard let coreDataStack = coreDataStack else {
            XCTFail("Expected coreDataStack to be set")
            return
        }
        
        let tylenol = Medication(context: coreDataStack.managedContext)
        tylenol.name = "Tylenol"
        
        let cureAll = Medication(context: coreDataStack.managedContext)
        cureAll.name = "Cure-All Snake Oil"
        
        coreDataStack.saveContext()
        
        let name = Medication.validate(name: " ", with: [tylenol, cureAll], against: cureAll)
        
        XCTAssertEqual("Name can't be blank.", name)
    }
    
    func testValidateExistingDuplicate() {
        guard let coreDataStack = coreDataStack else {
            XCTFail("Expected coreDataStack to be set")
            return
        }
        
        let tylenol = Medication(context: coreDataStack.managedContext)
        tylenol.name = "Tylenol"
        
        let cureAll = Medication(context: coreDataStack.managedContext)
        cureAll.name = "Cure-All Snake Oil"
        
        coreDataStack.saveContext()
        
        let name = Medication.validate(name: "Tylenol", with: [tylenol, cureAll], against: cureAll)
        
        XCTAssertEqual("Name already exists", name)
    }
    
    func testValidateExistingSuccess() {
        guard let coreDataStack = coreDataStack else {
            XCTFail("Expected coreDataStack to be set")
            return
        }
        
        let tylenol = Medication(context: coreDataStack.managedContext)
        tylenol.name = "Tylenol"
        
        let cureAll = Medication(context: coreDataStack.managedContext)
        cureAll.name = "Cure-All Snake Oil"
        
        coreDataStack.saveContext()
        
        let name = Medication.validate(name: "Tylenol", with: [tylenol, cureAll], against: tylenol)
        
        XCTAssertNil(name)
    }
    
    

    private func clearDatabase() {
        let medications = Medication.fetchAll(coreDataStack: coreDataStack!)
        for med in medications {
            coreDataStack?.managedContext.delete(med)
        }
    }
}
