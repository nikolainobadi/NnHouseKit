//
//  File.swift
//  
//
//  Created by Nikolai Nobadi on 2/8/22.
//

import NnHousehold

public protocol HouseholdUser {
    var id: String { get }
    var name: String { get }
    var houseId: String { get set }
    var currentHouse: Household? { get }
}
