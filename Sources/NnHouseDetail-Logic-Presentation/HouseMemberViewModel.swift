//
//  HouseMemberViewModel.swift
//  
//
//  Created by Nikolai Nobadi on 2/3/22.
//

import NnHousehold

public struct HouseMemberViewModel {
    
    // MARK: - Properties
    private let member: HouseholdMember
    
    
    // MARK: - Init
    public init(_ member: HouseholdMember) {
        self.member = member
    }
}
