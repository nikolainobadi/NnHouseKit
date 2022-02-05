//
//  HouseMemberViewInfo.swift
//  
//
//  Created by Nikolai Nobadi on 2/3/22.
//

import NnHousehold

public protocol HouseMemberViewInfo {
    var memberId: String { get }
    var memberName: String { get }
    var adminStatus: String { get }
    var isAdmin: Bool { get }
    var showButton: Bool { get }
}
