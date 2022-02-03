//
//  File.swift
//  
//
//  Created by Nikolai Nobadi on 2/3/22.
//

import NnHousehold

public enum HouseDetailError: Error {
    case editHouse
    case deleteMember
    case noChange
    case shortName
    case shortPassword
    case houseNameTaken
    case uploadFailed
}


// MARK: - Message
extension HouseDetailError: ErrorWithMessage {
    
    public var message: String {
        switch self {
        case .editHouse:
            return "Only the creator of this house can make changes to its name and password."
        case .deleteMember:
            return "Only the creator of this house can delete other house members."
        case .noChange:
            return "You didn't really change anything. Or you left it all blank. Either way, nothing changed."
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

