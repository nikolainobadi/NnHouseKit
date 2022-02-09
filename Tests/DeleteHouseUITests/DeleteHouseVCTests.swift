//
//  DeleteHouseVCTests.swift
//  
//
//  Created by Nikolai Nobadi on 2/8/22.
//

import XCTest
import TestHelpers
import DeleteHouseUI

final class DeleteHouseVCTests: XCTestCase {
    
    func test_viewDidLoad_childrenSet() {
        let (sut, _, _) = makeSUT()
        let _ = sut.view
        
        XCTAssertEqual(sut.children.count, 1)
    }
    
    func test_viewDidLoad_fetchError() {
        let (sut, alerts, loader) = makeSUT()
        let _ = sut.view
        let error = DeleteHouseError.networkError
        
        loader.complete(with: error)
        alerts.complete(expectedError: error)
    }
    
    func test_viewDidLoad_fetchSuccess_mistakeError() {
        let exp = expectation(description: "waiting for dismiss..")
        let (sut, alerts, loader) = makeSUT { exp.fulfill() }
        let _ = sut.view
        let error = DeleteHouseError.shownByMistakeError
        
        loader.complete(with: error)
        alerts.complete(expectedError: error)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_viewDidLoad_fetchSuccess_detailsUpdated() {
        let view = MockDeleteHouseDetailsInterface()
        let (sut, _, loader) = makeSUT(view: view)
        let _ = sut.view
        let fakeDetails = getTestName(.firstName)
        
        loader.complete(details: fakeDetails)
        XCTAssertEqual(view.details, fakeDetails)
    }
}


// MARK: - SUT
extension DeleteHouseVCTests {
    
    func makeSUT(view: DeleteHouseDetailsInterface? = nil,
                 dismiss: @escaping () -> Void = { },
                 file: StaticString = #filePath, line: UInt = #line) -> (sut: DeleteHouseVC, alerts: DeleteHouseAlertsSpy, loader: DeleteHouseLoaderSpy) {
        
        let detailsView = view ?? MockDeleteHouseDetailsInterface()
        let loader = DeleteHouseLoaderSpy()
        let alerts = DeleteHouseAlertsSpy()
        let sut = DeleteHouseVC(tableVC: UIViewController(),
                                detailsView: detailsView,
                                loader: loader,
                                alerts: alerts,
                                dismiss: dismiss)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, alerts, loader)
    }
}


// MARK: - Helper Classes
extension DeleteHouseVCTests {
    
    class MockDeleteHouseDetailsInterface: UIView, DeleteHouseDetailsInterface {
        
        var details: String?
        
        func updateView(_ details: String) {
            self.details = details
        }
    }
    
    class DeleteHouseLoaderSpy: DeleteHouseLoader {
        
        private var completion: ((Result<String, DeleteHouseError>) -> Void)?
        
        func loadData(completion: @escaping (Result<String, DeleteHouseError>) -> Void) {
            
            self.completion = completion
        }
        
        func complete(with expectedError: DeleteHouseError,
                      file: StaticString = #filePath, line: UInt = #line) {
            guard
                let completion = completion
            else {
                return XCTFail("no error shown", file: file, line: line)
            }
            
            completion(.failure(expectedError))
        }
        
        func complete(details: String,
                      file: StaticString = #filePath, line: UInt = #line) {
            guard
                let completion = completion
            else {
                return XCTFail("no error shown", file: file, line: line)
            }
            
            completion(.success(details))
        }
    }
    
    class DeleteHouseAlertsSpy: DeleteHouseAlerts {
        
        private var error: Error?
        private var completion: (() -> Void)?
        
        func showError(_ error: Error, completion: (() -> Void)?) {
            self.error = error
            self.completion = completion
        }
        
        func complete(expectedError: DeleteHouseError,
                      file: StaticString = #filePath, line: UInt = #line) {
            guard
                let error = error
            else {
                return XCTFail("no error shown", file: file, line: line)
            }
            
            guard let recievedError = error as? DeleteHouseError else {
                return XCTFail("unexpected error", file: file, line: line)
            }
            
            XCTAssertEqual(recievedError, expectedError)
            completion?()
        }
    }
}

