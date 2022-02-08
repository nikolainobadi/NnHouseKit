//
//  HouseDetailVC.swift
//  
//
//  Created by Nikolai Nobadi on 2/3/22.
//

import UIKit
import NnUIViewKitPackage

public final class HouseDetailVC: NiblessViewController {
    
    // MARK: - Properties
    private let tableVC: UIViewController
    private let presenter: HouseDetailPresenter
    private let responder: HouseDetailUIResponder
    
    
    
    // MARK: - Views
    lazy var editHouseButton: UIButton = {
        ShadowButton("Edit", buttonType: .naked)
            .setColor(presenter.config.editButtonColor,
                      backgroundColor: .clear)
            .setFont(.smallDetail, fontName: .markerThin)
            .setAction { [weak self] in
                self?.responder.editHouse()
            }
    }()
    
    lazy var titleLabel: UILabel = {
        UILabel(presenter.houseName)
            .autoSize()
            .addShadow()
            .setAlignment(.center)
            .setColor(presenter.config.titleColor)
            .setFontByStyle(.largeTitle)
    }()
    
    lazy var showPasswordButton: UIButton = {
        ShadowButton("Show Household Password")
            .padding()
            .setFont(.detail)
            .setColor(presenter.config.passwordButtonTextColor,
                      backgroundColor: presenter.config.passwordButtonBackgroundColor)
            .setAction { [weak self] in
                self?.responder.showPassword()
            }
    }()
    
    lazy var switchButton: UIButton = {
        ShadowButton("Switch Household")
            .addBorder()
            .setFont(.largeDetail)
            .setColor(presenter.config.switchButtonTextColor,
                      backgroundColor: presenter.config.switchButtonBackgroundColor)
            .setAction { [weak self] in
                self?.responder.switchHouse()
            }
    }()
    
    
    // MARK: - Init
    public init(tableVC: UIViewController,
                presenter: HouseDetailPresenter,
                responder: HouseDetailUIResponder) {
        
        self.tableVC = tableVC
        self.presenter = presenter
        self.responder = responder
        super.init(hasTextFields: false)
    }
    
    
    // MARK: - Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupNavBar()
    }
}


// MARK: - Private Methods
private extension HouseDetailVC {
    
    func setupView() {
        addChild(tableVC)
        view.addSubview(titleLabel)
        view.addSubview(showPasswordButton)
        view.addSubview(switchButton)
        view.addSubview(tableVC.view)
        view.backgroundColor = presenter.config.viewBackgroundColor
        
        titleLabel.anchor(view.safeTopAnchor,
                          left: view.leftAnchor,
                          right: view.rightAnchor,
                          topConstant: view.heightPercent(1),
                          leftConstant: view.widthPercent(2),
                          rightConstant: view.widthPercent(2))
        
        showPasswordButton.anchorCenterXToSuperview()
        showPasswordButton.anchor(titleLabel.bottomAnchor,
                                  topConstant: view.heightPercent(1))
        
        switchButton.anchorCenterXToSuperview()
        switchButton.anchor(bottom: view.safeBottomAnchor,
                            bottomConstant: view.heightPercent(2),
                            widthConstant: view.widthPercent(80),
                            heightConstant: view.heightPercent(5))
        
        tableVC.view.anchor(showPasswordButton.bottomAnchor,
                            left: view.leftAnchor,
                            bottom: switchButton.topAnchor,
                            right: view.rightAnchor,
                            topConstant: view.heightPercent(5),
                            leftConstant: view.widthPercent(2),
                            bottomConstant: view.heightPercent(2),
                            rightConstant: view.widthPercent(2))
    }
    
    func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editHouseButton)
    }
}


// MARK: - Dependencies
public typealias HouseDetailUIResponder = (editHouse: () -> Void,
                                           switchHouse: () -> Void,
                                           showPassword: () -> Void)
public protocol HouseDetailPresenter {
    var houseName: String { get }
    var config: HouseDetailViewConfig { get }
}
