//
//  HouseSearchManagerTests.swift
//  
//
//  Created by Nikolai Nobadi on 2/7/22.
//

import XCTest
import TestHelpers
import NnHousehold
import HouseSearchLogic

final class HouseSearchManagerTests: XCTestCase {
    
    func test_initialSearchByParameter() {
        let (_, _, remote) = makeSUT()
        
        remote.checkByHouseName(isByHouse: true)
    }
    
    func test_toggleSearchBy() {
        let (sut, _, remote) = makeSUT()
        let byHouseName = false
       
        sut.changeSearchParameter(byHouseName)
        sut.searchForHouse("")
        
        remote.checkByHouseName(isByHouse: false)
    }
    
    func test_searchForHouse_networkError() {
        let (sut, alerts, remote) = makeSUT()
        
        sut.searchForHouse(getTestName(.testHouseName))
        remote.complete(with: .networkError)
        alerts.checkError(.networkError)
    }
    
    func test_joinHouse_emptyListError() {
        let (sut, alerts, remote) = makeSUT()
        
        sut.searchForHouse(getTestName(.testHouseName))
        remote.complete(with: .emptyListError)
        alerts.checkError(.emptyListError)
    }
    
    func test_joinHouse_success() {
        let (sut, alerts, remote) = makeSUT()
        
        sut.searchForHouse(getTestName(.testHouseName))
        remote.complete(with: nil)
        XCTAssertNil(alerts.error)
    }
}


// MARK: - SUT
extension HouseSearchManagerTests {
    
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: HouseSearchManager, alerts: HouseSearchAlertsSpy, remote: HouseSearchRemoteAPISpy) {
        
        let alerts = HouseSearchAlertsSpy()
        let remote = HouseSearchRemoteAPISpy()
        let sut = HouseSearchManager(alerts: alerts, remote: remote)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, alerts, remote)
    }
}


// MARK: - Helper Classes
extension HouseSearchManagerTests {
    
    class HouseSearchAlertsSpy: HouseSearchAlerts {
        
        var error: Error?
        
        func showError(_ error: Error) {
            self.error = error
        }
        
        func checkError(_ expectedError: HouseSearchError,
                        file: StaticString = #filePath, line: UInt = #line) {
            guard
                let error = error
            else { return XCTFail("no error", file: file, line: line) }
            
            guard let recievedError = error as? HouseSearchError else {
                return XCTFail("unexpected error", file: file, line: line)
            }
            
            XCTAssertEqual(recievedError, expectedError)
        }
    }
    
    class HouseSearchRemoteAPISpy: HouseSearchRemoteAPI {
        
        private var text: String?
        private var byHouseName: Bool = true
        private var completion: ((HouseSearchError?) -> Void)?
        
        func search(for text: String,
                    byHouseName: Bool,
                    completion: @escaping (HouseSearchError?) -> Void) {
            
            self.text = text
            self.byHouseName = byHouseName
            self.completion = completion
        }
        
        func checkByHouseName(isByHouse: Bool) {
            XCTAssertEqual(byHouseName, isByHouse)
        }
        
        func complete(with error: HouseSearchError?,
                      file: StaticString = #filePath, line: UInt = #line) {
            guard
                let completion = completion
            else {
                return XCTFail("no request made", file: file, line: line)
            }

            completion(error)
        }
    }
}
