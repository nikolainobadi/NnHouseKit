//
//  HouseSelectManagerTests.swift
//  
//
//  Created by Nikolai Nobadi on 2/5/22.
//

import XCTest
import TestHelpers
import NnHousehold
import HouseSelectLogic
import HouseDetailLogic

final class HouseSelectManagerTests: XCTestCase {
    
    func test_createHouse_maxHousesError() {
        let exp = expectation(description: "waiting for nav...")
        let (sut, _, _) = makeSUT(showDeleteHouse: { exp.fulfill() })
        
        sut.createNewHouse()
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_createHouse_emptyName() {
        let (sut, alerts, _) = makeSUT(canCreate: true)
        
        sut.createNewHouse()
        
        alerts.complete(name: "", pwd: "")
        alerts.verifyError(expectedError: .shortName)
    }
    
    func test_createHouse_shortName() {
        let (sut, alerts, _) = makeSUT(canCreate: true)
        
        sut.createNewHouse()
        
        alerts.complete(name: "bob", pwd: "")
        alerts.verifyError(expectedError: .shortName)
    }
    
    func test_createHouse_emptyPassword() {
        let (sut, alerts, _) = makeSUT(canCreate: true)
        
        sut.createNewHouse()
        
        alerts.complete(name: getTestName(.testHouseName), pwd: "")
        alerts.verifyError(expectedError: .shortPassword)
    }
    
    func test_createHouse_shortPassword() {
        let (sut, alerts, _) = makeSUT(canCreate: true)
        
        sut.createNewHouse()
        
        alerts.complete(name: getTestName(.testHouseName), pwd: "123")
        alerts.verifyError(expectedError: .shortPassword)
    }
    
    func test_createHouse_nameTakenError() {
        let (sut, alerts, remote) = makeSUT(canCreate: true)
        
        sut.createNewHouse()
        
        alerts.complete(name: getTestName(.testHouseName),
                        pwd: getTestName(.testHouseName))
        
        remote.dupeComplete(error: .houseNameTaken)
        
        alerts.verifyError(expectedError: .houseNameTaken)
    }
    
    func test_createHouse_uploadError() {
        let (sut, alerts, remote) = makeSUT(canCreate: true)
        let error = HouseDetailError.uploadFailed
        
        sut.createNewHouse()
        
        alerts.complete(name: getTestName(.testHouseName),
                        pwd: getTestName(.testHouseName))
        
        remote.dupeComplete(error: nil)
        remote.uploadComplete(error: error)
        alerts.verifyError(expectedError: .uploadFailed)
    }
    
    func test_createHouse_uploadSuccess() {
        let exp = expectation(description: "waiting for finished...")
        let (sut, alerts, remote) = makeSUT(canCreate: true, finished: {
            exp.fulfill()
        })
        
        
        sut.createNewHouse()
        
        alerts.complete(name: getTestName(.testHouseName),
                        pwd: getTestName(.testHouseName))
        
        remote.dupeComplete(error: nil)
        remote.uploadComplete(error: nil)
        
        
        waitForExpectations(timeout: 0.1)
    }
}


// MARK: - SUT
extension HouseSelectManagerTests {
    
    func makeSUT(canCreate: Bool = false,
                 finished: @escaping () -> Void = { },
                 showDeleteHouse: @escaping () -> Void = { },
                 file: StaticString = #filePath, line: UInt = #line) -> (sut: HouseSelectManager, alerts: HouseSelectAlertsSpy, remote: HouseSelectRemoteAPISpy) {
        
        let policy = MockHouseSelectPolicy(canCreate: canCreate)
        let alerts = HouseSelectAlertsSpy()
        let remote = HouseSelectRemoteAPISpy()
        let sut = HouseSelectManager(policy: policy,
                                     alerts: alerts,
                                     remote: remote,
                                     factory: MockHouseholdFactory(),
                                     finished: finished,
                                     showDeleteHouse: showDeleteHouse)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, alerts, remote)
    }
}


// MARK: - Helper Classes
extension HouseSelectManagerTests {
    
    class MockHouseSelectPolicy: HouseSelectPolicy {
        
        var canCreateMoreHouses: Bool
        
        init(canCreate: Bool = false) {
            canCreateMoreHouses = canCreate
        }
    }
    
    class HouseSelectAlertsSpy: HouseSelectAlerts {
        
        var error: Error?
        private var completion: ((String, String) -> Void)?
        
        func showError(_ error: Error) {
            self.error = error
        }
        
        func showCreateHouseAlert(completion: @escaping (String, String) -> Void) {
            self.completion = completion
        }
        
        func complete(name: String, pwd: String,
                      file: StaticString = #filePath, line: UInt = #line) {
            guard
                let completion = completion
            else {
                return XCTFail("no alert made...", file: file, line: line)
            }

            completion(name, pwd)
        }
        
        func verifyError(expectedError: HouseDetailError,
                         file: StaticString = #filePath, line: UInt = #line) {
            guard
                let error = error
            else { return XCTFail("no error", file: file, line: line) }
            
            guard let recievedError = error as? HouseDetailError else {
                return XCTFail("unexpected error", file: file, line: line)
            }
            
            XCTAssertEqual(recievedError, expectedError)
        }
    }
    
    class MockHouseholdFactory: HouseholdFactory {
        
        func makeNewHouse(name: String, password: String) -> Household {
            TestHouse(name: name, password: password)
        }
    }
    
    class HouseSelectRemoteAPISpy: HouseholdUploader {
        
        private var house: Household?
        private var dupeCompletion: ((HouseDetailError?) -> Void)?
        private var uploadCompletion: ((Error?) -> Void)?
        
        func checkForDuplicates(name: String,
                                completion: @escaping (HouseDetailError?) -> Void) {
            
            self.dupeCompletion = completion
        }
        
        func uploadHouse(_ house: Household, completion: @escaping (Error?) -> Void) {
            
            self.house = house
            self.uploadCompletion = completion
        }
        
        func dupeComplete(error: HouseDetailError?,
                          file: StaticString = #filePath, line: UInt = #line) {
            guard
                let completion = dupeCompletion
            else {
                return XCTFail("no request made...", file: file, line: line)
            }

            completion(error)
        }
        
        func uploadComplete(error: Error?,
                      file: StaticString = #filePath, line: UInt = #line) {
            guard
                let completion = uploadCompletion, house != nil
            else {
                return XCTFail("no request made...", file: file, line: line)
            }

            completion(error)
        }
    }
}
