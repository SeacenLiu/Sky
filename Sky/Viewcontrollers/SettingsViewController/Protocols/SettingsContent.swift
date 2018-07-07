//
//  SettingsContent.swift
//  Sky
//
//  Created by SeacenLiu on 2018/7/7.
//  Copyright © 2018年 Mars. All rights reserved.
//

import UIKit

protocol SettingsRepresentable {
    var labelText: String { get }
    var accessory: UITableViewCellAccessoryType { get }
}
