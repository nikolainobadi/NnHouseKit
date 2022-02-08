//
//  JoinHouseVC.swift
//  
//
//  Created by Nikolai Nobadi on 2/8/22.
//

import UIKit
import Combine
import NnUIViewKitPackage

public final class JoinHouseVC: NiblessViewController {
    
    // MARK: - Properties
    private let store: HousePasswordStore
    private let rootView: JoinHouseInterface
    
    private var chanages = Set<AnyCancellable>()
    
    
    // MARK: - Init
    public init(store: HousePasswordStore, rootView: JoinHouseInterface) {
        self.store = store
        self.rootView = rootView
        super.init(hasTextFields: true)
    }
    
    
    // MARK: - Life Cycle
    public override func loadView() {
        view = rootView
    }
}


// MARK: - Private Methods
private extension JoinHouseVC {
    
    func startObservers() {
        guard chanages.isEmpty else { return }
        
        rootView.passwordPublisher
            .sink { [weak self] in self?.updatePassword($0) }
            .store(in: &chanages)
    }
    
    func updatePassword(_ pwd: String) {
        store.updatePassword(pwd)
        rootView.enableButton(pwd != "")
    }
}


// MARK: - Dependencies
public protocol HousePasswordStore {
    func updatePassword(_ password: String)
}

public protocol JoinHouseInterface: UIView {
    var passwordPublisher: AnyPublisher<String, Never> { get }
    
    func enableButton(_ enable: Bool)
}
