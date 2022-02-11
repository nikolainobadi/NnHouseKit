//
//  HouseSearchSearchView.swift
//  
//
//  Created by Nikolai Nobadi on 2/7/22.
//

import UIKit
import NnUIKitHelpers

public final class HouseSearchSearchView: NnView {
    
    // MARK: - Properties
    private let config: SearchViewConfig
    private let responder: SearchViewResponder
    
    
    // MARK: - Views
    lazy var searchControl: UISegmentedControl = {
        CustomControl(items: ["By House Name", "By House Creator"])
            .setItemFonts()
            .setBackgroundColor(config.searchControlTint)
            .setAction { [weak self] in
                self?.changeSearchParameters()
            }
    }()
    
    lazy var searchField: UITextField = {
        ShadowField("Enter House name...")
    }()
    
    lazy var findButton: UIButton = {
        ShadowButton("Find")
            .addBorder()
            .setColor(config.findButtonTextColor,
                      backgroundColor: config.findButtonBackgroundColor)
            .setAction { [weak self] in
                self?.responder.searchForHouse(self?.searchField.text ?? "")
            }
    }()
    
    
    // MARK: - Init
    public init(config: SearchViewConfig, responder: SearchViewResponder) {
        self.config = config
        self.responder = responder
        super.init(frame: .zero, color: .clear)
    }
    
    
    // MARK: - Display Setup
    public override func addSubviews() {
        addSubview(searchControl)
        addSubview(searchField)
        addSubview(findButton)
    }
    
    public override func setupConstraints() {
        searchControl.anchorCenterXToSuperview()
        searchControl.anchor(safeTopAnchor,
                             topConstant: heightPercent(2))
        
        findButton.anchor(searchControl.bottomAnchor,
                          right: rightAnchor,
                          topConstant: heightPercent(2),
                          rightConstant: widthPercent(1),
                          widthConstant: widthPercent(30),
                          heightConstant: buttonHeight)
        
        searchField.anchor(searchControl.bottomAnchor,
                           left: leftAnchor,
                           right: findButton.leftAnchor,
                           topConstant: heightPercent(2),
                           leftConstant: widthPercent(1),
                           rightConstant: widthPercent(2),
                           heightConstant: buttonHeight)
    }
}


// MARK: - Private Methods
private extension HouseSearchSearchView {
    
    func changeSearchParameters() {
        let byHouseName = searchControl.selectedSegmentIndex == 0
        let searchParam = byHouseName ? "House" : "Creator's"
        
        searchField.placeholder = "Enter \(searchParam) name..."
        responder.changeSearchParameter(byHouseName)
    }
}


// MARK: - Dependencies
public typealias SearchViewResponder = (changeSearchParameter: (Bool) -> Void,
                                        searchForHouse: (String) -> Void)
