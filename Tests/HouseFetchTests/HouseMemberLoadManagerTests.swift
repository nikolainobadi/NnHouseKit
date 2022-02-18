//
//  HouseholdMemberLoadManagerTests.swift
//  
//
//  Created by Nikolai Nobadi on 2/18/22.
//

import XCTest
import HouseFetch
import NnHousehold
import TestHelpers

final class HouseholdMemberLoadManagerTests: XCTestCase {
    
    func test_loadMembers_error() {
        let (sut, remote) = makeSUT()
        let exp = expectation(description: "waiting for error...")
        
        sut.loadMembers(for: makeHouse(members: makeMembers())) { house in
            XCTAssertNil(house); exp.fulfill()
        }
        
        remote.complete(with: NSError(domain: "Test", code: 0))
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_loadMembers_noMissingIds() {
        let (sut, _) = makeSUT(memberList: makeMembers(withNames: true))
        let exp = expectation(description: "waiting for error...")
        
        sut.loadMembers(for: makeHouse(members: makeMembers())) { house in
            guard let house = house else { return XCTFail() }
            
            XCTAssertEqual(house.members.count, 2)
            XCTAssertTrue(house.members.filter({ $0.name == ""}).isEmpty)
            exp.fulfill()
        }
    
        waitForExpectations(timeout: 0.1)
    }
    
    func test_loadMembers_oneMissingIds() {
        let members = makeMembers(withNames: true)
        let myMember = members[0]
        let newMember = members[1]
        let (sut, remote) = makeSUT(memberList: [myMember])
        let exp = expectation(description: "waiting for error...")
        
        sut.loadMembers(for: makeHouse(members: makeMembers())) { house in
            guard let houseMembers = house?.members else { return XCTFail() }
            
            XCTAssertEqual(houseMembers.count, 2)
            XCTAssertTrue(houseMembers.contains(where: {$0.name == myMember.name}))
            XCTAssertTrue(houseMembers.contains(where: {$0.name == newMember.name}))
            XCTAssertTrue(houseMembers.filter({ $0.name == ""}).isEmpty)
            exp.fulfill()
        }
        
        remote.complete([newMember])
        
        guard let ids = remote.memberIds else { return XCTFail() }
        
        XCTAssertEqual(ids.count, 1)
    
        waitForExpectations(timeout: 0.1)
    }
}


// MARK: - SUT
extension HouseholdMemberLoadManagerTests {
    
    func makeSUT(memberList: [HouseholdMember] = [],
                 file: StaticString = #filePath, line: UInt = #line) -> (sut: HouseholdMemberLoadManager, remote: HouseholdMemberRemoteAPISpy) {
        
        let remote = HouseholdMemberRemoteAPISpy()
        let sut = HouseholdMemberLoadManager(remote: remote,
                                             memberList: memberList)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, remote)
    }
    
    func makeHouse(members: [HouseholdMember] = []) -> Household {
        TestHouse(members: members)
    }
    
    func makeMembers(withNames: Bool = false) -> [HouseholdMember] {
        [TestHouseMember(id: getTestName(.firstId),
                         name: withNames ? getTestName(.firstName) : "",
                         isAdmin: true),
         TestHouseMember(id: getTestName(.secondId),
                         name: withNames ? getTestName(.secondName) : "",
                         isAdmin: false)]
    }
}


// MARK: - Helper Classes
extension HouseholdMemberLoadManagerTests {
    
    class HouseholdMemberRemoteAPISpy: HouseholdMemberRemoteAPI {
        
        var memberIds: [String]?
        private var completion: ((Result<[HouseholdMember], Error>) -> Void)?
        
        func fetchInfoList(memberIds: [String],
                           completion: @escaping (Result<[HouseholdMember], Error>) -> Void) {
            
            self.memberIds = memberIds
            self.completion = completion
        }
        
        func complete(with error: Error,
                      file: StaticString = #filePath, line: UInt = #line) {
            guard
                let completion = completion
            else {
                return XCTFail("Request never made", file: file, line: line)
            }
            
            completion(.failure(error))
        }
        
        func complete(_ list: [HouseholdMember],
                      file: StaticString = #filePath, line: UInt = #line) {
            guard
                let completion = completion
            else {
                return XCTFail("Request never made", file: file, line: line)
            }
            
            completion(.success(list))
        }
    }
}

