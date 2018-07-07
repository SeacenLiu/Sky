//
//  WeekWeatherViewModel.swift
//  Sky
//
//  Created by SeacenLiu on 2018/7/7.
//  Copyright © 2018年 Mars. All rights reserved.
//

import UIKit

struct WeekWeatherViewModel {
    let weatherData: [ForecastData]
    
    private let dateFormatter = DateFormatter()
    
    func week(for index: Int) -> String {
        dateFormatter.dateFormat = "EEEE"
        
        return dateFormatter.string(from: weatherData[index].time)
    }
    
    func date(for index: Int) -> String {
        dateFormatter.dateFormat = "MMMM d"
        return dateFormatter.string(
            from: weatherData[index].time)
    }
    
    func temperature(for index: Int) -> String {
        let min = format(temperature: weatherData[index].temperatureLow)
        let max = format(temperature: weatherData[index].temperatureHigh)
        
        return "\(min) - \(max)"
    }
    
    func weatherIcon(for index: Int) -> UIImage? {
        return UIImage.weatherIcon(of: weatherData[index].icon)
    }
    
    func humidity(for index: Int) -> String {
        return String(format: "%0.f %%", weatherData[index].humidity*100)
    }
    
    var numberOfSections: Int {
        return 1
    }
    
    var numberOfDays: Int {
        return weatherData.count
    }
    
    /// Helpers
    private func format(temperature: Double) -> String {
        switch UserDefaults.temperatureMode() {
        case .fahrenheit:
            return String(format: "%.1f °F", temperature)
        case .celsius:
            return String(format: "%.1f °F", temperature.toCelsius())
        }
    }
}
