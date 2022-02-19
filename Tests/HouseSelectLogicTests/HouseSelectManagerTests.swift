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
        
        remote.dupeComplete(with: .nameTaken)
        alerts.verifyError(expectedError: .houseNameTaken)
    }
    
    func test_createHouse_uploadError() {
        let (sut, alerts, remote) = makeSUT(canCreate: true)
        let error = HouseDetailError.uploadFailed
        
        sut.createNewHouse()
        
        alerts.complete(name: getTestName(.testHouseName),
                        pwd: getTestName(.testHouseName))
        
        remote.dupeComplete(with: nil)
        remote.complete(with: error)
        alerts.verifyError(expectedError: .uploadFailed)
    }
    
    func test_createHouse_uploadSuccess_finished() {
        let exp = expectation(description: "waiting for finished...")
        let (sut, alerts, remote) = makeSUT(canCreate: true, finished: {
            exp.fulfill()
        })
        
        sut.createNewHouse()
        alerts.complete(name: getTestName(.testHouseName),
                        pwd: getTestName(.testHouseName))
        
        remote.dupeComplete(with: nil)
        remote.complete(with: nil)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_createHouse_uploadSuccess_noOldHouse_uploadedDataVerified() {
        let (sut, alerts, remote) = makeSUT(canCreate: true)
        
        sut.createNewHouse()
        alerts.complete(name: getTestName(.testHouseName),
                        pwd: getTestName(.testHouseName))
        
        remote.dupeComplete(with: nil)
        remote.complete(with: nil)
        
        guard
            let user = remote.user,
            let houses = remote.houses
        else { return XCTFail() }
        
        XCTAssertEqual(houses.count, 1)
        XCTAssertEqual(user.houseId, houses[0].id)
        XCTAssertEqual(user.createdHouseIds.count, 1)
    }
    
    func test_createHouse_uploadSuccess_withOldHouse_uploadedDataVerified() {
        let member = makeMember()
        let house = makeHouse([member])
        let user = makeUser(house)
        let (sut, alerts, remote) = makeSUT(user: user, canCreate: true)
        
        sut.createNewHouse()
        alerts.complete(name: getTestName(.testHouseName),
                        pwd: getTestName(.testHouseName))
        
        remote.dupeComplete(with: nil)
        remote.complete(with: nil)
        
        guard
            let user = remote.user,
            let houses = remote.houses,
            let oldHouse = houses.first(where: { $0.id == house.id })
        else { return XCTFail() }
        
        XCTAssertEqual(houses.count, 2)
        XCTAssertTrue(oldHouse.members.isEmpty)
        XCTAssertEqual(user.houseId, houses[1].id)
    }
}


// MARK: - SUT
extension HouseSelectManagerTests {
    
    func makeSUT(user: HouseholdUser? = nil,
                 canCreate: Bool = false,
                 finished: @escaping () -> Void = { },
                 showDeleteHouse: @escaping () -> Void = { },
                 file: StaticString = #filePath, line: UInt = #line) -> (sut: HouseSelectManager, alerts: HouseSelectAlertsSpy, remote: HouseholdAndUserRemoteAPISpy) {
        
        let policy = MockHouseSelectPolicy(canCreate: canCreate)
        let alerts = HouseSelectAlertsSpy()
        let remote = HouseholdAndUserRemoteAPISpy()
        let sut = HouseSelectManager(user: user ?? makeUser(),
                                     policy: policy,
                                     alerts: alerts,
                                     remote: remote,
                                     factory: MockHouseholdFactory(),
                                     finished: finished,
                                     showDeleteHouse: showDeleteHouse)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, alerts, remote)
    }
    
    func makeUser(_ house: Household? = nil) -> HouseholdUser {
        TestHouseholdUser(id: getTestName(.testUserId),
                          name: getTestName(.testUsername),
                          houseId: house?.id ?? "",
                          currentHouse: house)
    }
    
    func makeHouse(_ members: [HouseholdMember] = []) -> Household {
        TestHouse(id: getTestName(.testHouseId),
                  name: getTestName(.testHouseName),
                  members: members)
    }
    
    func makeMember() -> HouseholdMember {
        TestHouseMember(id: getTestName(.testUserId),
                        name: getTestName(.testUsername),
                        isAdmin: true)
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
            TestHouse(id: "new", name: name, password: password)
        }
    }
}
