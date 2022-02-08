//
//  TestHouseListCellInfo.swift
//  
//
//  Created by Nikolai Nobadi on 2/7/22.
//

import UIKit
import HouseListTable

struct TestHouseListCellInfo: HouseListCellInfo {
    var id: String = ""
    var name: String = ""
    var details: String = ""
    var detailsColor: UIColor? = .label
    var buttonText: String = ""
    var buttonColor: UIColor? = nil
    var showButton: Bool = false
    var canDelete: Bool = false
}
