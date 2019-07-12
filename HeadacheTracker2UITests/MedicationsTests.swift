//
//  MedicationsTests.swift
//  HeadacheTracker2UITests
//
//  Created by Morgan Davison on 7/7/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//

import XCTest

class MedicationsTests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMedicationsViewShowsNamesAndDescriptions() {
        // Navigate to the Settings tab
        app.tabBars.children(matching: .button).element(boundBy: 4).tap()
        
        // Insert a test medication
        let tablesQuery = app.tables
        tablesQuery.buttons["Manage Medications"].tap()
        app.navigationBars["Medications"].buttons["Add"].tap()
        tablesQuery.textFields["Ibuprofen"].tap()
        tablesQuery.textFields.firstMatch.typeText("Test Medication")
        
        let descTextField = tablesQuery.children(matching: .cell).element(boundBy: 1).children(matching: .textField).element
        descTextField.tap()
        descTextField.typeText("10 mg tablet")
        
        app.navigationBars["New Medication"].buttons["Done"].tap()
        
        let tableRow = tablesQuery.staticTexts["Test Medication"]
        
        XCTAssertTrue(tableRow.exists)
        XCTAssertTrue(tablesQuery.staticTexts["10 mg tablet"].exists)
        
        // Delete the test medication
        tableRow.swipeLeft()
        tablesQuery.buttons["Delete"].tap()
        
    }

}
