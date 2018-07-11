//
//  CurrentWeatherViewController.swift
//  Sky
//
//  Created by SeacenLiu on 2018/7/6.
//  Copyright © 2018年 Mars. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol CurrentWeatherViewControllerDelegate: class {
    func locationButtonPressed(controller: CurrentWeatherViewController)
    func settingsButtonPressed(controller: CurrentWeatherViewController)
}


class CurrentWeatherViewController: WeatherViewController {
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    weak var delegate: CurrentWeatherViewControllerDelegate?
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        delegate?.locationButtonPressed(controller: self)
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        delegate?.settingsButtonPressed(controller: self)
    }
    
    private var bag = DisposeBag()
    
    var weatherVM: BehaviorRelay<CurrentWeatherViewModel> = BehaviorRelay(value: CurrentWeatherViewModel.empty)
    var locationVM: BehaviorRelay<CurrentLocationViewModel> = BehaviorRelay(value: CurrentLocationViewModel.empty)
    
    func updateView() {
        weatherVM.accept(weatherVM.value)
        locationVM.accept(locationVM.value)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Observable.combineLatest(locationVM, weatherVM) {
            return ($0, $1)
            }
            .filter {
                let (location, weather) = $0
                return !(location.isEmpty) && !(weather.isEmpty)
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                let (location, weather) = $0
                
                self.weatherContainerView.isHidden = false
                self.locationLabel.text = location.city
                
                self.temperatureLabel.text = weather.temperature
                self.weatherIcon.image = weather.weatherIcon
                self.humidityLabel.text = weather.humidity
                self.summaryLabel.text = weather.summary
                self.dateLabel.text = weather.date
            }).disposed(by: bag)
    }
}
