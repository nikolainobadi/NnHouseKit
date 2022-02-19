//
//  File.swift
//  
//
//  Created by Nikolai Nobadi on 2/7/22.
//

import NnHousehold

public enum HouseSearchError: Error {
    case networkError, emptyListError, emptySearch
}

extension HouseSearchError: ErrorWithMessage {
    
    public var message: String {
        switch self {
        case .networkError:
            return "Looks like your internet connection is a little weak. Please try again."
        case .emptyListError:
            return emptyListMessage
        case .emptySearch:
            return "You have to type something in order to search."
        }
    }
    
    private var emptyListMessage: String {
        """
        There were no houses that matched your search.
        
        NOTE: Capiltalization DOES matter. Make sure you try with upper case AND lower case. Or simply ask the creator of the house you want to join for the exact spelling.
        """
    }
}
