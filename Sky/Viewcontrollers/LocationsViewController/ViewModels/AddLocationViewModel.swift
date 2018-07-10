//
//  AddLocationViewModel.swift
//  Sky
//
//  Created by SeacenLiu on 2018/7/10.
//  Copyright © 2018年 Mars. All rights reserved.
//

import Foundation
import CoreLocation

class AddLocationViewModel {
    
    var queryText: String = "" {
        didSet {
            geocode(address: queryText)
        }
    }
    
    private func geocode(address: String?) {
        guard let address = address else {
            locations = []
            return
        }
        
        isQuerying = true
        
        geocoder.geocodeAddressString(address) {
            [weak self] (placemarks, error) in
            self?.processResponse(with: placemarks, error: error)
            self?.isQuerying = false
        }
    }
    
    private func processResponse(with placemarks: [CLPlacemark]?, error: Error?) {
        if let error = error {
            print("Cannot handle Geocode Address! \(error)")
        }
        else if let results = placemarks {
            locations = results.compactMap {
                result -> Location? in
                guard let name = result.name else { return nil }
                guard let location = result.location else { return nil }
                
                return Location(name: name,
                                latitude: location.coordinate.latitude,
                                longitude: location.coordinate.longitude)
            }
        }
    }
    
    private var isQuerying = false {
        didSet {
            queryingStatusDidChange?(isQuerying)
        }
    }
    
    private var locations: [Location] = [] {
        didSet {
            locationsDidChange?(locations)
        }
    }
    
    private lazy var geocoder = CLGeocoder()
    
    var queryingStatusDidChange: ((Bool) -> Void)?
    var locationsDidChange: (([Location]) -> Void)?
    
    var numberOfLocations: Int { return locations.count }
    var hasLocationsResult: Bool {
        return numberOfLocations > 0
    }
    
    func location(at index: Int) -> Location? {
        guard index < numberOfLocations else {
            return nil
        }
        
        return locations[index]
    }
    
    func locationViewModel(at index: Int) -> LocationRepresentable? {
        guard let location = location(at: index) else {
            return nil
        }
        
        return LocationsViewModel(location: location.location, locationText: location.name)
    }

}
