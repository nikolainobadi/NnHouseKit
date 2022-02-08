//
//  HouseListTableVCTests.swift
//  
//
//  Created by Nikolai Nobadi on 2/7/22.
//

import XCTest
import Combine
import TestHelpers
import NnHousehold
@testable import HouseListTable

final class HouseListTableVCTests: XCTestCase {
    
    private var changes = Set<AnyCancellable>()
    
    override func tearDownWithError() throws {
        changes.removeAll()
    }
}


// MARK: - Unit Tests
extension HouseListTableVCTests {
    
    func test_viewDidLoad_tableEmpty() {
        let (sut, _) = makeSUT()
        let _ = sut.view
    
        XCTAssertEqual(sut.table.numberOfSections, 0)
    }
    
    func test_observers() {
        let (sut, presenter) = makeSUT()
        let _ = sut.view
        
        presenter.viewModels = makeList()
        
        XCTAssertEqual(sut.table.numberOfSections, 1)
        XCTAssertEqual(sut.table.numberOfRows(inSection: 0), 1)
    }
    
    func test_tableCell_buttonAction() {
        let (sut, presenter) = makeSUT()
        let _ = sut.view
        let firstRow = IndexPath(row: 0, section: 0)
        let exp = expectation(description: "waiting for action...")
        guard let dataSource = sut.table.dataSource else {
            return XCTFail("no datasource available")
        }
        
        presenter.viewModels = makeList(buttonAction: { _ in
            exp.fulfill()
        })
        
        guard
            let cell = dataSource.tableView(sut.table, cellForRowAt: firstRow) as? HouseListCell
        else {
            return XCTFail("no cell available")
        }
        
        cell.rootView.cellButton.sendActions(for: [.touchUpInside])
        
        waitForExpectations(timeout: 0.1)
    }
}


// MARK: - SUT
extension HouseListTableVCTests {
    
    func makeSUT(sectionTitle: String = "",
                 file: StaticString = #filePath, line: UInt = #line) -> (sut: HouseListTableVC, presenter: MockHouseListPresenter) {
        
        let presenter = MockHouseListPresenter(sectionTitle: sectionTitle)
        let sut = HouseListTableVC(presenter: presenter)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, presenter)
    }
    
    func makeList(buttonAction: @escaping (String) -> Void = { _ in }) -> [HouseListCellViewModel] {
        
        [makeViewModel(buttonAction: buttonAction)]
    }
    
    func makeViewModel(buttonAction: @escaping (String) -> Void) -> HouseListCellViewModel {
        
        HouseListCellViewModel(info: TestHouseListCellInfo(),
                               responder: ({ _ in }, buttonAction))
    }
}


// MARK: - Helper Classes
extension HouseListTableVCTests {
    
    class MockHouseListPresenter: HouseListPresenter {
        
        @Published var viewModels: [HouseListCellViewModel]?
        
        var sectionTitle: String
        var cellModelPublisher: AnyPublisher<[HouseListCellViewModel],  Never> {
            $viewModels.compactMap { $0 }.eraseToAnyPublisher()
        }
        
        init(sectionTitle: String) {
            self.sectionTitle = sectionTitle
        }
    }
}
