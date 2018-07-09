//
//  CLLocation.swift
//  Sky
//
//  Created by SeacenLiu on 2018/7/9.
//  Copyright © 2018年 Mars. All rights reserved.
//

import CoreLocation

extension CLLocation {
    var toString: String {
        let latitude = String(format: "%.3f", coordinate.latitude)
        let longitude = String(format: "%.3f", coordinate.longitude)
        
        return "\(latitude), \(longitude)"
    }
}
