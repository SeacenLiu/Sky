//
//  WeatherData.swift
//  Sky
//
//  Created by SeacenLiu on 2018/7/5.
//  Copyright © 2018年 Mars. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let latitude: Double
    let longitude: Double
    let currentlt: CurrentWeather
    
    struct CurrentWeather: Codable {
        let time: Date
        let summary: String
        let icon: String
        let temperature: Double
        let humidity: Double
    }
}
