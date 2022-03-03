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
        let house = makeTestHouse(password: "right")
        let (sut, alerts, _) = makeSUT(house: house)

        sut.joinHouse(password: "wrong")

        XCTAssertNotNil(alerts.error)
    }

    func test_joinHouse_notCreator_uploadError() {
        let pwd = "right"
        let house = makeTestHouse(password: pwd)
        let error = NSError(domain: "Test", code: 0)
        let (sut, alerts, remote) = makeSUT(house: house)

        sut.joinHouse(password: pwd)
        remote.complete(with: error)
        XCTAssertNotNil(alerts.error)
    }

    func test_joinHouse_notCreator_success() {
        let pwd = "right"
        let house = makeTestHouse(password: pwd)
        let (sut, alerts, remote) = makeSUT(house: house)

        sut.joinHouse(password: pwd)
        remote.complete(with: nil)
        XCTAssertNil(alerts.error)
    }

    func test_joinHouse_creator_uploadError() {
        let pwd = "right"
        let creator = getTestName(.testUsername)
        let house = makeTestHouse(creator: creator, password: pwd)
        let error = NSError(domain: "Test", code: 0)
        let (sut, alerts, remote) = makeSUT(house: house)

        sut.joinHouse(password: "")
        remote.complete(with: error)
        XCTAssertNotNil(alerts.error)
    }

    func test_joinHouse_creator_success() {
        let pwd = "right"
        let creator = getTestName(.testUsername)
        let house = makeTestHouse(creator: creator, password: pwd)
        let (sut, alerts, remote) = makeSUT(house: house)

        sut.joinHouse(password: pwd)
        remote.complete(with: nil)
        XCTAssertNil(alerts.error)
    }

    func test_joinHouse_houseIdSetForUser() {
        let pwd = "right"
        let user = makeTestUser(houseId: "Old")
        let house = makeTestHouse(password: pwd)
        let (sut, _, remote) = makeSUT(user: user, house: house)

        sut.joinHouse(password: pwd)
        remote.complete(with: nil)

        guard let user = remote.user else {
            return XCTFail("no user uploaded")
        }

        XCTAssertTrue(user.createdHouseIds.isEmpty)
        XCTAssertEqual(user.houseId, getTestName(.testHouseId))
    }

    func test_joinHouse_userMemberRemovedFromOldHouse() {
        let pwd = "right"
        let member = makeTestMember()
        let oldHouse = makeTestHouse(id: "OldId",
                                     name: "OldName",
                                     members: [member])
        let user = makeTestUser(houseId: "Old", house: oldHouse)
        let newHouse = makeTestHouse(password: pwd)
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
        let user = makeTestUser(houseId: "Old")
        let newHouse = makeTestHouse(password: pwd)
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
    
    typealias Remote = NnUserAndHouseRemoteAPISpy<TestNnHouseUser>
    
    func makeSUT(user: TestNnHouseUser? = nil,
                 house: TestNnHouse? = nil,
                 finished: @escaping () -> Void = { },
                 file: StaticString = #filePath, line: UInt = #line) -> (sut: JoinHouseManager<Remote, MockNnHouseMemberFactory>, alerts: MockJoinHouseAlerts, remote: Remote) {
        
        let remote = Remote()
        let alerts = MockJoinHouseAlerts()
        let factory = MockNnHouseMemberFactory(makeTestMember())
        let sut = JoinHouseManager(user: user ?? makeTestUser(),
                                   houseToJoin: house ?? makeTestHouse(),
                                   alerts: alerts,
                                   remote: remote,
                                   factory: factory,
                                   finished: finished)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, alerts, remote)
    }
}


// MARK: - Helper Classes
extension JoinHouseManagerTests {
    
    class MockJoinHouseAlerts: JoinHouseAlerts {
        
        var error: Error?
        
        func showError(_ error: Error) {
            self.error = error
        }
    }
    
    class MockNnHouseMemberFactory: NnHouseMemberFactory {
        typealias Member = TestNnHouseMember
        
        private let member: Member
        
        init(_ member: Member) {
            self.member = member
        }
        
        func makeMember() -> Member {
            member
        }
    }
}
