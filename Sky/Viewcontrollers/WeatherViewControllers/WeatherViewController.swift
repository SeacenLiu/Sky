//
//  WeatherViewController.swift
//  Sky
//
//  Created by SeacenLiu on 2018/7/6.
//  Copyright © 2018年 Mars. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var weatherContainerView: UIView!
    @IBOutlet weak var loadingFailedLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    private func setupView() {
        weatherContainerView.isHidden = true
        loadingFailedLabel.isHidden = true
        
        activityIndicatorView.startAnimating()
        activityIndicatorView.hidesWhenStopped = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }

}
