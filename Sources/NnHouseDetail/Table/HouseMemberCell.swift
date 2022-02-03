//
//  File.swift
//  
//
//  Created by Nikolai Nobadi on 2/3/22.
//

import UIKit
import NnHouseDetail_Logic_Presentation

final class HouseMemberCell: UITableViewCell {
    
    // MARK: - Views
    private let rootView = HouseMemberCellContentView()
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Display Setup
    func setupView() {
        contentView.addSubview(rootView)
//        contentView.backgroundColor = ?

        rootView.fillSuperview()
    }
}


// MARK: - Helper Methods
extension HouseMemberCell {
    
    func configure(_ viewModel: HouseMemberCellViewModel) {
        
//        rootView.configureLabels(name: viewModel.name,
//                                 secondary: viewModel.status,
//                                 secondaryColor: myColor(.cleanRed))
//        rootView.configureButton(title: viewModel.buttonTitle,
//                                 color: getColor(viewModel.status != ""),
//                                 showButton: viewModel.showButton,
//                                 action: { viewModel.toggleAdminStatus() })
    }
}



