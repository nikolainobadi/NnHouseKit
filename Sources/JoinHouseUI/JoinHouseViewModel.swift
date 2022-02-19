//
//  JoinHouseViewModel.swift
//  
//
//  Created by Nikolai Nobadi on 2/8/22.
//

import UIKit
import NnHousehold

public final class JoinHouseViewModel {
    
    // MARK: - Properties
    private let info: JoinHouseViewModelInfo
    private let joinHouse: (String) -> Void
    
    
    // MARK: - Init
    public init(info: JoinHouseViewModelInfo,
                joinHouse: @escaping (String) -> Void) {
        
        self.info = info
        self.joinHouse = joinHouse
    }
}

// MARK: - View Model
extension JoinHouseViewModel {
    
    public var title: String { info.title}
    public var subtitle: String { "Creator: \(info.creator)"}
    public var details: String { info.details }
    public var showField: Bool { info.showField }
    public var showButton: Bool { info.showButton }
    
    public func verifyPassword(_ password: String) {
        joinHouse(password)
    }
}


// MARK: - Dependencies
public protocol JoinHouseViewModelInfo {
    var title: String { get }
    var creator: String { get }
    var details: String { get }
    var showField: Bool { get }
    var showButton: Bool { get }
}
