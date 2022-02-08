//
//  HouseListPresentationAdapterTests.swift
//  
//
//  Created by Nikolai Nobadi on 2/7/22.
//

import XCTest
import Combine
import NnHousehold
import TestHelpers
import HouseListTable

final class HouseListPresentationAdapterTests: XCTestCase {
    
    private var changes = Set<AnyCancellable>()
    
    override func tearDownWithError() throws {
        changes.removeAll()
    }
}


// MARK: - Unit Tests
extension HouseListPresentationAdapterTests {
    
    func test_init_emptyModels() {
        let exp = expectation(description: "Waiting for nothing...")
        let (sut, _) = makeSUT()

        sut.cellModelPublisher
            .sink { XCTAssertTrue($0.isEmpty); exp.fulfill() }
            .store(in: &changes)

        waitForExpectations(timeout: 0.1)
    }

    func test_cellModelPublisher() {
        let firstName = getTestName(.firstName)
        let secondName = getTestName(.secondName)
        let thirdName = getTestName(.thirdName)
        let exp = expectation(description: "Waiting for viewModels...")
        let (sut, publisher) = makeSUT()

        sut.cellModelPublisher
            .dropFirst()
            .sink { [weak self] list in
                guard
                    let first = list.filter({ $0.name == firstName }).first,
                    let second = list.filter({ $0.name == secondName }).first,
                    let third = list.filter({ $0.name == thirdName }).first

                else { return XCTFail() }

                self?.verifyModel(first,
                                  expectedName: .firstName,
                                  expectedDetails: "first",
                                  expectedShowButton: false,
                                  exectedStatusColor: nil,
                                  expectedButtonBackgroundColor: nil)

                self?.verifyModel(second,
                                  expectedName: .secondName,
                                  expectedDetails: "second",
                                  expectedShowButton: true,
                                  expectedButtonText: "",
                                  exectedStatusColor: .label,
                                  expectedButtonBackgroundColor: .label)

                self?.verifyModel(third,
                                  expectedName: .thirdName,
                                  expectedDetails: "third",
                                  expectedShowButton: true,
                                  expectedButtonText: "",
                                  exectedStatusColor: .label,
                                  expectedButtonBackgroundColor: .label)
                exp.fulfill()
            }
            .store(in: &changes)

        publisher.infoList = makeInfoList()

        waitForExpectations(timeout: 0.1)
    }

    func test_delete() {
        let firstId = getTestName(.firstId)
        let viewModelExp = XCTestExpectation(description: "Waiting for viewModels...")
        let methodExp = XCTestExpectation(description: "Waiting for deleteMember...")
        let (sut, publisher) = makeSUT(delete: { id in
            XCTAssertEqual(id, firstId)
            methodExp.fulfill()
        })

        var viewModels = [HouseListCellViewModel]()

        sut.cellModelPublisher
            .dropFirst()
            .sink { viewModels = $0; viewModelExp.fulfill() }
            .store(in: &changes)

        publisher.infoList = makeInfoList()
        wait(for: [viewModelExp], timeout: 0.1)

        guard let firstViewModel = viewModels.first else {
            return XCTFail("expected a viewModel but found nothing")
        }

        firstViewModel.delete()
        wait(for: [methodExp], timeout: 0.1)
    }

    func test_buttonAction() {
        let firstId = getTestName(.firstId)
        let viewModelExp = XCTestExpectation(description: "Waiting for viewModels...")
        let methodExp = XCTestExpectation(description: "Waiting for toggleAdmineStatus...")
        let (sut, publisher) = makeSUT(buttonAction: { id in
            XCTAssertEqual(id, firstId)
            methodExp.fulfill()
        })

        var viewModels = [HouseListCellViewModel]()

        sut.cellModelPublisher
            .dropFirst()
            .sink { viewModels = $0; viewModelExp.fulfill() }
            .store(in: &changes)

        publisher.infoList = makeInfoList()
        wait(for: [viewModelExp], timeout: 0.1)

        guard let firstViewModel = viewModels.first else {
            return XCTFail("expected a member but found nothing")
        }

        firstViewModel.buttonAction()
        wait(for: [methodExp], timeout: 0.1)
    }
}


// MARK: - Assertion Helpers
extension HouseListPresentationAdapterTests {
    
    func verifyModel(_ model: HouseListCellViewModel,
                     expectedName: TestName,
                     expectedDetails: String,
                     expectedShowButton: Bool,
                     expectedButtonText: String? = nil,
                     exectedStatusColor: UIColor?,
                     expectedButtonBackgroundColor: UIColor?) {

        XCTAssertEqual(model.name, expectedName.rawValue)
        XCTAssertEqual(model.details, expectedDetails)
        XCTAssertEqual(model.showButton, expectedShowButton)

        if let expectedButtonText = expectedButtonText {
            XCTAssertEqual(model.buttonText, expectedButtonText)
        }
    }
}


// MARK: - SUT
extension HouseListPresentationAdapterTests {
    
    func makeSUT(delete: @escaping ((String) -> Void) = { _ in },
                 buttonAction: @escaping ((String) -> Void) = { _ in },
                 file: StaticString = #filePath, line: UInt = #line) -> (sut: HouseListPresentationAdapter, publisher: MockHouseListCellInfoPublisher) {

        let publisher = MockHouseListCellInfoPublisher()
        let sut = HouseListPresentationAdapter(
            responder: (delete, buttonAction),
            publisher: publisher)
        
        
        trackForMemoryLeaks(sut, file: file, line: line)

        return (sut, publisher)
    }
    
    func makeInfoList() -> [HouseListCellInfo] {
        [makeInfo(isAdmin: true),
         makeInfo(id: getTestName(.secondId),
                  name: getTestName(.secondName),
                  details: "second",
                  showButton: true),
         makeInfo(id: getTestName(.thirdId),
                  name: getTestName(.thirdName),
                  details: "third",
                  isAdmin: true,
                  showButton: true)
        ]
    }

    func makeInfo(id: String? = nil,
                  name: String? = nil,
                  details: String? = nil,
                  isAdmin: Bool = false,
                  showButton: Bool = false,
                  canDelete: Bool = false) -> HouseListCellInfo {

        TestHouseListCellInfo(id: id ?? getTestName(.firstId),
                              name: name ?? getTestName(.firstName),
                              details: details ?? "first",
                              detailsColor: nil,
                              buttonText: "",
                              buttonColor: nil,
                              showButton: showButton,
                              canDelete: canDelete)
    }
}


// MARK: - Helper Structs & Classes
extension HouseListPresentationAdapterTests {
    
    class MockHouseListCellInfoPublisher: HouseListCellInfoPublisher {
        
        @Published var infoList = [HouseListCellInfo]()
        
        var viewModelPublisher: AnyPublisher<[HouseListCellInfo], Never> {
            $infoList.eraseToAnyPublisher()
        }
    }
}


