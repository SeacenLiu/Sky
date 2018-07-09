//
//  LocationsViewModel.swift
//  Sky
//
//  Created by SeacenLiu on 2018/7/9.
//  Copyright © 2018年 Mars. All rights reserved.
//

import Foundation
import CoreLocation

struct LocationsViewModel {
    
    let location: CLLocation
    
    var locationText: String?
    
    init(location: CLLocation, locationText: String?) {
        self.location = location
        self.locationText = locationText
    }
    
}

extension LocationsViewModel: LocationRepresentable {
    var labelText: String {
        if let text = locationText {
            return text
        }
        else {
            return location.toString
        }
    }
}
