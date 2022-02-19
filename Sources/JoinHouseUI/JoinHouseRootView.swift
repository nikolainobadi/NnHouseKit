//
//  JoinHouseRootView.swift
//  
//
//  Created by Nikolai Nobadi on 2/8/22.
//

import UIKit
import NnUIKitHelpers

public final class JoinHouseRootView: NnView {
    
    // MARK: - Properties
    private let config: JoinHouseViewConfig
    private let viewModel: JoinHouseViewModel
    
    
    // MARK: - Views
    lazy var titleLabel: UILabel = {
        UILabel(viewModel.title)
            .autoSize()
            .addShadow()
            .setAlignment(.center)
            .setColor(config.titleColor)
            .setFontByStyle(.largeTitle)
    }()
    
    lazy var creatorLabel: UILabel = {
        UILabel(viewModel.subtitle)
            .autoSize()
            .setAlignment(.center)
            .setFontByStyle(.smallTitle)
            .setColor(config.subTitleColor)
    }()
    
    lazy var detailLabel: UILabel = {
        UILabel(viewModel.details)
            .multipleLines()
            .setAlignment(.center)
            .setFontByStyle(.detail, fontName: .thonburi)
    }()
    
    public lazy var passwordField: ShadowField = {
        ShadowField("Enter password...")
    }()
    
    lazy var joinButton: UIButton = {
        ShadowButton("Join")
            .setAlpha(viewModel.showButton ? 1 : 0)
            .setColor(config.buttonTextColor,
                      backgroundColor: config.buttonBackgroundColor)
            .setAction { [weak self] in
                self?.verifyPassword()
            }
    }()
    
    
    // MARK: - Init
    public init(config: JoinHouseViewConfig, viewModel: JoinHouseViewModel) {
        self.config = config
        self.viewModel = viewModel
        super.init(frame: .zero, color: config.viewBackgroundColor)
        
        passwordField.alpha = viewModel.showField ? 1 : 0
    }
    
    
    // MARK: - Display Setup
    public override func addSubviews() {
        addSubview(titleLabel)
        addSubview(creatorLabel)
        addSubview(detailLabel)
        addSubview(passwordField)
        addSubview(joinButton)
    }
    
    public override func setupConstraints() {
        titleLabel.anchor(safeTopAnchor,
                          left: leftAnchor,
                          right: rightAnchor,
                          topConstant: heightPercent(1),
                          leftConstant: widthPercent(3),
                          rightConstant: widthPercent(3))
        
        creatorLabel.anchor(titleLabel.bottomAnchor,
                            left: leftAnchor,
                            right: rightAnchor,
                            topConstant: heightPercent(1),
                            leftConstant: widthPercent(2),
                            rightConstant: widthPercent(2))
        
        detailLabel.anchor(creatorLabel.bottomAnchor,
                           left: leftAnchor,
                           right: rightAnchor,
                           topConstant: heightPercent(5),
                           leftConstant: widthPercent(10),
                           rightConstant: widthPercent(10))
        
        passwordField.anchorCenterXToSuperview()
        passwordField.anchor(detailLabel.bottomAnchor,
                             topConstant: heightPercent(10),
                             widthConstant: widthPercent(80))
        
        joinButton.anchorCenterXToSuperview()
        joinButton.anchor(passwordField.bottomAnchor,
                          topConstant: heightPercent(2),
                          widthConstant: widthPercent(80))
    }
}


// MARK: - Private Methods
private extension JoinHouseRootView {
    
    func verifyPassword() {
        viewModel.verifyPassword(passwordField.text ?? "")
    }
}
