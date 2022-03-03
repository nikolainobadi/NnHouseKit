//
//  NnUserAndHouseRemoteAPI.swift
//  
//
//  Created by Nikolai Nobadi on 2/15/22.
//

public protocol NnUserAndHouseRemoteAPI {
    associatedtype User: NnHouseUser
    
    typealias House = User.House
    
    func upload(user: User,
                houses: [House],
                completion: @escaping (Error?) -> Void)
}
