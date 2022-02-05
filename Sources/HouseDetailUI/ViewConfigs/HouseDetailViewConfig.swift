//
//  HouseDetailViewConfig.swift
//  
//
//  Created by Nikolai Nobadi on 2/3/22.
//

import UIKit

public struct HouseDetailViewConfig {
    
    public var viewBackgroundColor: UIColor?
    public var editButtonColor: UIColor?
    public var titleColor: UIColor?
    public var passwordButtonTextColor: UIColor?
    public var passwordButtonBackgroundColor: UIColor?
    public var switchButtonTextColor: UIColor?
    public var switchButtonBackgroundColor: UIColor?
    
    
    public init(viewBackgroundColor: UIColor? = .systemBackground,
                editButtonColor: UIColor? = .white,
                titleColor: UIColor? = .label,
                passwordButtonTextColor: UIColor? = .white,
                passwordButtonBackgroundColor: UIColor? = .black,
                switchButtonTextColor: UIColor? = .white,
                switchButtonBackgroundColor: UIColor? = .black) {
        
        self.viewBackgroundColor = viewBackgroundColor
        self.editButtonColor = editButtonColor
        self.titleColor = titleColor
        self.passwordButtonTextColor = passwordButtonTextColor
        self.passwordButtonBackgroundColor = passwordButtonBackgroundColor
        self.switchButtonTextColor = switchButtonTextColor
        self.switchButtonBackgroundColor = switchButtonBackgroundColor
    }
}
