//
//  URLSessionProtocol.swift
//  Sky
//
//  Created by SeacenLiu on 2018/7/5.
//  Copyright © 2018年 Mars. All rights reserved.
//

import Foundation

typealias DataTaskHandler = (Data?, URLResponse?, Error?) -> Void

protocol URLSessionProtocol {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping DataTaskHandler)
        -> URLSessionDataTaskProtocol
}
