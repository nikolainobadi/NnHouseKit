//
//  File.swift
//  
//
//  Created by Nikolai Nobadi on 2/3/22.
//

import UIKit
import NnUIViewKitPackage

public final class HouseDetailVC: NiblessViewController {
    
    // MARK: - Properties
    
    
    // MARK: - Init
    public init() {
        super.init(hasTextFields: false)
    }
    
    
    // MARK: - Life Cycle
    public override func loadView() {
        
    }
    
    public func doSomething() {
        print("Something Happened")
    }
}


// MARK: - Dependencies
protocol HouseDetailInterface: UIView {
    var editHouseBarButton: UIBarButtonItem { get }
    
    func updateHouseName(_ name: String)
//    func updateMembers(_ members: [HouseMemberViewModel])
}
