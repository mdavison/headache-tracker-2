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
    
    var coreDataStack: TestCoreDataStack!

    override func setUp() {
        super.setUp()
        
        coreDataStack = TestCoreDataStack(modelName: "HeadacheTracker2")
    }

    override func tearDown() {
        super.tearDown()
        
        coreDataStack = nil
    }

//    func testUpdateDoses() {
//        // we have a headache
//        let headache = Headache(context: coreDataStack.managedContext)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        let formattedDateString = dateFormatter.string(from: Date())
//        let formattedDate = dateFormatter.date(from: formattedDateString)
//        headache.date = formattedDate
//
//        let medication = Medication(context: coreDataStack.managedContext)
//        medication.name = "Tylenol"
//
//        let dose = Dose(context: coreDataStack.managedContext)
//        dose.date = formattedDate!
//        dose.headache = headache
//        dose.medication = medication
//        dose.quantity = Int16(1)
//
////        coreDataStack.saveContext()
////
////        // Fetch headaches
////        let fetchRequest = NSFetchRequest<Headache>(entityName: "Headache")
////        let headaches = try! coreDataStack.managedContext.fetch(fetchRequest) as [Headache]
//////        XCTAssert(headaches.count == 1)
////        print(headaches)
//
//        // Assert that our headache only has 1 dose of 1 Tylenol
//        XCTAssert(headache.doses?.count == 1)
//        let medicationDoses = headache.getMedicationsDoses()!
//        for (med, qty) in medicationDoses {
//            XCTAssert(med.name! == "Tylenol")
//        }
//
//
//        // we have [Medication: Int]
//        let headacheMedicationQuantities = [medication: 2]
//
//        // when we call updateDoses with [Medication: Int] we should see new results
//        headache.updateDoses(medicationQuantities: headacheMedicationQuantities, coreDataStack: coreDataStack)
//
//        // Assert that headache now has 2 Tylenol
//        // Assert that headache still only has 1 dose
//        XCTAssert(headache.doses?.count == 1)
//    }

}
