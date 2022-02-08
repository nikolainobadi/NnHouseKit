//
//  JoinHouseManager.swift
//  
//
//  Created by Nikolai Nobadi on 2/8/22.
//

import NnHousehold

public final class JoinHouseManager {
    
    // MARK: - Properties
    private let remote: JoinHouseRemoteAPI
    private let modifier: JoinHouseModifier
    
    
    // MARK: - Init
    init(remote: JoinHouseRemoteAPI, modifier: JoinHouseModifier) {
        self.remote = remote
        self.modifier = modifier
    }
}


// MARK: - UIResponder
extension JoinHouseManager {
    
    public func joinHouse(password: String) {
        
    }
}


// MARK: - Dependencies
public protocol JoinHouseModifier {
    
}

public protocol JoinHouseRemoteAPI {
    func upload(houses: [Household],
                completion: @escaping (Error?) -> Void)
}
