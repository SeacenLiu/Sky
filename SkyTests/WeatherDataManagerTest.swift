//
//  WeatherDataManagerTest.swift
//  SkyTests
//
//  Created by SeacenLiu on 2018/7/5.
//  Copyright © 2018年 Mars. All rights reserved.
//

import XCTest
@testable import Sky

class WeatherDataManagerTest: XCTestCase {
    
    let url = URL(string: "https://darksky.net")!
    var session: MockURLSession!
    var manager: WeatherDataManager!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        session = MockURLSession()
        manager = WeatherDataManager(baseURL: url, urlSession: session)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_weatherDataAt_start_the_session() {
        let dataTask = MockURLSessionDataTask()
        session.sessionDataTask = dataTask
        
        manager.weatherDataAt(latitude: 52, longitude: 100) { (_, _) in}
        
        XCTAssert(session.sessionDataTask.isResumeCalled)
    }

    func test_weatherDataAt_gets_data() {
        let expect = expectation(description: "Loading data form \(API.authenticatedURL)")
        var data: WeatherData? = nil
        
        WeatherDataManager.shared.weatherDataAt(latitude: 52, longitude: 100, completion: { (response, error) in
            data = response
            expect.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(data)
    }
    
    func test_weatherDataAt_handle_invalid_request() {
        session.responseError = NSError(
            domain: "Invalid Request",
            code: 100,
            userInfo: nil)
        var error: DataManagerError? = nil
        
        manager.weatherDataAt(latitude: 52, longitude: 100) { (_, e) in
            error = e
        }
        
        XCTAssertEqual(error, DataManagerError.failedRequest)
    }
    
    func test_weatherDataAt_handle_statuscode_not_equal_to_200() {
        session.responseHeader = HTTPURLResponse(
            url: URL(string: "https://darksky.net")!,
            statusCode: 400,
            httpVersion: nil,
            headerFields: nil)
        
        let data = "{}".data(using: .utf8)!
        session.responseData = data
        
        var error: DataManagerError? = nil
        
        manager.weatherDataAt(latitude: 52, longitude: 100) { (_, e) in
            error = e
        }
        
        XCTAssertEqual(error, DataManagerError.failedRequest)
    }
    
    func test_weatherDataAt_handle_invalid_response() {
        session.responseHeader = HTTPURLResponse(
            url: URL(string: "https://darksky.net")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)
        
        let data = "{".data(using: .utf8)!
        session.responseData = data
        
        var error: DataManagerError? = nil
        
        manager.weatherDataAt(latitude: 52, longitude: 100) { (_, e) in
            error = e
        }
        
        XCTAssertEqual(error, DataManagerError.invalidResponse)
    }
    
    func test_weatherDataAt_handle_response_decode() {
        session.responseHeader = HTTPURLResponse(
            url: URL(string: "https://darksky.net")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)
        
        let data = """
        {
            "longitude" : 100,
            "latitude" : 52,
            "currently" : {
                "temperature" : 23,
                "humidity" : 0.91,
                "icon" : "snow",
                "time" : 1507180335,
                "summary" : "Light Snow"
            }
        }
        """.data(using: .utf8)!
        session.responseData = data
        
        var decoded: WeatherData? = nil
        
        manager.weatherDataAt(latitude: 52, longitude: 100, completion: { (d, _) in decoded = d })
        
        let expected = WeatherData(
            latitude: 52,
            longitude: 100,
            currently: WeatherData.CurrentWeather(
                time: Date(timeIntervalSince1970: 1507180335),
                summary: "Light Snow",
                icon: "snow",
                temperature: 23,
                humidity: 0.91))
        
        XCTAssertEqual(decoded, expected)
    }
}
