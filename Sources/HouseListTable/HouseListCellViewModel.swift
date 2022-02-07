//
//  HouseListCellViewModel.swift
//  
//
//  Created by Nikolai Nobadi on 2/7/22.
//

import UIKit
import NnHousehold

public struct HouseListCellViewModel {
    
    // MARK: - Properties
    public let name: String
    
    public let details: String
    public let detailsColor: UIColor?

    public let buttonText: String
    public let buttonColor: UIColor?
    public let showButton: Bool
    public let canDelete: Bool
    
    
    // MARK: - Init
//    public init(name: String, details: String, showButton: Bool, canDelete: Bool) {
//        self.name = name
//        self.details = details
//        self.showButton = showButton
//        self.canDelete = canDelete
//    }
}


// MARK: - Helper Methods
public extension HouseListCellViewModel {
    
    func delete() {
        
    }
    
    func buttonAction() {
        
    }
}


// MARK: - Hashable
extension HouseListCellViewModel: Hashable {
    
}
