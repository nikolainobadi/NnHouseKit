//
//  UserAndHouseStore.swift
//  
//
//  Created by Nikolai Nobadi on 3/2/22.
//

public protocol UserAndHouseStore {
    associatedtype User: HouseholdUser
    associatedtype House: Household
    
    var user: User { get }
    var house: House { get }
}
