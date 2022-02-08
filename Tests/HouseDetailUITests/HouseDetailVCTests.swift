//
//  HouseDetailVCTests.swift
//
//
//  Created by Nikolai Nobadi on 2/3/22.
//

import UIKit
import XCTest
import Combine
@testable import HouseDetailUI

final class HouseDetailVCTests: XCTestCase {
    
    func test_configDetails() {
        let (sut, _) = makeSUT()

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
        let (sut, _) = makeSUT(editHouse: { exp.fulfill() })

        sut.editHouseButton.sendActions(for: [.touchUpInside])

        waitForExpectations(timeout: 0.1)
    }

    func test_showPasswordButton() {
        let exp = expectation(description: "waiting for action...")
        let (sut, _) = makeSUT(showPassword: { exp.fulfill() })

        sut.showPasswordButton.sendActions(for: [.touchUpInside])

        waitForExpectations(timeout: 0.1)
    }

    func test_switchButton() {
        let exp = expectation(description: "waiting for action...")
        let (sut, _) = makeSUT(switchHouse: { exp.fulfill() })

        sut.switchButton.sendActions(for: [.touchUpInside])

        waitForExpectations(timeout: 0.1)
    }
}


// MARK: - SUT
extension HouseDetailVCTests {
    
    func makeSUT(editHouse: @escaping () -> Void = { },
                 switchHouse: @escaping () -> Void = { },
                 showPassword: @escaping () -> Void = { },
                 file: StaticString = #filePath, line: UInt = #line) -> (sut: HouseDetailVC, presenter: MockHouseDetailPresenter) {

        let presenter = MockHouseDetailPresenter(config: makeConfig())
        let sut = HouseDetailVC(tableVC: UIViewController(),
                                presenter: presenter,
                                responder: (editHouse, switchHouse, showPassword))

        trackForMemoryLeaks(sut, file: file, line: line)

        return (sut, presenter)
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


// MARK: - Helper Classes
extension HouseDetailVCTests {
    
    class MockHouseDetailPresenter: HouseDetailPresenter {
        var houseName: String = "testName"
        var config: HouseDetailViewConfig
        
        init(config: HouseDetailViewConfig) {
            self.config = config
        }
    }
}


