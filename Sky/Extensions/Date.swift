//
//  Date.swift
//  Sky
//
//  Created by SeacenLiu on 2018/7/13.
//  Copyright © 2018年 Mars. All rights reserved.
//

import Foundation

extension Date {
    public static func from(string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+8:00")
        return dateFormatter.date(from: string)!
    }
}
