//
//  NnHouse.swift
//  
//
//  Created by Nikolai Nobadi on 2/3/22.
//

public protocol NnHouse {
    associatedtype Member: NnHouseMember
    
    var id: String { get }
    var name: String { get set }
    var creator: String { get }
    var password: String { get set }
    var members: [Member] { get set }
    var lastLogin: String { get set }
}
