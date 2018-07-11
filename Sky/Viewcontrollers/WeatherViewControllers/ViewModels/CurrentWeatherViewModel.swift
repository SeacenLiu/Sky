//
//  CurrentWeatherViewModel.swift
//  Sky
//
//  Created by SeacenLiu on 2018/7/6.
//  Copyright © 2018年 Mars. All rights reserved.
//

import UIKit

private let formatter = DateFormatter()

struct CurrentWeatherViewModel {
    var weather: WeatherData!
    
    static let empty = CurrentWeatherViewModel(
        weather: WeatherData.empty)
    
    var isEmpty: Bool {
        return self.weather == WeatherData.empty
    }
    
    var weatherIcon: UIImage {
        return UIImage.weatherIcon(of: weather.currently.icon)!
    }
    
    var temperature: String {
        let value = weather.currently.temperature
        
        switch UserDefaults.temperatureMode() {
        case .fahrenheit:
            return String(format: "%.1f °F", value)
        case .celsius:
            return String(format: "%.1f °C", value.toCelsius())
        }
    }
    
    var humidity: String {
        return String(
            format: "%.1f %%",
            weather.currently.humidity * 100)
    }
    
    var summary: String {
        return weather.currently.summary
    }
    
    var date: String {
        formatter.dateFormat = UserDefaults.dateMode().format
        
        return formatter.string(from: weather.currently.time)
    }
}
