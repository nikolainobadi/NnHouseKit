//
//  HouseholdMember.swift
//  
//
//  Created by Nikolai Nobadi on 2/3/22.
//

public protocol HouseholdMember {
    var id: String { get }
    var name: String { get set }
    var isAdmin: Bool { get set }
}
