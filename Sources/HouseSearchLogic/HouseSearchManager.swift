//
//  HouseSearchManager.swift
//  
//
//  Created by Nikolai Nobadi on 2/7/22.
//

import NnHousehold

public final class HouseSearchManager {
    
    // MARK: - Properties
    private let alerts: HouseSearchAlerts
    private let remote: HouseSearchRemoteAPI
    
    private var searchByHouse = true
    
    
    // MARK: - Init
    public init(alerts: HouseSearchAlerts, remote: HouseSearchRemoteAPI) {
        self.alerts = alerts
        self.remote = remote
    }
}


// MARK: - SearchViewResponder
extension HouseSearchManager {
    
    public func changeSearchParameter(_ byHouseName: Bool) {
        searchByHouse = byHouseName
    }
    
    public func searchForHouse(_ text: String) {
        remote.search(for: text, byHouseName: searchByHouse) { [weak self] error in
            
            if let error = error {
                self?.alerts.showError(error)
            }
        }
    }
}

// MARK: - UIResponder
extension HouseSearchManager {
    
    func joinHouse() {
        
    }
}


// MARK: - Dependencies
public protocol HouseSearchAlerts {
    func showError(_ error: Error)
}

public protocol HouseSearchRemoteAPI {
    func search(for text: String,
                byHouseName: Bool,
                completion: @escaping (HouseSearchError?) -> Void)
}
