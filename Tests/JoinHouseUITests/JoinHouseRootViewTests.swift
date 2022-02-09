//
//  JoinHouseRootViewTests.swift
//  
//
//  Created by Nikolai Nobadi on 2/8/22.
//

import XCTest
import TestHelpers
@testable import JoinHouseUI

final class JoinHouseRootViewTests: XCTestCase {
    
    func test_init_presenterNotVerifyingPassword() {
        let (_, presenter) = makeSUT()
        
        XCTAssertFalse(presenter.isVerifyingPassword)
    }
    
    func test_joinButton() {
        let (sut, presenter) = makeSUT()
        
        sut.joinButton.sendActions(for: [.touchUpInside])
        
        XCTAssertTrue(presenter.isVerifyingPassword)
    }
}


// MARK: - SUT
extension JoinHouseRootViewTests {
    
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: JoinHouseRootView, presenter: MockJoinHousePresenter) {
        
        let presenter = MockJoinHousePresenter()
        let sut = JoinHouseRootView(presenter: presenter)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, presenter)
    }
}


// MARK: - Helper Classes
extension JoinHouseRootViewTests {
    
    class MockJoinHousePresenter: JoinHousePresenter {
        
        var titleColor: UIColor? = nil
        var houseCreator: String = ""
        var details: String = ""
        var showField: Bool = false
        var showButton: Bool = false
        var buttonTextColor: UIColor? = nil
        var buttonBackgroundColor: UIColor? = nil
        var viewBackgroundColor: UIColor? = nil
        
        var isVerifyingPassword = false
        
        func verifyPassword() {
            isVerifyingPassword = true
        }
    }
}
