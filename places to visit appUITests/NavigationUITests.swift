//
//  NavigationUITests.swift
//  places to visit appUITests
//
//  Created by Harriette Berndes on 22/07/2021.
//

import XCTest

class NavigationUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {

        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testMapIsLaunchScreen() throws {
        XCTAssertTrue(app.isDisplayingMapLaunchScreen)
    }
    
    func testSeachVCAppearsOnPlusButtonTap() {
        // this is interruped by the location permissions alert
        // but somehow handles it automatically, dismisses the alert and test passes
        app.buttons["add place of interest button"].tap()
        XCTAssertTrue(app.isDisplayingSearchScreen)
    }

}


extension XCUIApplication {
    var isDisplayingMapLaunchScreen: Bool {
        return otherElements["Saved places map view"].exists
    }
    var isDisplayingSearchScreen: Bool {
        return otherElements["search for place of interest screen"].exists
    }
}
