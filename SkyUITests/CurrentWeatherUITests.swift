//
//  CurrentWeatherUITests.swift
//  SkyUITests
//
//  Created by SeacenLiu on 2018/7/6.
//  Copyright © 2018年 Mars. All rights reserved.
//

import XCTest

class CurrentWeatherUITests: XCTestCase {
    
    let app = XCUIApplication()
        
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        app.launchArguments += ["UI-TESTING"]
        app.launchEnvironment["FakeJSON"] = """
        {
        "longitude" : 100,
        "latitude" : 52,
        "currently" : {
        "temperature" : 23,
        "humidity" : 0.91,
        "icon" : "snow",
        "time" : 1507180335,
        "summary" : "Light Snow"
        },
        "daily": {
        "data": [
        {
        "time": 1507180335,
        "icon": "clear-day",
        "temperatureLow": 66,
        "temperatureHigh": 82,
        "humidity": 0.25
        }
        ]
        }
        }
        """
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_location_button_exists_withExpectation() {
        let locationBtn = app.buttons["LocationBtn"]
        let exists = NSPredicate(format: "exists == true")

        expectation(for: exists,
                    evaluatedWith: locationBtn,
                    handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssert(locationBtn.exists)
    }
    
    func test_location_button_exists() {
        XCTAssert(app.buttons["LocationBtn"].exists)
    }
    
    func test_current_weather_display() {
        XCTAssert(app.images["snow"].exists)
        XCTAssert(app.staticTexts["Light Snow"].exists)
    }
    
}
