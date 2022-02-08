//
//  HouseSelectVC.swift
//  
//
//  Created by Nikolai Nobadi on 2/6/22.
//

import UIKit
import NnUIViewKitPackage

public final class HouseSelectVC: NiblessViewController {
    
    // MARK: - Properties
    private let rootView: UIView
    private let finished: () -> Void
    
    
    // MARK: - Init
    public init(rootView: UIView, finished: @escaping () -> Void) {
        self.rootView = rootView
        self.finished = finished
        super.init(hasTextFields: false)
    }
    
    
    // MARK: - Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "House Select"
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isMovingFromParent {
            finished()
        }
    }
    
    public override func loadView() {
        view = rootView
    }
}

