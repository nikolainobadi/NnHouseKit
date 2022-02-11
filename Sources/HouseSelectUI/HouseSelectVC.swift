//
//  HouseSelectVC.swift
//  
//
//  Created by Nikolai Nobadi on 2/6/22.
//

import UIKit
import NnUIKitHelpers

public final class HouseSelectVC: NnViewController {
    
    // MARK: - Properties
    private let rootView: UIView

    
    // MARK: - Init
    public init(rootView: UIView) {
        self.rootView = rootView
        super.init(hasTextFields: false)
    }
    
    
    // MARK: - Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "House Select"
    }
    
    public override func loadView() {
        view = rootView
    }
}

