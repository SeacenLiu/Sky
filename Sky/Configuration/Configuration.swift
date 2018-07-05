//
//  Configuration.swift
//  Sky
//
//  Created by SeacenLiu on 2018/7/5.
//  Copyright © 2018年 Mars. All rights reserved.
//

import Foundation

struct API {
    static let key = "ea412bef956a78e5a3bf533b0001f69a"
    static let baseURL = URL(string: "https://api.darksky.net/forecast/")!
    static let authenticatedURL = baseURL.appendingPathComponent(key)
}
