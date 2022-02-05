//
//  HouseDetailVCTests.swift
//
//
//  Created by Nikolai Nobadi on 2/3/22.
//

import UIKit
import XCTest
import Combine
import HouseDetailUI

final class HouseDetailVCTests: XCTestCase {
    
    func test_init_emptyValues() {
        let (_, view, presenter) = makeSUT()

        XCTAssertNil(view.members)
        XCTAssertNil(presenter.viewModels)
    }

    func test_viewModelObserver() {
        let (sut, view, presenter) = makeSUT()
        let _ = sut.view

        presenter.viewModels = makeViewModels()
        XCTAssertNotNil(view.members)
    }
}


// MARK: - SUT
extension HouseDetailVCTests {
    
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: HouseDetailVC, view: MockHouseDetailInterface, presenter: MockHouseDetailPresenter) {

        let rootView = MockHouseDetailInterface()
        let presenter = MockHouseDetailPresenter()
        let sut = HouseDetailVC(rootView: rootView,
                                presenter: presenter)

        trackForMemoryLeaks(sut, file: file, line: line)

        return (sut, rootView, presenter)
    }

    func makeViewModels() -> [HouseMemberCellViewModel] {
       []
    }
}


// MARK: - Helper Classes
extension HouseDetailVCTests {
    
    class MockHouseDetailInterface: UIView, HouseDetailInterface {
        
        var members: [HouseMemberCellViewModel]?
        var editHouseBarButton: UIBarButtonItem { UIBarButtonItem() }
        
        func updateList(_ members: [HouseMemberCellViewModel]) {
            self.members = members
        }
    }
    
    class MockHouseDetailPresenter: HouseDetailPresenter {
        
        @Published var viewModels: [HouseMemberCellViewModel]?
        
        var cellModelPublisher: AnyPublisher<[HouseMemberCellViewModel], Never> {
            $viewModels.compactMap({ $0 }).eraseToAnyPublisher()
        }
    }
}
