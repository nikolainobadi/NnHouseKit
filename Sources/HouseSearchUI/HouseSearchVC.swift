//
//  File.swift
//  
//
//  Created by Nikolai Nobadi on 2/7/22.
//

import UIKit
import NnUIViewKitPackage

public final class HouseSearchVC: NiblessViewController {
    
    // MARK: - Properties
    private let searchView: UIView
    private let tableVC: UIViewController
    private let backgroundColor: UIColor?
    
    
    // MARK: - Init
    public init(searchView: UIView,
                tableVC: UIViewController,
                backgroundColor: UIColor? = .systemBackground) {
        
        self.searchView = searchView
        self.tableVC = tableVC
        self.backgroundColor = backgroundColor
        super.init(hasTextFields: true)
    }
    
    
    // MARK: - Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
}


// MARK: - Private Methods
private extension HouseSearchVC {
    
    func setupView() {
        addChild(tableVC)
        view.addSubview(searchView)
        view.addSubview(tableVC.view)
        navigationItem.title = "House Search"
        view.backgroundColor = backgroundColor
        
        searchView.anchor(view.safeTopAnchor,
                          left: view.leftAnchor,
                          right: view.rightAnchor,
                          leftConstant: view.widthPercent(2),
                          rightConstant: view.widthPercent(2),
                          heightConstant: view.heightPercent(20))
        
        tableVC.view.anchor(searchView.bottomAnchor,
                            left: view.leftAnchor,
                            bottom: view.safeBottomAnchor,
                            right: view.rightAnchor,
                            leftConstant: view.widthPercent(2),
                            rightConstant: view.widthPercent(2))
    }
}
