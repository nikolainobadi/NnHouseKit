//
//  HouseListCell.swift
//  
//
//  Created by Nikolai Nobadi on 2/7/22.
//

import UIKit

final class HouseListCell: UITableViewCell {
    
    // MARK: - Views
    private let rootView = HouseListCellContentView()
    
    
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
extension HouseListCell {
    
    func configure(_ viewModel: HouseListCellViewModel) {
        rootView.configureLabels(name: viewModel.name,
                                 secondary: viewModel.details,
                                 secondaryColor: viewModel.detailsColor)
        rootView.configureButton(title: viewModel.buttonText,
                                 color: viewModel.buttonColor,
                                 showButton: viewModel.showButton,
                                 action: { viewModel.buttonAction() })
    }
}




