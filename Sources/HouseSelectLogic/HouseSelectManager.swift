//
//  HouseSelectManager.swift
//  
//
//  Created by Nikolai Nobadi on 2/5/22.
//

import NnHousehold
import HouseDetailLogic

public final class HouseSelectManager<Remote: HouseSelectRemoteAPI, Factory: NnHouseFactory> where Remote.House == Factory.House {
    
    public typealias User = Remote.User
    
    typealias House = Remote.House
    
    // MARK: - Properties
    private let user: User
    private let policy: HouseSelectPolicy
    private let alerts: HouseSelectAlerts
    private let remote: Remote
    private let factory: Factory
    private let router: HouseSelectRouter
    
    private var currentHouse: House? { user.currentHouse }

    
    // MARK: - Init
    public init(user: User,
                policy: HouseSelectPolicy,
                alerts: HouseSelectAlerts,
                remote: Remote,
                factory: Factory,
                router: HouseSelectRouter) {
        
        self.user = user
        self.policy = policy
        self.alerts = alerts
        self.remote = remote
        self.factory = factory
        self.router = router
    }
}


// MARK: - UIResponder
extension HouseSelectManager {
    
    public func createNewHouse() {
        guard policy.canCreateMoreHouses else {
            return router.showDeleteHouse()
        }
        
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
        var houseList = [House]()
        
        if let oldHouse = currentHouse {
            houseList.append(removeUserFromHouse(oldHouse))
        }
        
        let newHouse = factory.makeNewHouse(name: name,
                                            password: password)
        let updatedUser = makeUpdatedUser(user,
                                          houseId: newHouse.id)
        houseList.append(newHouse)
        
        remote.upload(user: updatedUser, houses: houseList) { [weak self] error in

            if let error = error {
                self?.alerts.showError(error)
            } else {
                self?.router.finished()
            }
        }
    }
    
    func removeUserFromHouse(_ house: House) -> House {
        NnUserAndHouseModifier.removeUser(user, from: house)
    }
    
    func makeUpdatedUser(_ user: User, houseId: String) -> User {
        NnUserAndHouseModifier.makeUpdatedUser(user,
                                               houseId: houseId,
                                               isCreator: true)
    }
}


// MARK: - Dependencies
public typealias HouseSelectRouter = (finished: () -> Void,
                                      showDeleteHouse: () -> Void)

public typealias HouseSelectRemoteAPI = NnUserAndHouseRemoteAPI & DuplcatesRemoteAPI

public protocol NnHouseFactory {
    associatedtype House: NnHouse
    
    func makeNewHouse(name: String, password: String) -> House
}

public protocol HouseSelectPolicy {
    var canCreateMoreHouses: Bool { get }
}

public protocol HouseSelectAlerts {
    func showError(_ error: Error)
    func showCreateHouseAlert(completion: @escaping (String, String) -> Void)
}
