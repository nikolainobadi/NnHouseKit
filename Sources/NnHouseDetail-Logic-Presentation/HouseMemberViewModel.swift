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
    private let responder: HouseMemberViewModelResponder
    
    
    // MARK: - Init
    public init(_ member: HouseholdMember,
                responder: HouseMemberViewModelResponder) {
        
        self.member = member
        self.responder = responder
    }
}


// MARK: - ViewModel
extension HouseMemberViewModel {
    
    public func deleteMember() {
        responder.deleteMember(member)
    }
    
    public func toggleAdminStatus() {
        responder.toggleAdminStatus(member)
    }
}


// MARK: - Dependencies
public typealias HouseMemberViewModelResponder = (
    deleteMember: (HouseholdMember) -> Void,
    toggleAdminStatus: (HouseholdMember) -> Void
)
