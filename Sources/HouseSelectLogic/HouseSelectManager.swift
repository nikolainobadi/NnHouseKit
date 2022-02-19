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
    private let user: HouseholdUser
    private let policy: HouseSelectPolicy
    private let alerts: HouseSelectAlerts
    private let remote: HouseSelectRemoteAPI
    private let factory: HouseholdFactory
    private let finished: () -> Void
    private let showDeleteHouse: () -> Void

    
    // MARK: - Init
    public init(user: HouseholdUser,
                policy: HouseSelectPolicy,
                alerts: HouseSelectAlerts,
                remote: HouseSelectRemoteAPI,
                factory: HouseholdFactory,
                finished: @escaping () -> Void,
                showDeleteHouse: @escaping () -> Void) {
        
        self.user = user
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
                let errorToShow: HouseDetailError = error == .nameTaken ? .houseNameTaken : .uploadFailed
                self?.alerts.showError(errorToShow)
            } else {
                self?.uploadNewHouse(name: name, password: password)
            }
        }
    }
    
    func isValid(_ text: String) -> Bool {
        text != "" && text.count >= 4
    }
    
    func uploadNewHouse(name: String, password: String) {
        var houseList = [Household]()
        
        if let oldHouse = user.currentHouse {
            houseList.append(HouseholdAndUserModifier.removeUser(user, from: oldHouse))
        }
        
        let newHouse = factory.makeNewHouse(name: name, password: password)
        let updatedUser = makeUpdatedUser(user, houseId: newHouse.id)
        
        houseList.append(newHouse)
        
        remote.upload(user: updatedUser, houses: houseList) { [weak self] error in

            if let error = error {
                self?.alerts.showError(error)
            } else {
                self?.finished()
            }
        }
    }
    
    func makeUpdatedUser(_ user: HouseholdUser, houseId: String) -> HouseholdUser {
        
        HouseholdAndUserModifier
            .makeUpdatedUser(user, houseId: houseId, isCreator: true)
    }
}


// MARK: - Dependencies
public typealias HouseSelectRemoteAPI = HouseholdAndUserRemoteAPI & DuplcatesRemoteAPI

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
