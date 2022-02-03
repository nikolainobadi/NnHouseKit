//
//  File.swift
//  
//
//  Created by Nikolai Nobadi on 2/3/22.
//

import UIKit
import Combine
import NnUIViewKitPackage
import NnHouseDetail_Logic_Presentation

public final class HouseDetailVC: NiblessViewController {
    
    // MARK: - Properties
    private let rootView: HouseDetailRootView
    private let presenter: HouseDetailPresenter
    
    private var changes = Set<AnyCancellable>()
    
    
    // MARK: - Init
    public init(rootView: HouseDetailRootView, presenter: HouseDetailPresenter) {
        self.rootView = rootView
        self.presenter = presenter
        super.init(hasTextFields: false)
    }
    
    
    // MARK: - Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        startObservers()
    }
    
    public override func loadView() {
        view = rootView
    }
}


// MARK: - Private Methods
private extension HouseDetailVC {
    
    func startObservers() {
        guard changes.isEmpty else { return }
        
        presenter.viewModelPublisher
            .sink { [weak self] in self?.updateList($0) }
            .store(in: &changes)
    }
    
    func updateList(_ viewModels: [HouseMemberViewModel]) {
        rootView.updateList(viewModels)
    }
}


// MARK: - Dependencies
protocol HouseDetailInterface: UIView {
    var editHouseBarButton: UIBarButtonItem { get }
    
    func updateList(_ members: [HouseMemberViewModel])
}
