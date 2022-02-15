//
//  HouseSelectManager.swift
//  
//
//  Created by Nikolai Nobadi on 2/5/22.
//

import NnHousehold
import HouseDetailLogic

public final class HouseSelectManager {
    
    // MARK: - Properties
    private let policy: HouseSelectPolicy
    private let alerts: HouseSelectAlerts
    private let remote: HouseholdAndUserRemoteAPI
    private let factory: HouseholdFactory
    private let finished: () -> Void
    private let showDeleteHouse: () -> Void

    
    // MARK: - Init
    public init(policy: HouseSelectPolicy,
                alerts: HouseSelectAlerts,
                remote: HouseholdAndUserRemoteAPI,
                factory: HouseholdFactory,
                finished: @escaping () -> Void,
                showDeleteHouse: @escaping () -> Void) {
        
        self.policy = policy
        self.alerts = alerts
        self.remote = remote
        self.factory = factory
        self.finished = finished
        self.showDeleteHouse = showDeleteHouse
    }
}


// MARK: - UIResponder
extension HouseSelectManager {
    
    public func createNewHouse() {
        guard policy.canCreateMoreHouses else { return showDeleteHouse() }
        
        alerts.showCreateHouseAlert { [weak self] name, password in
            self?.handleUserInput(name: name, password: password)
        }
    }
}


// MARK: - Private Methods
private extension HouseSelectManager {
    
    func handleUserInput(name: String, password: String) {
        guard isValid(name) else {
            return alerts.showError(HouseDetailError.shortName)
        }
        
        guard isValid(password) else {
            return alerts.showError(HouseDetailError.shortPassword)
        }
        
        remote.checkForDuplicates(name: name) { [weak self] error in
            if let error = error {
                self?.alerts.showError(error)
            } else {
                self?.uploadNewHouse(name: name, password: password)
            }
        }
    }
    
    func isValid(_ text: String) -> Bool {
        text != "" && text.count >= 4
    }
    
    func uploadNewHouse(name: String, password: String) {
        let newHouse = factory.makeNewHouse(name: name, password: password)
        
//        remote.upload(user: <#T##HouseholdUser#>,
//                      houses: <#T##[Household]#>) { [weak self] error in
//
//            if let error = error {
//                self?.alerts.showError(error)
//            } else {
//                self?.finished()
//            }
//        }
    }
}


// MARK: - Dependencies
public protocol HouseholdFactory {
    func makeNewHouse(name: String, password: String) -> Household
}

public protocol HouseSelectPolicy {
    var canCreateMoreHouses: Bool { get }
}

public protocol HouseSelectAlerts {
    func showError(_ error: Error)
    func showCreateHouseAlert(completion: @escaping (String, String) -> Void)
}
