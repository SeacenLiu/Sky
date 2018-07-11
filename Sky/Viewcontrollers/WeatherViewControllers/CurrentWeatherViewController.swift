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
        
        let viewModel =
            Observable.combineLatest(locationVM, weatherVM) {
                return ($0, $1)
                }
                .filter {
                    let (location, weather) = $0
                    return !(location.isEmpty) && !(weather.isEmpty)
                }
                .share(replay: 1, scope: .whileConnected)
                .observeOn(MainScheduler.instance)
        
        viewModel.map { _ in false }
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: bag)
        viewModel.map { _ in false }
            .bind(to: self.weatherContainerView.rx.isHidden)
            .disposed(by: bag)
        viewModel.map { $0.0.city }
            .bind(to: self.locationLabel.rx.text).disposed(by: bag)
        viewModel.map { $0.1.temperature }
            .bind(to: self.temperatureLabel.rx.text).disposed(by: bag)
        viewModel.map { $0.1.humidity }
            .bind(to: self.humidityLabel.rx.text).disposed(by: bag)
        viewModel.map { $0.1.summary }
            .bind(to: self.summaryLabel.rx.text).disposed(by: bag)
        viewModel.map { $0.1.date }
            .bind(to: self.dateLabel.rx.text).disposed(by: bag)
    }
}
