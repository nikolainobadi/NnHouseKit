//
//  SearchViewConfig.swift
//  
//
//  Created by Nikolai Nobadi on 2/7/22.
//

import UIKit

public struct SearchViewConfig {
    public var searchControlTint: UIColor?
    public var findButtonTextColor: UIColor?
    public var findButtonBackgroundColor: UIColor?
    
    
    public init(searchControlTint: UIColor? = .systemBackground,
                findButtonTextColor: UIColor? = .systemBackground,
                findButtonBackgroundColor: UIColor? = .label) {
        
        self.searchControlTint = searchControlTint
        self.findButtonTextColor = findButtonTextColor
        self.findButtonBackgroundColor = findButtonBackgroundColor
    }
}
