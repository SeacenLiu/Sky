//
//  WeekWeatherViewModel.swift
//  Sky
//
//  Created by SeacenLiu on 2018/7/7.
//  Copyright © 2018年 Mars. All rights reserved.
//

import Foundation

struct WeekWeatherViewModel {
    let weatherData: [ForecastData]
    
    static let empty = WeekWeatherViewModel(weatherData: [ForecastData]())
    
    static let invalid = WeekWeatherViewModel(weatherData: [ForecastData.invalid])
    
    var isEmpty: Bool {
        return self == WeekWeatherViewModel.empty
    }
    
    var isInvalid: Bool {
        return self == WeekWeatherViewModel.invalid
    }
    
    var numberOfSections: Int {
        return 1
    }
    
    var numberOfDays: Int {
        return weatherData.count
    }
    
    func viewModel(for index: Int) -> WeekWeatherDayViewModel {
        return WeekWeatherDayViewModel(weatherData: weatherData[index])
    }
}

extension WeekWeatherViewModel: Equatable {
    static func ==(lhs: WeekWeatherViewModel, rhs: WeekWeatherViewModel) -> Bool {
        return lhs.weatherData == rhs.weatherData
    }
}
