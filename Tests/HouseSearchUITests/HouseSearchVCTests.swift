//
//  HouseSearchVCTests.swift
//  
//
//  Created by Nikolai Nobadi on 2/7/22.
//

import XCTest
import HouseSearchUI

final class HouseSearchVCTests: XCTestCase {
    
    func test_viewDidLoad() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.children.count, 1)
        XCTAssertEqual(sut.view.subviews.count, 2)
        XCTAssertEqual(sut.navigationItem.title, "House Search")
    }
}


// MARK: - SUT
extension HouseSearchVCTests {
    
    func makeSUT() -> HouseSearchVC {
        HouseSearchVC(searchView: UIView(), tableVC: UIViewController())
    }
}
