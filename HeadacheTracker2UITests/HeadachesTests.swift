//
//  HeadachesTests.swift
//  HeadacheTracker2UITests
//
//  Created by Morgan Davison on 7/8/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//

import XCTest

class HeadachesTests: XCTestCase {

    let app = XCUIApplication()
    var today: String?
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        today = dateFormatter.string(from: Date())
    }

    override func tearDown() {
        today = nil
    }
    
    func testAddHeadache() {        
        app.navigationBars["Headaches"].buttons["Add"].tap()
        app.navigationBars["New Headache"].buttons["Done"].tap()
        
        let newHeadache = app.tables.staticTexts[today!]
        
        XCTAssert(newHeadache.exists)
        
        newHeadache.swipeLeft()
        app.buttons["Delete"].tap()
    }
    
    func testUpdateHeadache() {
        app.navigationBars["Headaches"].buttons["Add"].tap()
        app.navigationBars["New Headache"].buttons["Done"].tap()
        
        let newHeadache = app.tables.staticTexts[today!].firstMatch
        
        newHeadache.tap()
        
        let editHeadacheNavBar = app.navigationBars["Edit Headache"]
        XCTAssert(editHeadacheNavBar.exists)
        
        let severitySlider = app.tables.sliders["severitySlider"]
        
        XCTAssert(severitySlider.exists)

        // This is not working...
//        severitySlider.adjust(toNormalizedSliderPosition: 1)
        
        editHeadacheNavBar.buttons["Done"].tap()
        
//        XCTAssert(app.tables.cells.containing(.staticText, identifier:today).staticTexts["❺"].exists)
        
        newHeadache.swipeLeft()
        app.buttons["Delete"].tap()
    }
    
    func testAddMedication() {
        // Add a new headache
        app.navigationBars["Headaches"].buttons["Add"].tap()
        
        // Add a new medication
        let tablesQuery = app.tables
        app.tables.containing(.other, identifier:"DATE").element.swipeUp()
        tablesQuery.buttons["Manage Medications"].tap()
        app.navigationBars["Medications"].buttons["Add"].tap()
        tablesQuery.textFields["Ibuprofen"].tap()
        tablesQuery.textFields.firstMatch.typeText("Test Medication")
        
        let descTextField = tablesQuery.children(matching: .cell).element(boundBy: 1).children(matching: .textField).element
        descTextField.tap()
        descTextField.typeText("10 mg tablet")
        
        app.navigationBars["New Medication"].buttons["Done"].tap()
        app.navigationBars["Medications"].buttons["Done"].tap()

        // Add 2 doses
        tablesQuery.staticTexts["Test Medication"].tap()
        tablesQuery.staticTexts["Test Medication"].tap()
        
        app.navigationBars["New Headache"].buttons["Done"].tap()
        
        let newHeadache = app.tables.staticTexts[today!]
        
        // Assert new headache with new medication shows up in headache list
        XCTAssert(newHeadache.exists)
        XCTAssert(app.tables.staticTexts["2 Test Medication"].exists)
        
        // Delete the test headache
        newHeadache.swipeLeft()
        app.buttons["Delete"].tap()
        
        // Delete the test medication
        app.tabBars.children(matching: .button).element(boundBy: 4).tap()
        tablesQuery.buttons["Manage Medications"].tap()
        tablesQuery.staticTexts["Test Medication"].swipeLeft()
        tablesQuery.buttons["Delete"].tap()
    }
    
    func testUpdateMedicationNameShowsInTable() {
        // Add a new headache
        app.navigationBars["Headaches"].buttons["Add"].tap()
        
        // Add a new medication
        let tablesQuery = app.tables
        app.tables.containing(.other, identifier:"DATE").element.swipeUp()
        tablesQuery.buttons["Manage Medications"].tap()
        app.navigationBars["Medications"].buttons["Add"].tap()
        tablesQuery.textFields["Ibuprofen"].tap()
        tablesQuery.textFields.firstMatch.typeText("Test Medication")
        
        let descTextField = tablesQuery.children(matching: .cell).element(boundBy: 1).children(matching: .textField).element
        descTextField.tap()
        descTextField.typeText("20 mg tablet")
        
        app.navigationBars["New Medication"].buttons["Done"].tap()
        app.navigationBars["Medications"].buttons["Done"].tap()
        
        // Add a dose
        tablesQuery.staticTexts["Test Medication"].tap()
        
        app.navigationBars["New Headache"].buttons["Done"].tap()
        
        let newHeadache = app.tables.staticTexts[today!]
        
        // Assert new headache with new medication shows up in headache list
        XCTAssert(newHeadache.exists)
        XCTAssert(app.tables.staticTexts["1 Test Medication"].exists)
        
        // Navigate to the Settings tab
        app.tabBars.children(matching: .button).element(boundBy: 4).tap()
        
        // Update name of Test Medication
        app.tables.buttons["Manage Medications"].tap()
        app.tables.cells.staticTexts["Test Medication"].tap()
        
        app.tables.cells.textFields.firstMatch.tap()
        app.tables.cells.textFields.firstMatch.typeText(" Edited")
        
        app.navigationBars["Edit Test Medication"].buttons["Done"].tap()
        app.navigationBars["Medications"].buttons["Done"].tap()
        
        // Navigate to headache tab
        app.tabBars.children(matching: .button).element(boundBy: 0).tap()
        
        // Assert the medication name has updated
        XCTAssert(app.tables.staticTexts["1 Test Medication Edited"].exists)
        
        // Delete the test headache
        newHeadache.swipeLeft()
        app.buttons["Delete"].tap()
        
        // Delete the test medication
        app.tabBars.children(matching: .button).element(boundBy: 4).tap()
        tablesQuery.buttons["Manage Medications"].tap()
        tablesQuery.staticTexts["Test Medication Edited"].swipeLeft()
        tablesQuery.buttons["Delete"].tap()
    }
   
}
