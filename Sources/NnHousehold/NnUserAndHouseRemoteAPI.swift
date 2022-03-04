//
//  NnUserAndHouseRemoteAPI.swift
//  
//
//  Created by Nikolai Nobadi on 2/15/22.
//

public protocol NnUserAndHouseRemoteAPI {
    associatedtype NnUser: NnHouseUser
    
    typealias NnHouse = NnUser.NnHouse
    
    func upload(user: NnUser,
                houses: [NnHouse],
                completion: @escaping (Error?) -> Void)
}
