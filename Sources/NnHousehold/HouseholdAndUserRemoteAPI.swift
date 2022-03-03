//
//  HouseholdAndUserRemoteAPI.swift
//  
//
//  Created by Nikolai Nobadi on 2/15/22.
//

public protocol HouseholdAndUserRemoteAPI {
    func upload(user: HouseholdUser,
                houses: [Household],
                completion: @escaping (Error?) -> Void)
}

public protocol NnUserAndHouseRemoteAPI {
    associatedtype User: NnHouseUser
    
    typealias House = User.House
    
    func upload(user: User,
                houses: [House],
                completion: @escaping (Error?) -> Void)
}
