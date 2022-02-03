//
//  HouseDetailPresentationAdapterTests.swift
//  
//
//  Created by Nikolai Nobadi on 2/3/22.
//

import XCTest
import Combine
import NnHousehold
import NnHouseDetail_Logic_Presentation

final class HouseDetailPresentationAdapterTests: XCTestCase {
    
    // MARK: - Properties
    private let firstId = "firstId"
    private let secondId = "secondId"
    private var changes = Set<AnyCancellable>()
    
    
    // MARK: - TearDown
    override func tearDownWithError() throws {
        changes.removeAll()
    }
}


// MARK: - Unit Tests
extension HouseDetailPresentationAdapterTests {
    
    func test_init_emptyModels() {
        let exp = expectation(description: "Waiting for nothing...")
        let (sut, _) = makeSUT()
        
        sut.viewModelPublisher
            .sink { XCTAssertTrue($0.isEmpty); exp.fulfill() }
            .store(in: &changes)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_viewModelPublisher() {
        let exp = expectation(description: "Waiting for viewModels...")
        let (sut, publisher) = makeSUT()
        
        sut.viewModelPublisher
            .dropFirst()
            .sink {
                XCTAssertEqual($0.count, 2)
                exp.fulfill()
            }
            .store(in: &changes)
        
        publisher.members = makeMembers()
        waitForExpectations(timeout: 0.1)
    }
    
    func test_deleteMember() {
        let firstId = firstId
        let viewModelExp = XCTestExpectation(description: "Waiting for viewModels...")
        let methodExp = XCTestExpectation(description: "Waiting for deleteMember...")
        let (sut, publisher) = makeSUT(deleteMember: { member in
            XCTAssertEqual(member.id, firstId)
            methodExp.fulfill()
        })
        
        var viewModels = [HouseMemberViewModel]()
        
        sut.viewModelPublisher
            .dropFirst()
            .sink { viewModels = $0; viewModelExp.fulfill() }
            .store(in: &changes)
        
        publisher.members = makeMembers()
        wait(for: [viewModelExp], timeout: 0.1)
        
        guard let firstViewModel = viewModels.first else {
            return XCTFail("expected a member but found nothing")
        }
        
        firstViewModel.deleteMember()
        wait(for: [methodExp], timeout: 0.1)
    }
    
    func test_toggleAdminStatus() {
        let firstId = firstId
        let viewModelExp = XCTestExpectation(description: "Waiting for viewModels...")
        let methodExp = XCTestExpectation(description: "Waiting for toggleAdmineStatus...")
        let (sut, publisher) = makeSUT(toggleAdminStatus: { member in
            XCTAssertEqual(member.id, firstId)
            methodExp.fulfill()
        })
        
        var viewModels = [HouseMemberViewModel]()
        
        sut.viewModelPublisher
            .dropFirst()
            .sink { viewModels = $0; viewModelExp.fulfill() }
            .store(in: &changes)
        
        publisher.members = makeMembers()
        wait(for: [viewModelExp], timeout: 0.1)
        
        guard let firstViewModel = viewModels.first else {
            return XCTFail("expected a member but found nothing")
        }
        
        firstViewModel.toggleAdminStatus()
        wait(for: [methodExp], timeout: 0.1)
    }
}


// MARK: - SUT
extension HouseDetailPresentationAdapterTests {
    
    func makeSUT(deleteMember: ((HouseholdMember) -> Void)? = nil,
                 toggleAdminStatus: ((HouseholdMember) -> Void)? = nil,
                 file: StaticString = #filePath, line: UInt = #line) -> (sut: HouseDetailPresentationAdapter, publisher: MockHouseholdMemberPublisher) {
        
        let deleteMember = deleteMember ?? { _ in }
        let toggleAdminStatus = toggleAdminStatus ?? { _ in }
        let publisher = MockHouseholdMemberPublisher()
        let sut = HouseDetailPresentationAdapter(
            publisher: publisher,
            viewModelResponder: (deleteMember, toggleAdminStatus))
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, publisher)
    }
    
    func makeMembers() -> [HouseholdMember] {
        [TestHouseMember(id: firstId), TestHouseMember(id: secondId)]
    }
}


// MARK: - Helper Classes
extension HouseDetailPresentationAdapterTests {
    
    class MockHouseholdMemberPublisher: HouseholdMemberPublisher {
        
        @Published var members = [HouseholdMember]()
        
        var memberPublisher: AnyPublisher<[HouseholdMember], Never> {
            $members.eraseToAnyPublisher()
        }
    }
}

