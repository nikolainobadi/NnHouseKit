//
//  HouseDetailRootView.swift
//  
//
//  Created by Nikolai Nobadi on 2/3/22.
//

import UIKit
import HouseDetailLogic
import NnUIViewKitPackage

public final class HouseDetailRootView: NiblessView {
    
    // MARK: - Properties
    private let houseName: String
    private let config: HouseDetailViewConfig
    private let responder: HouseDetailUIResponder
    
    private lazy var dataSource: HouseDetailMembersDataSource = {
        HouseDetailMembersDataSource(tableView)
    }()
    
    
    // MARK: - Views
    lazy var editHouseButton: UIButton = {
        ShadowButton("Edit", buttonType: .naked)
            .setColor(config.editButtonColor, backgroundColor: .clear)
            .setFont(.smallDetail, fontName: .markerThin)
            .setAction { [weak self] in
                self?.responder.editHouse()
            }
    }()
    
    lazy var titleLabel: UILabel = {
        UILabel(houseName)
            .autoSize()
            .addShadow()
            .setAlignment(.center)
            .setColor(config.titleColor)
            .setFontByStyle(.largeTitle)
    }()
    
    lazy var showPasswordButton: UIButton = {
        ShadowButton("Show Household Password")
            .padding()
            .setFont(.detail)
            .setColor(config.passwordButtonTextColor,
                      backgroundColor: config.passwordButtonBackgroundColor)
            .setAction { [weak self] in
                self?.responder.showPassword()
            }
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        
        table.separatorColor = .label
        table.backgroundColor = .clear
        
        return table
    }()
    
    lazy var switchButton: UIButton = {
        ShadowButton("Switch Household")
            .addBorder()
            .setFont(.largeDetail)
            .setColor(config.switchButtonTextColor,
                      backgroundColor: config.switchButtonBackgroundColor)
            .setAction { [weak self] in
                self?.responder.switchHouse()
            }
    }()
    
    
    // MARK: - Init
    public init(houseName: String,
                config: HouseDetailViewConfig,
                responder: HouseDetailUIResponder) {
        
        self.houseName = houseName
        self.config = config
        self.responder = responder
        super.init(frame: .zero, color: config.viewBackgroundColor)
        
        setupTableView()
    }
    
    
    // MARK: - Display Setup
    public override func addSubviews() {
        addSubview(titleLabel)
        addSubview(showPasswordButton)
        addSubview(switchButton)
        addSubview(tableView)
    }
    
    public override func setupConstraints() {
        titleLabel.anchor(safeTopAnchor,
                          left: leftAnchor,
                          right: rightAnchor,
                          topConstant: heightPercent(1),
                          leftConstant: widthPercent(2),
                          rightConstant: widthPercent(2))
        
        showPasswordButton.anchorCenterXToSuperview()
        showPasswordButton.anchor(titleLabel.bottomAnchor,
                                  topConstant: heightPercent(1))
        
        switchButton.anchorCenterXToSuperview()
        switchButton.anchor(bottom: safeBottomAnchor,
                            bottomConstant: heightPercent(2),
                            widthConstant: widthPercent(80),
                            heightConstant: buttonHeight)
        
        tableView.anchor(showPasswordButton.bottomAnchor,
                         left: leftAnchor,
                         bottom: switchButton.topAnchor,
                         right: rightAnchor,
                         topConstant: heightPercent(5),
                         leftConstant: widthPercent(2),
                         bottomConstant: heightPercent(2),
                         rightConstant: widthPercent(2))
    }
}


// MARK: - Interface
extension HouseDetailRootView: HouseDetailInterface {
    
    public var editHouseBarButton: UIBarButtonItem {
        UIBarButtonItem(customView: editHouseButton)
    }
    
    public func updateList(_ members: [HouseMemberCellViewModel]) {
        dataSource.update(members)
    }
}


// MARK: - Private Methods
private extension HouseDetailRootView {
    
    func setupTableView() {
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        tableView.register(HouseMemberCell.self,
                           forCellReuseIdentifier: CELL_ID)
    }
}


// MARK: - Dependencies
public typealias HouseDetailUIResponder = (editHouse: () -> Void,
                                           switchHouse: () -> Void,
                                           showPassword: () -> Void)
