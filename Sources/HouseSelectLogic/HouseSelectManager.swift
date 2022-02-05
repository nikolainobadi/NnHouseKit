//
//  HouseSelectManager.swift
//  
//
//  Created by Nikolai Nobadi on 2/5/22.
//

import NnHousehold

public final class HouseSelectManager {
    
    // MARK: - Properties
    private let policy: HouseSelectPolicy
    private let alerts: HouseSelectAlerts
    private let remote: HouseSelectRemoteAPI
    
    
    // MARK: - Init
    init(policy: HouseSelectPolicy,
         alerts: HouseSelectAlerts,
         remote: HouseSelectRemoteAPI) {
        
        self.policy = policy
        self.alerts = alerts
        self.remote = remote
    }
}


// MARK: - Dependencies
public protocol HouseSelectPolicy {
    var canCreateMoreHouses: Bool { get }
}

public protocol HouseSelectAlerts {
    func showCreateHouseAlert(completion: @escaping (String, String) -> Void)
}

public protocol HouseSelectRemoteAPI {
    func uploadNewHouse(_ house: Household, completion: @escaping (Error?) -> Void)
}
