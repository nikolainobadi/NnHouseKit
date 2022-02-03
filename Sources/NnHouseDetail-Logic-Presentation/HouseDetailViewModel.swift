//
//  HouseDetailViewModel.swift
//  
//
//  Created by Nikolai Nobadi on 2/3/22.
//

import Foundation

public final class HouseDetailViewModel {
    
    // MARK: - Properties
    private let editHouse: () -> Void
    private let showPassword: () -> Void
    
    @Published private var viewModels = [HouseMemberViewModel]()
    
    
    // MARK: - Init
    public init(editHouse: @escaping () -> Void,
                showPassword: @escaping () -> Void) {
        
        self.editHouse = editHouse
        self.showPassword = showPassword
    }
}
