//
//  JoinHouseVCTests.swift
//  
//
//  Created by Nikolai Nobadi on 2/8/22.
//

import XCTest
import Combine
import TestHelpers
import JoinHouseUI

final class JoinHouseVCTests: XCTestCase {
    
    func test_init_storeEmpty() {
        let (_, store, _) = makeSUT()
        
        XCTAssertNil(store.password)
    }
    
    func test_observers() {
        let (_, store, view) = makeSUT()
        
        view.password = "pwd"
        XCTAssertNotNil(store.password)
    }
}


// MARK: - SUT
extension JoinHouseVCTests {
    
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: JoinHouseVC, store: MockHousePasswordStore, rootView: MockJoinHouseInterface) {
        
        let store = MockHousePasswordStore()
        let rootView = MockJoinHouseInterface()
        let sut = JoinHouseVC(store: store,
                              rootView: rootView,
                              fieldsToObserve: [])
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, store, rootView)
    }
}


// MARK: - Helper Classes
extension JoinHouseVCTests {
    
    class MockHousePasswordStore: HousePasswordStore {
        
        var password: String?
        
        func updatePassword(_ password: String) {
            self.password = password
        }
    }
    
    class MockJoinHouseInterface: UIView, JoinHouseInterface {
        
        @Published var password: String?
        var buttonIsEnabled = false
        
        var passwordPublisher: AnyPublisher<String, Never> {
            $password.compactMap({ $0 }).eraseToAnyPublisher()
        }
        
        func enableButton(_ enable: Bool) {
            buttonIsEnabled = enable
        }
    }
}
