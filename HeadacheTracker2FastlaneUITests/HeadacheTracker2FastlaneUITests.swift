//
//  HeadacheTracker2FastlaneUITests.swift
//  HeadacheTracker2FastlaneUITests
//
//  Created by Morgan Davison on 7/24/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//

import XCTest

class HeadacheTracker2FastlaneUITests: XCTestCase {

    let app = XCUIApplication()
    var today: String?
    
    override func setUp() {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // Fastlane
        setupSnapshot(app)
        
        app.launch()

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        today = dateFormatter.string(from: Date())
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func SettingsScreen() {
        // Navigate to the Settings tab
        app.tabBars.children(matching: .button).element(boundBy: 4).tap()
        
        // Take a screenshot
        snapshot("01SettingsScreen")
    }
    
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
        
        // Take a screenshot
        snapshot("01MedicationsList")
    }
    
    func AddHeadaches() {
        var severity: XCUIElement
        let addHeadacheButton = app.navigationBars["Headaches"].buttons["Add"]
        
        // 1
        addHeadacheButton.tap()
        
        let tablesQuery = app.tables
        let pickerWheel = tablesQuery.pickerWheels.firstMatch
        pickerWheel.swipeDown()
        pickerWheel.swipeDown()
        pickerWheel.swipeDown()
        pickerWheel.swipeDown()
        pickerWheel.swipeDown()
        pickerWheel.swipeDown()
        pickerWheel.swipeDown()
        pickerWheel.swipeDown()
        
        severity = tablesQuery.staticTexts["❹"]
        tablesQuery.sliders["severitySlider"].press(forDuration: 0.5, thenDragTo: severity)
        
        tablesQuery.staticTexts["Acetaminophen"].tap()
        
        let doneButton = app.navigationBars["New Headache"].buttons["Done"]
        doneButton.tap()
        
        // 2
        addHeadacheButton.tap()
        
        pickerWheel.swipeDown()
        pickerWheel.swipeDown()
        pickerWheel.swipeDown()
        pickerWheel.swipeDown()
        pickerWheel.swipeDown()
        
        severity = tablesQuery.staticTexts["❸"]
        tablesQuery.sliders["severitySlider"].press(forDuration: 0.5, thenDragTo: severity)
        
        tablesQuery.staticTexts["Coffee"].tap()
        
        doneButton.tap()
        
        // 3
        addHeadacheButton.tap()
        
        pickerWheel.swipeDown()
        pickerWheel.swipeDown()
        pickerWheel.swipeDown()
        pickerWheel.swipeDown()
        
        severity = tablesQuery.staticTexts["❶"]
        tablesQuery.sliders["severitySlider"].press(forDuration: 0.5, thenDragTo: severity)
        
        tablesQuery.staticTexts["Ibuprofen"].tap()
        
        doneButton.tap()
        
        // 4
        addHeadacheButton.tap()
        
        pickerWheel.swipeDown()
        pickerWheel.swipeDown()
        pickerWheel.swipeDown()
        
        severity = tablesQuery.staticTexts["❺"]
        tablesQuery.sliders["severitySlider"].press(forDuration: 0.5, thenDragTo: severity)
        
        tablesQuery.staticTexts["Ibuprofen"].tap()
        
        doneButton.tap()
        
        // 5
        addHeadacheButton.tap()
        
        pickerWheel.swipeDown()
        pickerWheel.swipeDown()
        
        severity = tablesQuery.staticTexts["❹"]
        tablesQuery.sliders["severitySlider"].press(forDuration: 0.5, thenDragTo: severity)
        
        tablesQuery.staticTexts["Acetaminophen"].tap()
        
        doneButton.tap()
        
        // 6
        addHeadacheButton.tap()
        
        pickerWheel.swipeDown()
        
        severity = tablesQuery.staticTexts["❷"]
        tablesQuery.sliders["severitySlider"].press(forDuration: 0.5, thenDragTo: severity)
        
        tablesQuery.staticTexts["Coffee"].tap()
        
        doneButton.tap()
        
        // 6
        addHeadacheButton.tap()
        
        severity = tablesQuery.staticTexts["❸"]
        tablesQuery.sliders["severitySlider"].press(forDuration: 0.5, thenDragTo: severity)
        
        tablesQuery.staticTexts["Coffee"].tap()
        
        doneButton.tap()
        
        // Take a screenshot
        snapshot("01HeadachesList")
    }
    
    func ShowBarChart() {
        // Navigate to the Bar Chart tab
        app.tabBars.children(matching: .button).element(boundBy: 2).tap()
        
        // Take a screenshot
        snapshot("01BarChart")
    }
    
    func ShowPieChart() {
        // Navigate to the Pie Chart tab
        app.tabBars.children(matching: .button).element(boundBy: 3).tap()
        
        // Take a screenshot
        snapshot("01PieChart")
    }
    
    func testShowAddHeadache() {
        let addHeadacheButton = app.navigationBars["Headaches"].buttons["Add"]
        addHeadacheButton.tap()
        
        // Take a screenshot
        snapshot("01AddHeadache")
    }


}
