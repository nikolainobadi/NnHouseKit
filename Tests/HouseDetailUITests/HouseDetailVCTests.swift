//
//  HouseDetailVCTests.swift
//
//
//  Created by Nikolai Nobadi on 2/3/22.
//

import UIKit
import XCTest
import Combine
import TestHelpers
@testable import HouseDetailUI

final class HouseDetailVCTests: XCTestCase {
    
    func test_configDetails() {
        let sut = makeSUT()

        XCTAssertEqual(sut.view.backgroundColor, .systemBackground)
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
}


// MARK: - SUT
extension HouseDetailVCTests {
    
    func makeSUT(editHouse: @escaping () -> Void = { },
                 switchHouse: @escaping () -> Void = { },
                 showPassword: @escaping () -> Void = { },
                 file: StaticString = #filePath, line: UInt = #line) -> HouseDetailVC {
        
        let sut = HouseDetailVC(tableVC: UIViewController(),
                                houseName: getTestName(.testHouseName),
                                config: makeConfig(),
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
