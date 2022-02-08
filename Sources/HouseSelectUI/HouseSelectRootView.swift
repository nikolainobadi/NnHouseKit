//
//  HouseSelectRootView.swift
//  
//
//  Created by Nikolai Nobadi on 2/6/22.
//

import UIKit
import NnUIViewKitPackage

public final class HouseSelectRootView: NiblessView {
    
    // MARK: - Properties
    private let config: HouseSelectViewConfig
    private let viewModel: HouseSelectViewModel
    
    private var selectType: HouseSelectType { viewModel.selectType }
    
    
    // MARK: - Views
    lazy var titleLabel: UILabel = {
        UILabel(viewModel.title)
            .autoSize()
            .setAlignment(.center)
            .setColor(config.titleColor)
            .setFontByStyle(.largeTitle)
    }()
    
    lazy var topDetails: UILabel = {
        UILabel(viewModel.topDetails)
            .multipleLines()
            .setColor(.label)
            .setFontByStyle(.detail, fontName: .thonburi)
    }()
    
    lazy var bottomDetails: UILabel = {
        UILabel(viewModel.bottomDetails)
            .multipleLines()
            .setColor(.label)
            .setAlignment(selectType == .noHouse ? .left : .center)
            .setFontByStyle(.detail, fontName: .thonburi)
    }()
    
    lazy var createButton: ShadowButton = {
        ShadowButton("Create")
            .addBorder()
            .setColor(config.createButtonTextColor,
                      backgroundColor: config.createButtonBackgroundColor)
            .setAction { [weak self] in
                self?.viewModel.createHouse()
            }
    }()
    
    lazy var joinButton: ShadowButton = {
        ShadowButton("Join")
            .addBorder()
            .setColor(config.joinButtonTextColor,
                      backgroundColor: config.joinButtonBackgroundColor)
            .setAction { [weak self] in
                self?.viewModel.joinHouse()
            }
    }()
    
    
    // MARK: - Init
    public init(config: HouseSelectViewConfig, viewModel: HouseSelectViewModel) {
        self.config = config
        self.viewModel = viewModel
        super.init(frame: .zero, color: config.viewBackgroundColor)
    }
    
    
    // MARK: - Display Setup
    public override func addSubviews() {
        addSubview(titleLabel)
        addSubview(topDetails)
        addSubview(bottomDetails)
        addSubview(createButton)
        addSubview(joinButton)
    }
    
    public override func setupConstraints() {
        titleLabel.anchor(safeTopAnchor,
                          left: leftAnchor,
                          right: rightAnchor,
                          topConstant: heightPercent(1),
                          leftConstant: widthPercent(3),
                          rightConstant: widthPercent(3))
        
        setupDetailsConstraints()
        
        joinButton.anchorCenterXToSuperview()
        joinButton.anchor(bottom: safeBottomAnchor,
                          bottomConstant: heightPercent(3),
                          widthConstant: widthPercent(80),
                          heightConstant: buttonHeight)
        
        createButton.anchorCenterXToSuperview()
        createButton.anchor(bottom: joinButton.topAnchor,
                            bottomConstant: heightPercent(3),
                            widthConstant: widthPercent(80),
                            heightConstant: buttonHeight)
    }
}


// MARK: - Private Methods
private extension HouseSelectRootView {
    
    func setupDetailsConstraints() {
        if selectType == .noHouse {
            topDetails.anchor(titleLabel.bottomAnchor,
                              left: leftAnchor,
                              right: rightAnchor,
                              topConstant: heightPercent(1),
                              leftConstant: widthPercent(2),
                              rightConstant: widthPercent(2))
    
            bottomDetails.anchor(left: leftAnchor,
                                 bottom: createButton.topAnchor,
                                 right: rightAnchor,
                                 leftConstant: widthPercent(2),
                                 bottomConstant: heightPercent(3),
                                 rightConstant: widthPercent(2))
        } else {
            bottomDetails.anchor(left: leftAnchor,
                                 right: rightAnchor,
                                 leftConstant: widthPercent(3),
                                 rightConstant: widthPercent(3))
            bottomDetails.anchorCenterYToSuperview()
        }
    }
}
