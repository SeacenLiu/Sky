//
//  LocationTableViewCell.swift
//  Sky
//
//  Created by SeacenLiu on 2018/7/9.
//  Copyright © 2018年 Mars. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    static let reuseIdentifier = "LocationsTableViewCell"
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func config(from vm: LocationRepresentable) {
        label.text = vm.labelText
    }

}
