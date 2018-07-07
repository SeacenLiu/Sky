//
//  WeakWeatherTableViewCell.swift
//  Sky
//
//  Created by SeacenLiu on 2018/7/7.
//  Copyright © 2018年 Mars. All rights reserved.
//

import UIKit

class WeakWeatherTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "WeekWeatherCell"
    
    @IBOutlet weak var week: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var humid: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with vm: WeekWeatherDayRepresentable) {
        week.text = vm.week
        date.text = vm.date
        temperature.text = vm.temperature
        weatherIcon.image = vm.weatherIcon
        humid.text = vm.humidity
    }

}
