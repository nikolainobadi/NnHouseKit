//
//  HouseMemberCellViewModel.swift
//  
//
//  Created by Nikolai Nobadi on 2/3/22.
//

import UIKit
import HouseDetailLogic

public struct HouseMemberCellViewModel {
    
    // MARK: - Properties
    private let info: HouseMemberViewInfo
    private let config: HouseMemberCellConfig
    private let responder: HouseMemberCellResponder
    

    // MARK: - Init
    init(info: HouseMemberViewInfo,
         config: HouseMemberCellConfig,
         responder: HouseMemberCellResponder) {
        
        self.info = info
        self.config = config
        self.responder = responder
    }
}


// MARK: - ViewModel
extension HouseMemberCellViewModel {
    
    public var id: String { info.memberId }
    public var name: String { info.memberName }
    public var adminStatus: String { info.adminStatus }
    public var showButton: Bool { info.showButton }
    public var buttonText: String { info.isAdmin ? "Remove Admin" : "Make Admin" }
    public var statusColor: UIColor? { nil }
    public var buttonBackgroundColor: UIColor? { nil }

    public func deleteMember() {
        responder.deleteMember(id)
    }

    public func toggleAdminStatus() {
        responder.toggleAdminStatus(id)
    }
}


// MARK: - Hashable
extension HouseMemberCellViewModel: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(info.memberId)
    }
    
    public static func == (lhs: HouseMemberCellViewModel, rhs: HouseMemberCellViewModel) -> Bool {
        
        lhs.info.memberId == rhs.info.memberId
    }
}


// MARK: - Dependencies
public typealias HouseMemberCellResponder = (
    deleteMember: (String) -> Void,
    toggleAdminStatus: (String) -> Void
)

