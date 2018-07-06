//
//  MockURLSession.swift
//  SkyTests
//
//  Created by SeacenLiu on 2018/7/5.
//  Copyright © 2018年 Mars. All rights reserved.
//

import Foundation
@testable import Sky

class MockURLSession: URLSessionProtocol {
    var responseData: Data?
    var responseHeader: HTTPURLResponse?
    var responseError: Error?
    var sessionDataTask = MockURLSessionDataTask()
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskHandler) -> URLSessionDataTaskProtocol {
        completionHandler(responseData, responseHeader, responseError)
        return sessionDataTask
    }
}
