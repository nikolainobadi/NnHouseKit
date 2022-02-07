//
//  HouseListTableVC.swift
//  
//
//  Created by Nikolai Nobadi on 2/7/22.
//

import UIKit
import Combine
import NnUIViewKitPackage

public final class HouseListTableVC: NiblessViewController {
    
    // MARK: - Properties
    private let presenter: HouseListPresenter
    
    private var changes = Set<AnyCancellable>()
    
    
    
    // MARK: - Init
    init(presenter: HouseListPresenter) {
        self.presenter = presenter
        super.init(hasTextFields: false)
    }
    
    
    // MARK: - Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        startObservers()
    }
}


// MARK: - Private Methods
private extension HouseListTableVC {
    
    func startObservers() {
        guard changes.isEmpty else { return }
        
//        presenter.viewModels
//            .sink { [weak self] _ in }
//            .store(in: &changes)
    }
}


// MARK: - Dependencies
public protocol HouseListPresenter {
    
}
