//
//  Household.swift
//  
//
//  Created by Nikolai Nobadi on 2/3/22.
//

public protocol Household {
    var id: String { get }
    var name: String { get set }
    var creator: String { get }
    var password: String { get set }
    var members: [HouseholdMember] { get set }
    var lastLogin: String { get set }
}
