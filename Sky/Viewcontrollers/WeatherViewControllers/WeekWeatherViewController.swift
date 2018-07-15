//
//  WeekWeatherViewController.swift
//  Sky
//
//  Created by SeacenLiu on 2018/7/7.
//  Copyright © 2018年 Mars. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class WeekWeatherViewController: WeatherViewController {
    
    @IBOutlet weak var weekWeatherTableView: UITableView!
    
    private var bag = DisposeBag()
    
    var weekViewModel: BehaviorRelay<WeekWeatherViewModel> = BehaviorRelay(value: WeekWeatherViewModel.empty)
    
    func updateView() {
        weekViewModel.accept(weekViewModel.value)
    }
    
    private func updateWeatherDataContainer() {
        weatherContainerView.isHidden = false
        weekWeatherTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        weekWeatherTableView.tableFooterView = UIView()
        
        let viewModel = weekViewModel
            .share(replay: 1, scope: .whileConnected)
            .asDriver(onErrorJustReturn: .invalid)
        
        viewModel
            .filter { self.shouldHideActivityIndicator(weekVM: $0) }
            .map { _ in false }
            .drive(self.activityIndicatorView.rx.isAnimating)
            .disposed(by: bag)
        
        viewModel
            .filter { self.shouldAnimateActivityIndicator(weekVM: $0) }
            .map { _ in true }
            .drive(self.activityIndicatorView.rx.isAnimating)
            .disposed(by: bag)
        
        viewModel
            .map { self.shouldHideWeekWeatherContainer(weekVM: $0) }
            .drive(self.weatherContainerView.rx.isHidden)
            .disposed(by: bag)
        
        viewModel
            .filter { self.shouldDisplayWeekWeatherContainer(weekVM: $0) }
            .map { $0.weatherData }
            .drive(self.weekWeatherTableView.rx.items(cellIdentifier: WeekWeatherTableViewCell.reuseIdentifier, cellType: WeekWeatherTableViewCell.self)) { (row, element, cell) in
                cell.configure(with: WeekWeatherDayViewModel(weatherData: element))
            }.disposed(by: bag)
        
        let errorVM = viewModel
            .filter { self.shouldDisplayErrorPrompt(weekVM: $0) }
        
        errorVM
            .map { _ in "Load Location/Weather failed" }
            .drive(loadingFailedLabel.rx.text)
            .disposed(by: bag)
        
        errorVM
            .map { _ in false }
            .drive(loadingFailedLabel.rx.isHidden)
            .disposed(by: bag)
        
        weekWeatherTableView.rx.itemSelected
            .subscribe(onNext: {indexPath in
            self.weekWeatherTableView.deselectRow(at: indexPath, animated: true)
        })
            .disposed(by: bag)
        
    }
    
}

fileprivate extension WeekWeatherViewController {
    func shouldAnimateActivityIndicator(
        weekVM: WeekWeatherViewModel) -> Bool {
        return weekVM.isEmpty
    }
    
    func shouldHideActivityIndicator(
        weekVM: WeekWeatherViewModel) -> Bool {
        return !weekVM.isEmpty || weekVM.isInvalid
    }
    
    func shouldDisplayWeekWeatherContainer(
        weekVM: WeekWeatherViewModel) -> Bool {
        return !weekVM.isEmpty
    }
    
    func shouldDisplayErrorPrompt(
        weekVM: WeekWeatherViewModel) -> Bool {
        return weekVM.isInvalid
    }
    
    func shouldHideWeekWeatherContainer(
        weekVM: WeekWeatherViewModel) -> Bool {
        return weekVM.isInvalid || weekVM.isEmpty
    }
}
