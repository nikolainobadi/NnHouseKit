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
    public var joinButtonTextColor: UIColor?
    public var joinButtonBackgroundColor: UIColor?
    public var joinButtonAdminBackgroundColor: UIColor?
    
    public init(titleLabelColor: UIColor? = nil,
                statusLabelColor: UIColor? = nil,
                joinButtonTextColor: UIColor? = nil,
                joinButtonBackgroundColor: UIColor? = nil,
                joinButtonAdminBackgroundColor: UIColor? = nil) {
        
        self.titleLabelColor = titleLabelColor
        self.statusLabelColor = statusLabelColor
        self.joinButtonTextColor = joinButtonBackgroundColor
        self.joinButtonBackgroundColor = joinButtonBackgroundColor
        self.joinButtonAdminBackgroundColor = joinButtonAdminBackgroundColor
    }
}
