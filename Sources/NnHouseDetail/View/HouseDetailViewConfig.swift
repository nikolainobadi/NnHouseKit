//
//  HouseDetailViewConfig.swift
//  
//
//  Created by Nikolai Nobadi on 2/3/22.
//

import UIKit

public struct HouseDetailViewConfig {
    
    public var editButtonColor: UIColor?
    public var titleColor: UIColor?
    public var passwordButtonTextColor: UIColor?
    public var passwordButtonBackgroundColor: UIColor?
    public var switchButtonTextColor: UIColor?
    public var switchButtonBackgroundColor: UIColor?
    public var houseMemberCellConfig: HouseMemberCellConfig
    
    
    public init(editButtonColor: UIColor? = nil,
                titleColor: UIColor? = nil,
                passwordButtonTextColor: UIColor? = nil,
                passwordButtonBackgroundColor: UIColor? = nil,
                switchButtonTextColor: UIColor? = nil,
                switchButtonBackgroundColor: UIColor? = nil,
                houseMemberCellConfig: HouseMemberCellConfig) {
        
        self.editButtonColor = editButtonColor
        self.titleColor = titleColor
        self.passwordButtonTextColor = passwordButtonTextColor
        self.passwordButtonBackgroundColor = passwordButtonBackgroundColor
        self.switchButtonTextColor = switchButtonTextColor
        self.switchButtonBackgroundColor = switchButtonBackgroundColor
        self.houseMemberCellConfig = houseMemberCellConfig
    }
}
