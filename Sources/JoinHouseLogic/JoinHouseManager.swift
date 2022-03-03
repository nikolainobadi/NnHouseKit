//
//  JoinHouseManager.swift
//  
//
//  Created by Nikolai Nobadi on 2/8/22.
//

import NnHousehold

public final class JoinHouseManager<Remote: NnUserAndHouseRemoteAPI, Factory: NnHouseMemberFactory> where Remote.House.Member == Factory.Member {
    
    public typealias User = Remote.User
    public typealias House = Remote.House
    public typealias Member = House.Member
    
    // MARK: - Properties
    private let user: User
    private let houseToJoin: House
    private let alerts: JoinHouseAlerts
    private let remote: Remote
    private let factory: Factory
    private let finished: () -> Void
    
    private var currentHouse: House? { user.currentHouse }
    private var isCreator: Bool { user.name == houseToJoin.creator }
    
    
    // MARK: - Init
    public init(user: User,
                houseToJoin: House,
                alerts: JoinHouseAlerts,
                remote: Remote,
                factory: Factory,
                finished: @escaping () -> Void) {
        
        self.user = user
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
    
    func makeUpdatedUser() -> User {
        NnUserAndHouseModifier.makeUpdatedUser(user,
                                               houseId: houseToJoin.id)
    }
    
    func makeUpdatedHouseList() -> [House] {
        var list = [House]()
        
        if let oldHouse = currentHouse {
            list.append(removeUserFromHouse(oldHouse))
        }
        
        list.append(addMemberToHouse(houseToJoin))
        
        return list
    }
    
    func removeUserFromHouse(_ house: House) -> House {
        NnUserAndHouseModifier.removeUser(user, from: house)
    }
    
    func addMemberToHouse(_ house: House) -> House {
        NnUserAndHouseModifier.addMember(factory.makeMember(), to: house)
    }
}


// MARK: - Dependencies
public protocol JoinHouseAlerts {
    func showError(_ error: Error)
}

public protocol NnHouseMemberFactory {
    associatedtype Member: NnHouseMember
    
    func makeMember() -> Member
}
