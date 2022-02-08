//
//  HouseDetailRootViewTests.swift
//  
//
//  Created by Nikolai Nobadi on 2/3/22.
//

import XCTest
import TestHelpers
import HouseDetailLogic
@testable import HouseDetailUI

final class HouseDetailRootViewTests: XCTestCase {
    
    func test_configDetails() {
        let sut = makeSUT()

        XCTAssertEqual(sut.backgroundColor, .systemBackground)
        XCTAssertEqual(sut.editHouseButton.titleLabel?.textColor, .white)
        XCTAssertEqual(sut.titleLabel.textColor, .blue)
        XCTAssertEqual(sut.showPasswordButton.titleLabel?.textColor, .white)
        XCTAssertEqual(sut.showPasswordButton.backgroundColor, .blue)
        XCTAssertEqual(sut.switchButton.titleLabel?.textColor, .white)
        XCTAssertEqual(sut.switchButton.backgroundColor, .red)
    }

    func test_editHouseButton() {
        let exp = expectation(description: "waiting for action...")
        let sut = makeSUT(editHouse: { exp.fulfill() })

        sut.editHouseButton.sendActions(for: [.touchUpInside])

        waitForExpectations(timeout: 0.1)
    }

    func test_showPasswordButton() {
        let exp = expectation(description: "waiting for action...")
        let sut = makeSUT(showPassword: { exp.fulfill() })

        sut.showPasswordButton.sendActions(for: [.touchUpInside])

        waitForExpectations(timeout: 0.1)
    }

    func test_switchButton() {
        let exp = expectation(description: "waiting for action...")
        let sut = makeSUT(switchHouse: { exp.fulfill() })

        sut.switchButton.sendActions(for: [.touchUpInside])

        waitForExpectations(timeout: 0.1)
    }
    
    func test_updateList_cellViewModelProperties() {
        // MARK: - TODO
    }
}


// MARK: - SUT
extension HouseDetailRootViewTests {
    
    func makeSUT(houseName: String? = nil,
                 config: HouseDetailViewConfig? = nil,
                 editHouse: @escaping () -> Void = { },
                 switchHouse: @escaping () -> Void = { },
                 showPassword: @escaping () -> Void = { },
                 file: StaticString = #filePath, line: UInt = #line) -> HouseDetailRootView {


        let sut = HouseDetailRootView(houseName: houseName ?? getTestName(.testHouseName),
                                      config: config ?? makeConfig(),
                                      responder: (editHouse, switchHouse, showPassword))

        trackForMemoryLeaks(sut, file: file, line: line)

        return sut
    }

    func makeConfig() -> HouseDetailViewConfig {
        HouseDetailViewConfig(viewBackgroundColor: .systemBackground,
                              editButtonColor: .white,
                              titleColor: .blue,
                              passwordButtonTextColor: .white,
                              passwordButtonBackgroundColor: .blue,
                              switchButtonTextColor: .white,
                              switchButtonBackgroundColor: .red)
    }
}
