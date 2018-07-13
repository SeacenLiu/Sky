//
//  CurrentLocationViewModel.swift
//  Sky
//
//  Created by SeacenLiu on 2018/7/11.
//  Copyright © 2018年 Mars. All rights reserved.
//

import Foundation

struct CurrentLocationViewModel {
    var location: Location
    
    var city: String {
        return location.name
    }
    
    static let empty = CurrentLocationViewModel(
        location: Location.empty)
    
    var isEmpty: Bool {
        return self.location == Location.empty
    }
    
    var isInvalid: Bool {
        return self.location == Location.invalid
    }
}
