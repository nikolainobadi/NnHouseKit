//
//  JoinHouseVC.swift
//  
//
//  Created by Nikolai Nobadi on 2/8/22.
//

import UIKit
import NnUIKitHelpers

public final class JoinHouseVC: NnViewController {
    
    // MARK: - Properties
    private let rootView: UIView
    
    
    // MARK: - Init
    public init(rootView: UIView, fieldsToObserve: [UITextField]) {
        self.rootView = rootView
        super.init(hasTextFields: true, fieldsToObserve: fieldsToObserve)
    }
    
    
    // MARK: - Life Cycle
    public override func loadView() {
        view = rootView
    }
}
