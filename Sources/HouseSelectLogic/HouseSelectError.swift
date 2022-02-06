//
//  File.swift
//  
//
//  Created by Nikolai Nobadi on 2/5/22.
//

import NnHousehold

public enum HouseSelectError: Error {
    case shortName
    case shortPassword
    case houseNameTaken
    case uploadFailed
}


// MARK: - Message
extension HouseSelectError: ErrorWithMessage {
    
    public var message: String {
        switch self {
        case .shortName:
            return "Households should have at least 4 letters. Please choose a longer name."
        case .shortPassword:
            return "House passwords should have at least 4 letters. Please choose a longer name."
        case .houseNameTaken:
            return "You've already created a household with that name. Please choose a different name."
        case .uploadFailed:
            return "Failed to updated details for your household due to weak internet connection."
        }
    }
}


