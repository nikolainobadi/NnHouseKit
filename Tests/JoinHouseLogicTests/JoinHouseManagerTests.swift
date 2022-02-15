//
//  JoinHouseManagerTests.swift
//  
//
//  Created by Nikolai Nobadi on 2/8/22.
//

import XCTest
import TestHelpers
import NnHousehold
import JoinHouseLogic

final class JoinHouseManagerTests: XCTestCase {
    
    func test_init() {
        let (_, alerts, _) = makeSUT()
        
        XCTAssertNil(alerts.error)
    }
    
    func test_joinHouse_notCreator_wrongPassword() {
        let house = makeHouse(password: "right")
        let (sut, alerts, _) = makeSUT(house: house)
        
        sut.joinHouse(password: "wrong")
        
        XCTAssertNotNil(alerts.error)
    }
    
    func test_joinHouse_notCreator_uploadError() {
        let pwd = "right"
        let house = makeHouse(password: pwd)
        let error = NSError(domain: "Test", code: 0)
        let (sut, alerts, remote) = makeSUT(house: house)
        
        sut.joinHouse(password: pwd)
        remote.complete(with: error)
        XCTAssertNotNil(alerts.error)
    }
    
    func test_joinHouse_notCreator_success() {
        let pwd = "right"
        let house = makeHouse(password: pwd)
        let (sut, alerts, remote) = makeSUT(house: house)
        
        sut.joinHouse(password: pwd)
        remote.complete(with: nil)
        XCTAssertNil(alerts.error)
    }
    
    func test_joinHouse_creator_uploadError() {
        let pwd = "right"
        let house = makeHouse(creator: getTestName(.testUsername),
                              password: pwd)
        let error = NSError(domain: "Test", code: 0)
        let (sut, alerts, remote) = makeSUT(house: house)
        
        sut.joinHouse(password: "")
        remote.complete(with: error)
        XCTAssertNotNil(alerts.error)
    }
    
    func test_joinHouse_creator_success() {
        let pwd = "right"
        let house = makeHouse(creator: getTestName(.testUsername),
                              password: pwd)
        let (sut, alerts, remote) = makeSUT(house: house)
        
        sut.joinHouse(password: pwd)
        remote.complete(with: nil)
        XCTAssertNil(alerts.error)
    }
    
    func test_joinHouse_houseIdSetForUser() {
        let pwd = "right"
        let user = makeUser(houseId: "Old")
        let house = makeHouse(password: pwd)
        let (sut, _, remote) = makeSUT(user: user, house: house)
        
        sut.joinHouse(password: pwd)
        remote.complete(with: nil)
        
        guard let user = remote.user else {
            return XCTFail("no user uploaded")
        }
        
        XCTAssertEqual(user.houseId, getTestName(.testHouseId))
    }
    
    func test_joinHouse_userMemberRemovedFromOldHouse() {
        let pwd = "right"
        let member = makeMember()
        let oldHouse = makeHouse(id: "OldId",
                                 name: "OldName",
                                 members: [member])
        let user = makeUser(houseId: "Old", house: oldHouse)
        let newHouse = makeHouse(password: pwd)
        let (sut, _, remote) = makeSUT(user: user, house: newHouse)
        
        sut.joinHouse(password: pwd)
        remote.complete(with: nil)
        
        guard
            let houses = remote.houses,
            let oldUpdatedHouse = houses.first(where: { $0.id == oldHouse.id })
        else {
            return XCTFail("no houses uploaded")
        }
        
        XCTAssertTrue(oldUpdatedHouse.members.isEmpty)
    }
    
    func test_joinHouse_userMemberAddedToNewHouse() {
        let pwd = "right"
        let user = makeUser(houseId: "Old")
        let newHouse = makeHouse(password: pwd)
        let (sut, _, remote) = makeSUT(house: newHouse)
        
        sut.joinHouse(password: pwd)
        remote.complete(with: nil)
        
        guard
            let houses = remote.houses,
            let newUpdatedHouse = houses.first(where: { $0.id == newHouse.id })
        else {
            return XCTFail("no houses uploaded")
        }
        
        XCTAssertEqual(newUpdatedHouse.members.count, 1)
        XCTAssertTrue(newUpdatedHouse.members.contains(where: { $0.id == user.id }))
    }
}


// MARK: - SUT
extension JoinHouseManagerTests {
    
    func makeSUT(user: HouseholdUser? = nil,
                 house: Household? = nil,
                 finished: @escaping () -> Void = { },
                 file: StaticString = #filePath, line: UInt = #line) -> (sut: JoinHouseManager, alerts: MockJoinHouseAlerts, remote: HouseholdAndUserRemoteAPISpy) {
        
        let alerts = MockJoinHouseAlerts()
        let remote = HouseholdAndUserRemoteAPISpy()
        let factory = MockHouseholdMemberFactory(makeMember())
        let sut = JoinHouseManager(user: user ?? makeUser(),
                                   houseToJoin: house ?? makeHouse(),
                                   alerts: alerts,
                                   remote: remote,
                                   factory: factory,
                                   finished: finished)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, alerts, remote)
    }
    
    func makeMember() -> HouseholdMember {
        TestHouseMember(id: getTestName(.testUserId),
                        name: getTestName(.testUsername))
    }
    
    func makeUser(houseId: String = "",
                  house: Household? = nil) -> HouseholdUser {
        
        TestHouseholdUser(id: getTestName(.testUserId),
                          name: getTestName(.testUsername),
                          houseId: houseId,
                          currentHouse: house)
    }
    
    func makeHouse(id: String? = nil,
                   name: String? = nil,
                   creator: String = "",
                   password: String = "",
                   members: [HouseholdMember] = []) -> Household {
        
        TestHouse(id: id ?? getTestName(.testHouseId),
                  name: name ?? getTestName(.testHouseName),
                  creator: creator,
                  password: password,
                  members: members)
    }
}


// MARK: - Helper Classes
extension JoinHouseManagerTests {
    
    struct TestHouseholdUser: HouseholdUser {
        var id: String = ""
        var name: String = ""
        var houseId: String = ""
        var currentHouse: Household? = nil
    }
    
    class MockJoinHouseAlerts: JoinHouseAlerts {
        
        var error: Error?
        
        func showError(_ error: Error) {
            self.error = error
        }
    }
    
    class MockHouseholdMemberFactory: HouseholdMemberFactory {
        
        private let member: HouseholdMember
        
        init(_ member: HouseholdMember) {
            self.member = member
        }
        
        func makeMember() -> HouseholdMember {
            member
        }
    }
}
