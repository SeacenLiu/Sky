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
