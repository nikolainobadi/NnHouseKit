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
    
    public var name: String { member.name }
    
    public func deleteMember() {
        responder.deleteMember(member)
    }
    
    public func toggleAdminStatus() {
        responder.toggleAdminStatus(member)
    }
}


// MARK: - Hashable
extension HouseMemberViewModel: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(member.id)
    }
    
    public static func == (lhs: HouseMemberViewModel, rhs: HouseMemberViewModel) -> Bool {
        
        lhs.member.id == rhs.member.id
    }
}


// MARK: - Dependencies
public typealias HouseMemberViewModelResponder = (
    deleteMember: (HouseholdMember) -> Void,
    toggleAdminStatus: (HouseholdMember) -> Void
)
