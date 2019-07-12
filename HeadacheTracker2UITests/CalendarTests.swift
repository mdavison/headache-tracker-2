//
//  CalendarTests.swift
//  HeadacheTracker2UITests
//
//  Created by Morgan Davison on 7/10/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//

import XCTest

class CalendarTests: XCTestCase {

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

    func testNewHeadacheAppears() {
        let app = XCUIApplication()

        // Add a new headache for today
        app.navigationBars["Headaches"].buttons["Add"].tap()
        app.navigationBars["New Headache"].buttons["Done"].tap()

        // Navigate to the Calendar tab
        app.tabBars.children(matching: .button).element(boundBy: 1).tap()
        
        // Get the name of the current month
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        let currentDate = formatter.string(from: Date())
        
        // Assert that it shows up in the calendar
        XCTAssert(app.collectionViews.staticTexts[currentDate].exists)
        
        // Get the current day number
        formatter.dateFormat = "d"
        guard let currentDay = Int(formatter.string(from: Date())) else {
            XCTFail("Expected currentDay to be convertible to Int")
            
            return
        }
        
        // Assert that today is marked with a headache
        let currentDayCell = app.collectionViews.children(matching: .cell).element(boundBy: currentDay)
        XCTAssert(currentDayCell.exists)
        
        // Delete the test headache
        app.tabBars.children(matching: .button).element(boundBy: 0).tap()
        formatter.dateStyle = .medium
        let today = formatter.string(from: Date())
        let newHeadache = app.tables.staticTexts[today].firstMatch
        newHeadache.swipeLeft()
        app.buttons["Delete"].tap()
    }

}
