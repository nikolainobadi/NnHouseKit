//
//  JoinHouseManager.swift
//  
//
//  Created by Nikolai Nobadi on 2/8/22.
//

import NnHousehold

public final class JoinHouseManager {
    
    // MARK: - Properties
    private let user: HouseholdUser
    private let currentHouse: Household?
    private let houseToJoin: Household
    private let alerts: JoinHouseAlerts
    private let remote: HouseholdAndUserRemoteAPI
    private let factory: HouseholdMemberFactory
    private let finished: () -> Void
    
    private var isCreator: Bool { user.name == houseToJoin.creator }
    
    
    // MARK: - Init
    public init(user: HouseholdUser,
                currentHouse: Household?,
                houseToJoin: Household,
                alerts: JoinHouseAlerts,
                remote: HouseholdAndUserRemoteAPI,
                factory: HouseholdMemberFactory,
                finished: @escaping () -> Void) {
        
        self.user = user
        self.currentHouse = currentHouse
        self.alerts = alerts
        self.remote = remote
        self.factory = factory
        self.houseToJoin = houseToJoin
        self.finished = finished
    }
}


// MARK: - UIResponder
extension JoinHouseManager {
    
    public func joinHouse(password: String) {
        guard isCreator || password == houseToJoin.password else {
            return alerts.showError(JoinHouseError.wrongPassword)
        }
        
        remote.upload(user: makeUpdatedUser(),
                      houses: makeUpdatedHouseList()) { [weak self] error in
            
            if let error = error {
                self?.alerts.showError(error)
            } else {
                self?.finished()
            }
        }
    }
}


// MARK: - Private Methods
private extension JoinHouseManager {
    
    func makeUpdatedUser() -> HouseholdUser {
        HouseholdAndUserModifier.makeUpdatedUser(user, houseId: houseToJoin.id)
    }
    
    func makeUpdatedHouseList() -> [Household] {
        var list = [Household]()
        
        if let oldHouse = currentHouse {
            list.append(HouseholdAndUserModifier.removeUser(user, from: oldHouse))
        }
        
        list.append(HouseholdAndUserModifier.addMember(factory.makeMember(), to: houseToJoin))
        
        return list
    }
}


// MARK: - Dependencies
public protocol JoinHouseAlerts {
    func showError(_ error: Error)
}

public protocol HouseholdMemberFactory {
    func makeMember() -> HouseholdMember
}
