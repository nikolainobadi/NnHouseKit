//
//  HouseSelectVC.swift
//  
//
//  Created by Nikolai Nobadi on 2/6/22.
//

import UIKit
import NnUIViewKitPackage

final class HouseSelectVC: NiblessViewController {
    
    // MARK: - Properties
    private let rootView: UIView
    private let finished: () -> Void
    
    
    // MARK: - Init
    init(rootView: UIView, finished: @escaping () -> Void) {
        self.rootView = rootView
        self.finished = finished
        super.init(hasTextFields: false)
    }
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "House Select"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isMovingFromParent {
            finished()
        }
    }
    
    override func loadView() {
        view = rootView
    }
}

