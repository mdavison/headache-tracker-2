//
//  Screenshots.swift
//  HeadacheTracker2UITests
//
//  Created by Morgan Davison on 7/22/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//

import XCTest

/// Tests for seeding app with data
/// Run in the order listed (do not run the whole class b/c Xcode runs the tests alphabetically)
class Seed: XCTestCase {
    
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
    
    // Prepend "test" to run this
    func AddMedications() {
        // Navigate to the Settings tab
        app.tabBars.children(matching: .button).element(boundBy: 4).tap()
        
        // Insert a test medication
        let tablesQuery = app.tables
        tablesQuery.buttons["Manage Medications"].tap()
        
        // 1
        app.navigationBars["Medications"].buttons["Add"].tap()
        tablesQuery.textFields["Ibuprofen"].tap()
        tablesQuery.textFields.firstMatch.typeText("Ibuprofen")
        
        let descTextField = tablesQuery.children(matching: .cell).element(boundBy: 1).children(matching: .textField).element
        descTextField.tap()
        descTextField.typeText("200 mg tablet")
        app.navigationBars["New Medication"].buttons["Done"].tap()
        
        // 2
        app.navigationBars["Medications"].buttons["Add"].tap()
        tablesQuery.textFields["Ibuprofen"].tap()
        tablesQuery.textFields.firstMatch.typeText("Acetaminophen")
        descTextField.tap()
        descTextField.typeText("325 mg tablet")
        app.navigationBars["New Medication"].buttons["Done"].tap()
        
        // 3
        app.navigationBars["Medications"].buttons["Add"].tap()
        tablesQuery.textFields["Ibuprofen"].tap()
        tablesQuery.textFields.firstMatch.typeText("Coffee")
        descTextField.tap()
        descTextField.typeText("12 oz cup")
        app.navigationBars["New Medication"].buttons["Done"].tap()
        
        // 4
        app.navigationBars["Medications"].buttons["Add"].tap()
        tablesQuery.textFields["Ibuprofen"].tap()
        tablesQuery.textFields.firstMatch.typeText("Naproxen Sodium")
        descTextField.tap()
        descTextField.typeText("220 mg tablet")
        app.navigationBars["New Medication"].buttons["Done"].tap()
    }
    
    // Prepend "test" to run this
    func AddHeadaches() {
        let addHeadacheButton = app.navigationBars["Headaches"].buttons["Add"]
        
        // 1
        addHeadacheButton.tap()
        
        let tablesQuery = app.tables
        let pickerWheel = tablesQuery.pickerWheels.firstMatch
        pickerWheel.swipeDown()
        pickerWheel.swipeDown()
        pickerWheel.swipeDown()
        pickerWheel.swipeDown()
        
        tablesQuery.sliders["severitySlider"].swipeLeft()
        
        tablesQuery.staticTexts["Acetaminophen"].tap()
        
        let doneButton = app.navigationBars["New Headache"].buttons["Done"]
        doneButton.tap()
        
        // 2
        addHeadacheButton.tap()
        
        pickerWheel.swipeDown()
        pickerWheel.swipeDown()
        pickerWheel.swipeDown()
        
        tablesQuery.sliders["severitySlider"].swipeRight()
        
        tablesQuery.staticTexts["Coffee"].tap()
        
        doneButton.tap()
        
        // 3
        addHeadacheButton.tap()
        
        pickerWheel.swipeDown()
        pickerWheel.swipeDown()
        
        tablesQuery.sliders["severitySlider"].swipeRight()
        
        tablesQuery.staticTexts["Ibuprofen"].tap()
        
        doneButton.tap()
        
        
        
    }

}
