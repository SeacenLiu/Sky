//
//  ViewController.swift
//  Sky
//
//  Created by Mars on 28/09/2017.
//  Copyright © 2017 Mars. All rights reserved.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa

class RootViewController: UIViewController {
    
    private var bag = DisposeBag()
    
    var currentWeatherViewController: CurrentWeatherViewController!
    var weekWeatherViewController: WeekWeatherViewController!
    private let segueCurrentWeather = "SegueCurrentWeather"
    private let segueWeekWeather = "SegueWeekWeather"
    private let segueSettings = "SegueSettings"
    private let segueLocations = "SegueLocations"
    
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case segueCurrentWeather:
            guard let destination = segue.destination as? CurrentWeatherViewController else {
                fatalError("Invalid destination view controller")
            }
            
            destination.delegate = self
            currentWeatherViewController = destination
        case segueWeekWeather:
            guard let destination = segue.destination as? WeekWeatherViewController else {
                fatalError("Invalid destination view controller")
            }
            weekWeatherViewController = destination
        case segueSettings:
            guard let navigationController =
                segue.destination as? UINavigationController else {
                fatalError("Invalid destination view controller")
            }
            
            guard let destination =
                navigationController.topViewController
                as? SettingsViewController else {
                fatalError("Invalid destination view controller")
            }
            
            destination.delegate = self
        case segueLocations:
            guard let navigationController = segue.destination
                as? UINavigationController else {
                fatalError("Invalid destination view controller")
            }
            
            guard let destination =
                navigationController.topViewController
                as? LocationsViewController else {
                fatalError("Invalid destination view controller")
            }
            
            destination.delegate = self
            destination.currentLocation = currentLocation
        default:
            break
        }
    }
    
    private var currentLocation: CLLocation? {
        didSet {
            // Fetch the city name
            fetchCity()
            // Fetch the weather data
            fetchWeather()
        }
    }
    
    private func fetchWeather() {
        guard let currentLocation = currentLocation else { return }
        
        let lat = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude
        
        let weather = WeatherDataManager.shared
            .weatherDataAt(latitude: lat, longitude: lon)
            .share(replay: 1, scope: .whileConnected)
            .observeOn(MainScheduler.instance)
        
        weather.map { CurrentWeatherViewModel(weather: $0) }
            .bind(to: self.currentWeatherViewController.weatherVM)
            .disposed(by: bag)
        
        weather.map {
            WeekWeatherViewModel(weatherData: $0.daily.data)
            }
            .subscribe(onNext: {
                self.weekWeatherViewController.viewModel = $0
            })
            .disposed(by: bag)
    }
    
    private func fetchCity() {
        guard let currentLocation = currentLocation else { return }
        
        CLGeocoder().reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            if let error = error {
                dump(error)
            }
            else if let city = placemarks?.first?.locality {
                // Notify CurrentWeatherViewcontroller
                let location = Location(
                    name: city,
                    latitude: currentLocation.coordinate.latitude,
                    longitude: currentLocation.coordinate.longitude)
                
                self.currentWeatherViewController.locationVM.accept(CurrentLocationViewModel(location: location))
            }
        }
    }
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.distanceFilter = 1000
        manager.desiredAccuracy = 1000
        
        return manager
    }()
    
    private func requestLocation() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            locationManager.rx.didUpdateLocations.take(1).subscribe(onNext: {
                self.currentLocation = $0.first
            }).disposed(by: bag)
        }
        else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActiveNotification()
    }
    
    @objc func aplicationDidBecomeActive(notification: Notification) {
        // Request user's location.
        requestLocation()
    }
    
    private func setupActiveNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(RootViewController.aplicationDidBecomeActive(notification:)),
            name: NSNotification.Name.UIApplicationDidBecomeActive,
            object: nil)
    }

}

extension RootViewController: CurrentWeatherViewControllerDelegate {
    func locationButtonPressed(controller: CurrentWeatherViewController) {
        print("Open location")
        performSegue(withIdentifier: segueLocations, sender: self)
    }
    
    func settingsButtonPressed(controller: CurrentWeatherViewController) {
        print("Open Settings")
        performSegue(withIdentifier: segueSettings, sender: self)
    }
    
}

extension RootViewController: SettingsViewControllerDelegate {
    private func reloadUI() {
        currentWeatherViewController.updateView()
        weekWeatherViewController.updateView()
    }
    
    func controllerDidChangeTimeMode(controller: SettingsViewController) {
        reloadUI()
    }
    
    func controllerDidChangeTemperatureMode(controller: SettingsViewController) {
        reloadUI()
    }
    
}

extension RootViewController: LocationsViewControllerDelegate {
    func controller(_ controller: LocationsViewController, didSelectLocation location: CLLocation) {
        currentLocation = location
    }
}

