//
//  HouseMemberCellViewModel.swift
//  
//
//  Created by Nikolai Nobadi on 2/3/22.
//

import UIKit
import HouseDetailLogic

struct HouseMemberCellViewModel {
    
    // MARK: - Properties
    private let config: HouseMemberCellConfig
    private let viewModel: HouseMemberViewModel
    
    
    // MARK: - Init
    init(config: HouseMemberCellConfig, viewModel: HouseMemberViewModel) {
        self.config = config
        self.viewModel = viewModel
    }
}


// MARK: - ViewModel
extension HouseMemberCellViewModel {
    
    var name: String { viewModel.name }
    
    var showButton: Bool {
        false
    }
    
    var buttonBackgroundColor: UIColor? {
        nil
    }
    
    func deleteMember() {
        viewModel.deleteMember()
    }
    
    func toggleAdminStatus() {
        viewModel.toggleAdminStatus()
    }
}


// MARK: - Hashable
extension HouseMemberCellViewModel: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(viewModel)
    }
    
    static func == (lhs: HouseMemberCellViewModel, rhs: HouseMemberCellViewModel) -> Bool {
        
        lhs.viewModel == rhs.viewModel
    }
    
    
}
