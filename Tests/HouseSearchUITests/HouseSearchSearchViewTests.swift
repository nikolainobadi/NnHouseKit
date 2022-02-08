//
//  HouseSearchSearchViewTests.swift
//  
//
//  Created by Nikolai Nobadi on 2/7/22.
//

import XCTest
import TestHelpers
@testable import HouseSearchUI

final class HouseSearchSearchViewTests: XCTestCase {
    
    // MARK: - Properties
    private let byHouseName = "Enter House name..."
    private let byHouseCreator = "Enter Creator's name..."
}
 

// MARK: - Unit Tests
extension HouseSearchSearchViewTests {

    func test_init_startingValues() {
        let sut = makeSUT()
        sut.layoutSubviews() // to run code for setupContraints
        
        
        XCTAssertEqual(sut.searchField.placeholder, byHouseName)
        XCTAssertEqual(sut.searchControl.selectedSegmentIndex, 0)
    }
    
    
    func test_configValues() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.findButton.backgroundColor, .label)
        XCTAssertEqual(sut.findButton.titleLabel?.textColor, .systemBackground)
        XCTAssertEqual(sut.searchControl.selectedSegmentTintColor, .systemBackground)
    }
    
    func test_changeSearchParameters_noChange() {
        let exp = expectation(description: "waiting for toggle...")
        let sut = makeSUT(changeSearchParameter: { byHouseName in
            XCTAssertTrue(byHouseName); exp.fulfill()
        })
        
        sut.searchControl.selectedSegmentIndex = 0
        sut.searchControl.sendActions(for: [.valueChanged])
        
        XCTAssertEqual(sut.searchField.placeholder, byHouseName)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_changeSearchParameters_didChange() {
        let exp = expectation(description: "waiting for toggle...")
        let sut = makeSUT(changeSearchParameter: { byHouseName in
            XCTAssertFalse(byHouseName); exp.fulfill()
        })
        
        sut.searchControl.selectedSegmentIndex = 1
        sut.searchControl.sendActions(for: [.valueChanged])
        
        XCTAssertEqual(sut.searchField.placeholder, byHouseCreator)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_searchForHouse_emptyText() {
        let exp = expectation(description: "waiting for search...")
        let sut = makeSUT(searchForHouse: { text in
            XCTAssertEqual(text, ""); exp.fulfill()
        })
    
        sut.findButton.sendActions(for: [.touchUpInside])
    
        waitForExpectations(timeout: 0.1)
    }
    
    func test_searchForHouse_fullText() {
        let input = getTestName(.testHouseName)
        let exp = expectation(description: "waiting for search...")
        let sut = makeSUT(searchForHouse: { text in
            XCTAssertEqual(text, input); exp.fulfill()
        })
    
        sut.searchField.text = input
        sut.findButton.sendActions(for: [.touchUpInside])
    
        waitForExpectations(timeout: 0.1)
    }
}


// MARK: - SUT
extension HouseSearchSearchViewTests {
    
    func makeSUT(changeSearchParameter: @escaping (Bool) -> Void = { _ in },
                 searchForHouse: @escaping (String) -> Void = { _ in },
                 file: StaticString = #filePath, line: UInt = #line) -> HouseSearchSearchView {
        
        let responder = (changeSearchParameter, searchForHouse)
        let sut = HouseSearchSearchView(config: SearchViewConfig(),
                                        responder: responder)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
}
