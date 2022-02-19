//
//  JoinHouseViewConfig.swift
//  
//
//  Created by Nikolai Nobadi on 2/19/22.
//

import UIKit

public struct JoinHouseViewConfig {
    
    public var titleColor: UIColor?
    public var subTitleColor: UIColor?
    public var detailsColor: UIColor?
    public var buttonTextColor: UIColor?
    public var buttonBackgroundColor: UIColor?
    public var viewBackgroundColor: UIColor?
    
    public init(titleColor: UIColor?,
                subTitleColor: UIColor?,
                detailsColor: UIColor?,
                buttonTextColor: UIColor?,
                buttonBackgroundColor: UIColor?,
                viewBackgroundColor: UIColor?) {
        
        
        self.titleColor = titleColor
        self.subTitleColor = subTitleColor
        self.detailsColor = detailsColor
        self.buttonTextColor = buttonTextColor
        self.buttonBackgroundColor = buttonBackgroundColor
        self.viewBackgroundColor = viewBackgroundColor
    }
}
