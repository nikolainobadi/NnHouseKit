//
//  HouseSelectViewConfig.swift
//  
//
//  Created by Nikolai Nobadi on 2/6/22.
//

import UIKit

public struct HouseSelectViewConfig {
    
    public var viewBackgroundColor: UIColor?
    public var titleColor: UIColor?
    public var createButtonTextColor: UIColor?
    public var createButtonBackgroundColor: UIColor?
    public var joinButtonTextColor: UIColor?
    public var joinButtonBackgroundColor: UIColor?
    
    
    public init(viewBackgroundColor: UIColor? = .systemBackground,
                titleColor: UIColor? = .label,
                createButtonTextColor: UIColor? = .white,
                createButtonBackgroundColor: UIColor? = .black,
                joinButtonTextColor: UIColor? = .white,
                joinButtonBackgroundColor: UIColor? = .black) {
        
        self.viewBackgroundColor = viewBackgroundColor
        self.titleColor = titleColor
        self.createButtonTextColor = createButtonTextColor
        self.createButtonBackgroundColor = createButtonBackgroundColor
        self.joinButtonTextColor = joinButtonTextColor
        self.joinButtonBackgroundColor = joinButtonBackgroundColor
    }
}
