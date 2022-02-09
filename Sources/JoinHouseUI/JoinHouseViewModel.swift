//
//  JoinHouseViewModel.swift
//  
//
//  Created by Nikolai Nobadi on 2/8/22.
//

import UIKit

public final class JoinHouseViewModel {
    
    // MARK: - Properties
    private let joinHouse: (String) -> Void
    
    private var password = ""
    
    
    // MARK: - Init
    init(joinHouse: @escaping (String) -> Void) {
        self.joinHouse = joinHouse
    }
}


// MARK: - PasswordStore
extension JoinHouseViewModel: HousePasswordStore {
    
    public func updatePassword(_ password: String) {
        self.password = password
    }
}


// MARK: - Presenter
extension JoinHouseViewModel: JoinHousePresenter {
    
    public var titleColor: UIColor? { nil }
    public var houseCreator: String { "" }
    public var details: String { "" }
    public var showField: Bool { false }
    public var showButton: Bool { false }
    public var buttonTextColor: UIColor? { nil }
    public var buttonBackgroundColor: UIColor? { nil }
    public var viewBackgroundColor: UIColor? { nil }
    
    public func verifyPassword() {
        joinHouse(password)
    }
}
