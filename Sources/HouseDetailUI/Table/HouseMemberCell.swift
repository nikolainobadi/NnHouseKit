//
//  HouseMemberCell.swift
//  
//
//  Created by Nikolai Nobadi on 2/3/22.
//

import UIKit
import HouseDetailLogic

final class HouseMemberCell: UITableViewCell {
    
    // MARK: - Views
    private let rootView = HouseMemberCellContentView()
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(rootView)
    
        rootView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - Helper Methods
extension HouseMemberCell {
    
    func configure(_ viewModel: HouseMemberCellViewModel) {
        rootView.configureLabels(name: viewModel.name,
                                 secondary: viewModel.adminStatus,
                                 secondaryColor: viewModel.statusColor)
        rootView.configureButton(title: viewModel.buttonText,
                                 color: viewModel.buttonBackgroundColor,
                                 showButton: viewModel.showButton,
                                 action: { viewModel.toggleAdminStatus() })
    }
}



