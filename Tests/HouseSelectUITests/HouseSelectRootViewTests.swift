//
//  HouseSelectRootViewTests.swift
//  
//
//  Created by Nikolai Nobadi on 2/6/22.
//

import XCTest
import TestHelpers
@testable import HouseSelectUI

final class HouseSelectRootViewTests: XCTestCase {
    
    func test_configDetails() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.backgroundColor, .systemBackground)
        XCTAssertEqual(sut.titleLabel.textColor, .label)
        XCTAssertEqual(sut.createButton.titleLabel?.textColor, .white)
        XCTAssertEqual(sut.createButton.backgroundColor, .black)
        XCTAssertEqual(sut.joinButton.titleLabel?.textColor, .white)
        XCTAssertEqual(sut.joinButton.backgroundColor, .black)
    }
    
    func test_createHouse() {
        let exp = expectation(description: "waiting for create...")
        let sut = makeSUT(createHouse: { exp.fulfill() })
        
        sut.createButton.sendActions(for: [.touchUpInside])
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_joinHouse() {
        let exp = expectation(description: "waiting for join...")
        let sut = makeSUT(showJoinHouse: { exp.fulfill() })
        
        sut.joinButton.sendActions(for: [.touchUpInside])
        
        waitForExpectations(timeout: 0.1)
    }
}


// MARK: - SUT
extension HouseSelectRootViewTests {
    
    func makeSUT(selectType: HouseSelectType = .noHouse,
                 createHouse: @escaping () -> Void = { },
                 showJoinHouse: @escaping () -> Void = { },
                 file: StaticString = #filePath, line: UInt = #line) -> HouseSelectRootView {
        
        let viewModel = HouseSelectViewModel(selectType: .noHouse,
                                             createHouse: createHouse,
                                             showJoinHouse: showJoinHouse)
        let sut = HouseSelectRootView(config: HouseSelectViewConfig(),
                                      viewModel: viewModel)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
}
