//
//  HouseListCellInfo.swift
//  
//
//  Created by Nikolai Nobadi on 2/7/22.
//

import UIKit

public protocol HouseListCellInfo {
    var name: String { get }
    var details: String { get }
    var detailsColor: UIColor? { get }
    var buttonText: String { get }
    var buttonColor: UIColor? { get }
    var showButton: Bool { get }
    var canDelete: Bool { get }
}
