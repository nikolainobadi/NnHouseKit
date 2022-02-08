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
        let sut = makeSUT(backgroundColor: .orange)
        
        XCTAssertEqual(sut.children.count, 1)
        XCTAssertEqual(sut.view.subviews.count, 2)
        XCTAssertEqual(sut.navigationItem.title, "House Search")
        XCTAssertEqual(sut.view.backgroundColor, .orange)
    }
}


// MARK: - SUT
extension HouseSearchVCTests {
    
    func makeSUT(backgroundColor: UIColor?) -> HouseSearchVC {
        HouseSearchVC(searchView: UIView(),
                      tableVC: UIViewController(),
                      backgroundColor: backgroundColor)
    }
}
