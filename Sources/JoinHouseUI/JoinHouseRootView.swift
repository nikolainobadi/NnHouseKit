//
//  File.swift
//  
//
//  Created by Nikolai Nobadi on 2/8/22.
//

import UIKit
import Combine
import NnUIViewKitPackage

public final class JoinHouseRootView: NiblessView {
    
    // MARK: - Properties
    private let presenter: JoinHousePresenter
    
    private var buttonAlpha: CGFloat {
        presenter.showButton ? 0.5 : 0
    }
    
    
    // MARK: - Views
    lazy var titleLabel: UILabel = {
        UILabel()
            .autoSize()
            .addShadow()
            .setAlignment(.center)
            .setColor(presenter.titleColor)
            .setFontByStyle(.largeTitle)
    }()
    
    lazy var creatorLabel: UILabel = {
        UILabel("Creator: \(presenter.houseCreator)")
            .autoSize()
            .setAlignment(.center)
            .setFontByStyle(.smallTitle)
    }()
    
    lazy var detailLabel: UILabel = {
        UILabel(presenter.details)
            .multipleLines()
            .setAlignment(.center)
            .setFontByStyle(.detail, fontName: .thonburi)
    }()
    
    lazy var passwordField: ShadowField = {
        ShadowField("Enter password...")
    }()
    
    lazy var joinButton: ShadowButton = {
        ShadowButton("Join")
            .setAlpha(buttonAlpha)
            .setEnabled(false)
            .setColor(presenter.buttonTextColor,
                      backgroundColor: presenter.buttonBackgroundColor)
            .setAction { [weak self] in
                self?.presenter.verifyPassword()
            }
    }()
    
    
    // MARK: - Init
    public init(presenter: JoinHousePresenter) {
        self.presenter = presenter
        super.init(frame: .zero)
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
                           topConstant: heightPercent(2),
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


// MARK: - Interface
extension JoinHouseRootView: JoinHouseInterface {
    
    public var passwordPublisher: AnyPublisher<String, Never> {
        passwordField.noWaitTextPublisher.eraseToAnyPublisher()
    }
    
    public func enableButton(_ enable: Bool) {
        joinButton.alpha = enable ? 1 : 0.5
        joinButton.isEnabled = enable
    }
}


// MARK: - Dependencies
public protocol JoinHousePresenter {
    var titleColor: UIColor? { get }
    var houseCreator: String { get }
    var details: String { get }
    var showField: Bool { get }
    var showButton: Bool { get }
    var buttonTextColor: UIColor? { get }
    var buttonBackgroundColor: UIColor? { get }
    
    func verifyPassword()
}
