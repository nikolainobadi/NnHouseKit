//
//  HouseDetailPresentationAdapterTests.swift
//
//
//  Created by Nikolai Nobadi on 2/3/22.
//

import XCTest
import Combine
import NnHousehold
import HouseDetailUI

final class HouseDetailPresentationAdapterTests: XCTestCase {
    
    private var changes = Set<AnyCancellable>()
    
    override func tearDownWithError() throws {
        changes.removeAll()
    }
}


// MARK: - Unit Tests
extension HouseDetailPresentationAdapterTests {
    
    func test_init_emptyModels() {
        let exp = expectation(description: "Waiting for nothing...")
        let (sut, _) = makeSUT()
        
        sut.cellModelPublisher
            .sink { XCTAssertTrue($0.isEmpty); exp.fulfill() }
            .store(in: &changes)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_cellModelPublisher() {
        let firstId = getTestName(.firstId)
        let secondId = getTestName(.secondId)
        let thirdId = getTestName(.thirdId)
        let exp = expectation(description: "Waiting for viewModels...")
        let (sut, publisher) = makeSUT()

        sut.cellModelPublisher
            .dropFirst()
            .sink { [weak self] list in
                guard
                    let first = list.filter({ $0.id == firstId }).first,
                    let second = list.filter({ $0.id == secondId }).first,
                    let third = list.filter({ $0.id == thirdId }).first
                    
                else { return XCTFail() }
                
                self?.verifyModel(first,
                                  expectedName: .firstName,
                                  expectedStatus: "Creator",
                                  expectedShowButton: false,
                                  exectedStatusColor: nil,
                                  expectedButtonBackgroundColor: nil)
                
                self?.verifyModel(second,
                                  expectedName: .secondName,
                                  expectedStatus: "",
                                  expectedShowButton: true,
                                  expectedButtonText: "Make Admin",
                                  exectedStatusColor: nil,
                                  expectedButtonBackgroundColor: nil)
                
                self?.verifyModel(third,
                                  expectedName: .thirdName,
                                  expectedStatus: "Admin",
                                  expectedShowButton: true,
                                  expectedButtonText: "Remove Admin",
                                  exectedStatusColor: nil,
                                  expectedButtonBackgroundColor: nil)
                exp.fulfill()
            }
            .store(in: &changes)

        publisher.infoList = makeInfoList()
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_deleteMember() {
        let firstId = getTestName(.firstId)
        let viewModelExp = XCTestExpectation(description: "Waiting for viewModels...")
        let methodExp = XCTestExpectation(description: "Waiting for deleteMember...")
        let (sut, publisher) = makeSUT(deleteMember: { id in
            XCTAssertEqual(id, firstId)
            methodExp.fulfill()
        })

        var viewModels = [HouseMemberCellViewModel]()

        sut.cellModelPublisher
            .dropFirst()
            .sink { viewModels = $0; viewModelExp.fulfill() }
            .store(in: &changes)

        publisher.infoList = makeInfoList()
        wait(for: [viewModelExp], timeout: 0.1)

        guard let firstViewModel = viewModels.first else {
            return XCTFail("expected a member but found nothing")
        }

        firstViewModel.deleteMember()
        wait(for: [methodExp], timeout: 0.1)
    }
    
    func test_toggleAdminStatus() {
        let firstId = getTestName(.firstId)
        let viewModelExp = XCTestExpectation(description: "Waiting for viewModels...")
        let methodExp = XCTestExpectation(description: "Waiting for toggleAdmineStatus...")
        let (sut, publisher) = makeSUT(toggleAdminStatus: { id in
            XCTAssertEqual(id, firstId)
            methodExp.fulfill()
        })

        var viewModels = [HouseMemberCellViewModel]()

        sut.cellModelPublisher
            .dropFirst()
            .sink { viewModels = $0; viewModelExp.fulfill() }
            .store(in: &changes)

        publisher.infoList = makeInfoList()
        wait(for: [viewModelExp], timeout: 0.1)

        guard let firstViewModel = viewModels.first else {
            return XCTFail("expected a member but found nothing")
        }

        firstViewModel.toggleAdminStatus()
        wait(for: [methodExp], timeout: 0.1)
    }
}


// MARK: - Assertion Helpers
extension HouseDetailPresentationAdapterTests {
    
    func verifyModel(_ model: HouseMemberCellViewModel,
                     expectedName: TestName,
                     expectedStatus: String,
                     expectedShowButton: Bool,
                     expectedButtonText: String? = nil,
                     exectedStatusColor: UIColor?,
                     expectedButtonBackgroundColor: UIColor?) {
        
        XCTAssertEqual(model.name, expectedName.rawValue)
        XCTAssertEqual(model.adminStatus, expectedStatus)
        XCTAssertEqual(model.showButton, expectedShowButton)
        
        if let expectedButtonText = expectedButtonText {
            XCTAssertEqual(model.buttonText, expectedButtonText)
        }
        
        XCTAssertEqual(model.buttonBackgroundColor, expectedButtonBackgroundColor)
    }
}


// MARK: - SUT
extension HouseDetailPresentationAdapterTests {
    
    func makeSUT(config: HouseMemberCellConfig? = nil,
                 deleteMember: ((String) -> Void)? = nil,
                 toggleAdminStatus: ((String) -> Void)? = nil,
                 file: StaticString = #filePath, line: UInt = #line) -> (sut: HouseDetailPresentationAdapter, publisher: MockHouseMemberViewIinfoPublisher) {

        let deleteMember = deleteMember ?? { _ in }
        let toggleAdminStatus = toggleAdminStatus ?? { _ in }
        let publisher = MockHouseMemberViewIinfoPublisher()
        let sut = HouseDetailPresentationAdapter(
            config: config ?? makeConfig(),
            publisher: publisher,
            responder: (deleteMember, toggleAdminStatus))

        trackForMemoryLeaks(sut, file: file, line: line)

        return (sut, publisher)
    }
    
    func makeConfig() -> HouseMemberCellConfig {
        HouseMemberCellConfig()
    }
    
    func makeInfoList() -> [HouseMemberViewInfo] {
        [makeInfo(isAdmin: true),
         makeInfo(id: getTestName(.secondId),
                  name: getTestName(.secondName),
                  status: "",
                  showButton: true),
         makeInfo(id: getTestName(.thirdId),
                  name: getTestName(.thirdName),
                  status: "Admin",
                  isAdmin: true,
                  showButton: true)
        ]
    }
    
    func makeInfo(id: String? = nil,
                  name: String? = nil,
                  status: String? = nil,
                  isAdmin: Bool = false,
                  showButton: Bool = false) -> HouseMemberViewInfo {
        
        TestHouseMemberViewInfo(memberId: id ?? getTestName(.firstId),
                                memberName: name ?? getTestName(.firstName),
                                adminStatus: status ?? "Creator",
                                isAdmin: isAdmin,
                                showButton: showButton)
    }
}


// MARK: - Helper Structs & Classes
extension HouseDetailPresentationAdapterTests {
    
    struct TestHouseMemberViewInfo: HouseMemberViewInfo {
        var memberId: String = ""
        var memberName: String = ""
        var adminStatus: String = ""
        var isAdmin: Bool = false
        var showButton: Bool = false
    }
    
    class MockHouseMemberViewIinfoPublisher: HouseMemberViewInfoPublisher {
        
        @Published var infoList = [HouseMemberViewInfo]()
        
        var viewModelPublisher: AnyPublisher<[HouseMemberViewInfo], Never> {
            $infoList.eraseToAnyPublisher()
        }
    }
}

