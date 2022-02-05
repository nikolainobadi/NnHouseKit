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
import HouseDetailLogic

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

    func makeViewModels() -> [HouseMemberViewModel] {
       []
    }
}


// MARK: - Helper Classes
extension HouseDetailVCTests {
    
    class MockHouseDetailInterface: UIView, HouseDetailInterface {
        
        var members: [HouseMemberViewModel]?
        var editHouseBarButton: UIBarButtonItem { UIBarButtonItem() }
        
        func updateList(_ members: [HouseMemberViewModel]) {
            self.members = members
        }
    }
    
    class MockHouseDetailPresenter: HouseDetailPresenter {
        
        @Published var viewModels: [HouseMemberViewModel]?
        
        var viewModelPublisher: AnyPublisher<[HouseMemberViewModel], Never> {
            $viewModels.compactMap({ $0 }).eraseToAnyPublisher()
        }
    }
}
