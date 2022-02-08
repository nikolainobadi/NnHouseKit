//
//  JoinHouseError.swift
//  
//
//  Created by Nikolai Nobadi on 2/8/22.
//

import NnHousehold

enum JoinHouseError: Error {
    case wrongPassword
}

extension JoinHouseError: ErrorWithMessage {
    
    var message: String {
        switch self {
        case .wrongPassword:
            return "Ask the creator of this household for the password. It's in settings under 'Manage Household'."
        }
    }
}
