//
//  HouseListCellContentView.swift
//  
//
//  Created by Nikolai Nobadi on 2/7/22.
//

import UIKit
import NnUIViewKitPackage

final class HouseListCellContentView: NiblessView {
    
    // MARK: - Properties
    private var buttonAction: (() -> Void)?
    
    
    // MARK: - Views
    lazy var nameLabel: UILabel = {
        UILabel()
            .setColor(.label)
            .setFontByStyle(.largeDetail)
    }()
    
    lazy var secondaryLabel: UILabel = {
        UILabel()
            .setColor(.label)
            .setFontByStyle(.smallDetail)
    }()
    
    lazy var cellButton: ShadowButton = {
        ShadowButton()
            .setColor(.white, backgroundColor: .black)
            .setFont(.detail)
            .addShadow(color: .label)
            .setAction { [weak self] in
                self?.buttonAction?()
            }
    }()
    
    
    // MARK: - Init
    init() {
        super.init(frame: .zero, color: .clear)
    }
    
    
    // MARK: - Display Setup
    override func addSubviews() {
        addSubview(nameLabel)
        addSubview(secondaryLabel)
        addSubview(cellButton)
    }
    
    override func setupConstraints() {
        nameLabel.anchor(topAnchor,
                         left: leftAnchor,
                         bottom: centerYAnchor,
                         topConstant: heightPercent(1),
                         leftConstant: widthPercent(2))
        
        secondaryLabel.anchor(centerYAnchor,
                              left: leftAnchor,
                              bottom: bottomAnchor,
                              topConstant: heightPercent(1),
                              leftConstant: widthPercent(2),
                              bottomConstant: heightPercent(1))
        
        cellButton.anchorCenterYToSuperview()
        cellButton.anchor(right: rightAnchor,
                          rightConstant: widthPercent(1),
                          widthConstant: widthPercent(32))
    }
    
    
    // MARK: - Helper Methods
    func configureLabels(name: String,
                         secondary: String,
                         secondaryColor: UIColor? = nil) {
        
        nameLabel.text = name
        secondaryLabel.text = secondary
        secondaryLabel.textColor = secondaryColor ?? .label
    }
    
    func configureButton(title: String = "",
                         color: UIColor? = nil,
                         showButton: Bool = true,
                         action: (() -> Void)? = nil) {
        
        cellButton.alpha = showButton ? 1 : 0
        cellButton.setTitle(title, for: .normal)
        setButtonColor(color)
        buttonAction = action
    }
    
    
    // MARK: - Private Methods
    private func setButtonColor(_ color: UIColor?) {
        if let color = color { cellButton.backgroundColor = color }
    }
}



