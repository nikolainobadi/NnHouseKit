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
        let (sut, _, _) = makeSUT(houseId: "")
        
        expect(sut, toCompleteWithError: .noHouse)
    }
    
    func test_loadHouse_fetchError() {
        let (sut, remote, _) = makeSUT()
        
        expect(sut, toCompleteWithError: .fetchError) {
            remote.fetchComplete(with: .fetchError)
        }
    }
    
    func test_loadHouse_fetchSuccess_noAccessError() {
        let house = makeHouse()
        let (sut, remote, _) = makeSUT()
        
        expect(sut, toCompleteWithError: .noAccess) {
            remote.fetchComplete(house)
        }
    }
    
    func test_loadHouse_fetchSuccess_isMember_memberLoaderError() {
        let house = makeHouse()
        let policy = makePolicy(isMember: true)
        let (sut, remote, memberLoader) = makeSUT(policy: policy)
        
        expect(sut, toCompleteWithError: .fetchError) {
            remote.fetchComplete(house)
            memberLoader.complete(with: nil)
        }
    }
    
    func test_loadHouse_fetchSuccess_isMember_memberLoaderSuccess_houseSet() {
        let house = makeHouse()
        let store = makeStore()
        let policy = makePolicy(isMember: true)
        let (sut, remote, memberLoader) = makeSUT(store: store, policy: policy)
        let exp = expectation(description: "waiting for success...")
        
        sut.loadHouse { error in XCTAssertNil(error); exp.fulfill() }
        
        remote.fetchComplete(house)
        memberLoader.complete(with: house)
        store.complete(with: nil)
        
        XCTAssertNotNil(store.house)
        
        waitForExpectations(timeout: 0.1)
        
        
    }
    
    func test_loadHouse_fetchSuccess_isConverting_uploadError() {
        let house = makeHouse()
        let policy = makePolicy(isConverting: true)
        let (sut, remote, _) = makeSUT(policy: policy)
        
        expect(sut, toCompleteWithError: .uploadError) {
            remote.fetchComplete(house)
            remote.uploadComplete(with: .uploadError)
        }
    }
    
    func test_loadHouse_fetchSuccess_isConverting_uploadSuccess() {
        let house = makeHouse()
        let policy = makePolicy(isConverting: true)
        let modifier = makeModifier()
        let (sut, remote, _) = makeSUT(policy: policy, modifier: modifier)
        let exp = expectation(description: "waiting for success...")
        
        sut.loadHouse { error in XCTAssertNil(error); exp.fulfill() }
        
        remote.fetchComplete(house)
        remote.uploadComplete(with: nil)
        
        XCTAssertNotNil(modifier.house)
        
        waitForExpectations(timeout: 0.1)
    }
}


// MARK: - SUT
extension HouseholdLoadManagerTests {
    
    func makeSUT(houseId: String = "TestId",
                 store: HouseholdStore? = nil,
                 policy: HouseholdLoadPolicy? = nil,
                 modifier: MockConvertedHouseholdModifier? = nil,
                 file: StaticString = #filePath, line: UInt = #line) -> (sut: HouseholdLoadManager, remote: HouseholdLoadRemoteAPISpy, memberLoader: HouseholdMemberLoaderSpy) {
        
        let remote = HouseholdLoadRemoteAPISpy()
        let memberLoader = HouseholdMemberLoaderSpy()
        let sut = HouseholdLoadManager(houseId: houseId,
                                       store: store ?? makeStore(),
                                       policy: policy ?? makePolicy(),
                                       remote: remote,
                                       memberLoader: memberLoader,
                                       modifier: modifier ?? makeModifier())
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, remote, memberLoader)
    }
    
    func makeHouse() -> Household {
        TestHouse()
    }
    
    func makeStore() -> MockHouseholdStore {
        MockHouseholdStore()
    }
    
    func makePolicy(isMember: Bool = false,
                    isConverting: Bool = false) -> HouseholdLoadPolicy {
        
        MockHouseholdLoadPolicy(isMember: isMember, isConverting: isConverting)
    }
    
    func makeModifier() -> MockConvertedHouseholdModifier {
        MockConvertedHouseholdModifier()
    }
    
    func expect(_ sut: HouseholdLoadManager,
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
    
    class MockHouseholdStore: HouseholdStore {
        
        var house: Household?
        var completion: ((Error?) -> Void)?
        
        func setHouse(_ house: Household,
                      completion: @escaping (Error?) -> Void) {
            
            self.house = house
            self.completion = completion
        }
        
        func complete(with error: Error?,
                      file: StaticString = #filePath,
                      line: UInt = #line) {
            guard
                let completion = completion
            else {
                return XCTFail("Request never made", file: file, line: line)
            }
            
            completion(error)
        }
    }
    
    class MockHouseholdLoadPolicy: HouseholdLoadPolicy {
        
        private let isMember: Bool
        private let isConverting: Bool
        
        init(isMember: Bool = false, isConverting: Bool = false) {
            self.isMember = isMember
            self.isConverting = isConverting
        }
        
        func isMember(of house: Household) -> Bool {
            isMember
        }
        
        func isConverting(_ house: Household) -> Bool {
            isConverting
        }
    }
    
    class HouseholdLoadRemoteAPISpy: HouseholdLoadRemoteAPI {
        
        private var fetchCompletion: ((Result<Household, Error>) -> Void)?
        private var uploadCompletion: ((Error?) -> Void)?
        
        func fetchHouse(_ id: String,
                        completion: @escaping (Result<Household, Error>) -> Void) {
            
            self.fetchCompletion = completion
        }
        
        func uploadHouse(_ house: Household,
                         completion: @escaping (Error?) -> Void) {
            
            self.uploadCompletion = completion
        }
        
        func fetchComplete(with error: HouseFetchError,
                           file: StaticString = #filePath,
                           line: UInt = #line) {
            guard
                let fetchCompletion = fetchCompletion
            else {
                return XCTFail("Request never made", file: file, line: line)
            }
            
            fetchCompletion(.failure(error))
        }
        
        func fetchComplete(_ house: Household,
                           file: StaticString = #filePath,
                           line: UInt = #line) {
            guard
                let fetchCompletion = fetchCompletion
            else {
                return XCTFail("Request never made", file: file, line: line)
            }
            
            fetchCompletion(.success(house))
        }
        
        func uploadComplete(with error: HouseFetchError?,
                            file: StaticString = #filePath,
                            line: UInt = #line) {
            guard
                let uploadCompletion = uploadCompletion
            else {
                return XCTFail("Request never made", file: file, line: line)
            }
            
            uploadCompletion(error)
        }
    }
    
    class HouseholdMemberLoaderSpy: HouseholdMemberLoader {
        
        private var completion: ((Household?) -> Void)?
        
        func loadMembers(for house: Household,
                         completion: @escaping (Household?) -> Void) {
            
            self.completion = completion
        }
        
        func complete(with house: Household?,
                      file: StaticString = #filePath, line: UInt = #line) {
            guard
                let completion = completion
            else {
                return XCTFail("Request never made", file: file, line: line)
            }
            
            completion(house)
        }
    }
    
    class MockConvertedHouseholdModifier: ConvertedHouseholdModifier {
        
        var house: Household?
        
        func convertHouse(_ house: Household) -> Household {
            self.house = house
            return house
        }
    }
}
