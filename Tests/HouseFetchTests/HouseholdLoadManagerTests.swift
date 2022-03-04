//
//  HouseholdLoadManagerTests.swift
//  
//
//  Created by Nikolai Nobadi on 2/18/22.
//

import XCTest
import HouseFetch
import NnHousehold
import TestHelpers

final class HouseholdLoadManagerTests: XCTestCase {
    
    func test_loadHouse_noHouseIdError() {
        let (sut, _) = makeSUT(houseId: "")

        expect(sut, toCompleteWithError: .noHouse)
    }

    func test_loadHouse_fetchError() {
        let (sut, remote) = makeSUT()

        expect(sut, toCompleteWithError: .fetchError) {
            remote.houseComplete(with: .fetchError)
        }
    }

    func test_loadHouse_fetchSuccess_noAccessError() {
        let house = makeTestHouse()
        let (sut, remote) = makeSUT()

        expect(sut, toCompleteWithError: .noAccess) {
            remote.houseComplete(house)
        }
    }

    func test_loadHouse_fetchSuccess_isMember_memberFetchError() {
        let incompleteMembers = makeTestMemberList(withNames: false)
        let house = makeTestHouse(members: incompleteMembers)
        let store = makeStore(isMember: true)
        let (sut, remote) = makeSUT(store: store)

        expect(sut, toCompleteWithError: .fetchError) {
            remote.houseComplete(house)
            remote.membersComplete(with: .fetchError)
        }
    }

    func test_loadHouse_fetchSuccess_isMember_memberFetchSuccess_houseSet() {
        
        let incompleteMembers = makeTestMemberList(withNames: false)
        let completeMembers = makeTestMemberList(withNames: true)
        let house = makeTestHouse(members: incompleteMembers)
        let store = makeStore(isMember: true)
        let (sut, remote) = makeSUT(store: store)
        let exp = expectation(description: "waiting for success...")

        sut.loadHouse { error in
            XCTAssertNil(error)
            exp.fulfill()
        }

        remote.houseComplete(house)
        remote.membersComplete(completeMembers)
        
        guard let storedHouse = store.house else {
            return XCTFail("house not saved")
        }
        
        XCTAssertEqual(storedHouse.members, completeMembers)

        waitForExpectations(timeout: 0.1)
    }
}


// MARK: - SUT
extension HouseholdLoadManagerTests {
    
    typealias SUT = HouseholdLoadManager<MockHouseholdStore, HouseholdLoadRemoteAPISpy>
    
    func makeSUT(houseId: String = "TestId",
                 store: MockHouseholdStore? = nil,
                 file: StaticString = #filePath, line: UInt = #line) -> (sut: SUT, remote: HouseholdLoadRemoteAPISpy) {

        let store = store ?? makeStore()
        let remote = HouseholdLoadRemoteAPISpy()
        let sut = HouseholdLoadManager(houseId: houseId,
                                       store: store,
                                       remote: remote,
                                       currentMembers: [])

        trackForMemoryLeaks(sut, file: file, line: line)

        return (sut, remote)
    }
    
    func makeStore(isMember: Bool = false) -> MockHouseholdStore {
        MockHouseholdStore(isMember: isMember)
    }

    func expect(_ sut: SUT,
                toCompleteWithError expectedError: HouseFetchError,
                when action: (() -> Void)? = nil,
                file: StaticString = #filePath, line: UInt = #line) {

        let exp = expectation(description: "waiting for error...")

        sut.loadHouse { error in
            guard let error = error else {
                return XCTFail("no error")
            }

            guard let fetchError = error as? HouseFetchError else {
                return XCTFail("unexpected error")
            }

            XCTAssertEqual(fetchError, expectedError)
            exp.fulfill()
        }

        action?()
        waitForExpectations(timeout: 0.1)
    }
}


// MARK: - Helper Classes
extension HouseholdLoadManagerTests {
    
    class MockHouseholdStore: NnHouseStore {
        
        typealias House = TestNnHouse

        var house: House?
        var isMember: Bool
        
        init(isMember: Bool) {
            self.isMember = isMember
        }
        
        func isMember(of house: TestNnHouse) -> Bool {
            isMember
        }
        
        func setHouse(_ house: TestNnHouse) {
            self.house = house
        }
    }

    class HouseholdLoadRemoteAPISpy: HouseholdLoadRemoteAPI {
        
        typealias House = TestNnHouse

        var memberIds = [String]()
        private var houseCompletion: ((Result<House, Error>) -> Void)?
        private var membersCompletion: ((Result<[TestNnHouseMember], Error>) -> Void)?

        func fetchHouse(_ id: String,
                        completion: @escaping (Result<House, Error>) -> Void) {

            self.houseCompletion = completion
        }
        
        func fetchInfoList(memberIds: [String],
                           completion: @escaping (Result<[TestNnHouseMember], Error>) -> Void) {
            
            self.memberIds = memberIds
            self.membersCompletion = completion
        }

        func houseComplete(with error: HouseFetchError,
                           file: StaticString = #filePath,
                           line: UInt = #line) {
            guard
                let houseCompletion = houseCompletion
            else {
                return XCTFail("Request never made", file: file, line: line)
            }

            houseCompletion(.failure(error))
        }

        func houseComplete(_ house: House,
                           file: StaticString = #filePath,
                           line: UInt = #line) {
            guard
                let houseCompletion = houseCompletion
            else {
                return XCTFail("Request never made", file: file, line: line)
            }

            houseCompletion(.success(house))
        }
        
        func membersComplete(with error: HouseFetchError,
                           file: StaticString = #filePath,
                           line: UInt = #line) {
            guard
                let membersCompletion = membersCompletion
            else {
                return XCTFail("Request never made", file: file, line: line)
            }

            membersCompletion(.failure(error))
        }

        func membersComplete(_ list: [TestNnHouseMember],
                             file: StaticString = #filePath,
                             line: UInt = #line) {
            guard
                let membersCompletion = membersCompletion
            else {
                return XCTFail("Request never made", file: file, line: line)
            }

            membersCompletion(.success(list))
        }
    }
}
