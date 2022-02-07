//
//  HouseSearchManager.swift
//  
//
//  Created by Nikolai Nobadi on 2/7/22.
//

public final class HouseSearchManager {
    
    // MARK: - Properties
    private let alerts: HouseSearchAlerts
    private let remote: HouseSearchRemoteAPI
    
    
    // MARK: - Init
    init(alerts: HouseSearchAlerts, remote: HouseSearchRemoteAPI) {
        self.alerts = alerts
        self.remote = remote
    }
}


// MARK: -
extension HouseSearchManager {
    
}


// MARK: - Dependencies
protocol HouseSearchAlerts {
    
}

protocol HouseSearchRemoteAPI {
    
}
