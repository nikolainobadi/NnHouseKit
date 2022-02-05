//
//  HouseMemberCellConfig.swift
//  
//
//  Created by Nikolai Nobadi on 2/3/22.
//

import UIKit

public struct HouseMemberCellConfig {
    
    public var titleLabelColor: UIColor?
    public var statusLabelColor: UIColor?
    public var buttonTextColor: UIColor?
    public var buttonNonAdminBackgroundColor: UIColor?
    public var buttonAdminBackgroundColor: UIColor?
    
    public init(titleLabelColor: UIColor? = nil,
                statusLabelColor: UIColor? = nil,
                buttonTextColor: UIColor? = nil,
                buttonAdminBackgroundColor: UIColor? = nil,
                buttonNonAdminBackgroundColor: UIColor? = nil) {
        
        self.titleLabelColor = titleLabelColor
        self.statusLabelColor = statusLabelColor
        self.buttonTextColor = buttonTextColor
        self.buttonAdminBackgroundColor = buttonAdminBackgroundColor
        self.buttonNonAdminBackgroundColor = buttonNonAdminBackgroundColor
    }
}
