//
//  WeekWeatherViewController.swift
//  Sky
//
//  Created by SeacenLiu on 2018/7/7.
//  Copyright © 2018年 Mars. All rights reserved.
//

import UIKit

class WeekWeatherViewController: WeatherViewController {
    
    @IBOutlet weak var weekWeatherTableView: UITableView!
    
    var viewModel: WeekWeatherViewModel? {
        didSet {
            DispatchQueue.main.async { self.updateView() }
        }
    }
    
    func updateView() {
        activityIndicatorView.stopAnimating()
        
        if let _ = viewModel {
            updateWeatherDataContainer()
        }
        else {
            loadingFailedLabel.isHidden = false
            loadingFailedLabel.text = "Load Location/Weather failed!"
        }
    }
    
    private func updateWeatherDataContainer() {
        weatherContainerView.isHidden = false
        weekWeatherTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}

extension WeekWeatherViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfDays ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: WeakWeatherTableViewCell.reuseIdentifier, for: indexPath) as? WeakWeatherTableViewCell
        
        guard let row = cell else {
            fatalError("Unexpected table view cell.")
        }
        
        if let weatherDay = viewModel?.viewModel(for: indexPath.row) {
            row.configure(with: weatherDay)
        }
        
        return row
    }
    
    
}
