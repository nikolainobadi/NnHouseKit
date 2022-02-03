//
//  File.swift
//  
//
//  Created by Nikolai Nobadi on 2/3/22.
//

import XCTest
import NnHousehold
import NnHouseDetail_Logic_Presentation

final class HouseDetailManagerTests: XCTestCase {
    
    // MARK: - Properties
    private let newName = "new name"
    private let newPassword = "new password"
}
 

// MARK: - Unit Tests
extension HouseDetailManagerTests {
    
    func test_init_emptyAlerts() {
        let (_, alerts, _) = makeSUT()

        XCTAssertNil(alerts.password)
    }

    func test_showPassword() {
        let (sut, alerts, _) = makeSUT()

        sut.showPassword()

        XCTAssertNotNil(alerts.password)
    }

    func test_editHouse_notCreator() {
        let (sut, alerts, _) = makeSUT()

        sut.editHouse()

        expect(alerts, toShowError: .editHouse)
    }

    func test_editHouse_emptyInfo() {
        let (sut, alerts, _) = makeSUT(isCreator: true)

        expect(alerts, toShowError: .noChange) {
            sut.editHouse()
            alerts.completeWithDetails(name: "", password: "")
        }
    }

    func test_editHouse_uploadError() {
        let newName = newName
        let (sut, alerts, remote) = makeSUT(isCreator: true)

        expect(alerts, toShowError: .uploadFailed) {
            sut.editHouse()
            alerts.completeWithDetails(name: newName, password: "")
            remote.complete(with: HouseDetailError.uploadFailed)
        }
    }

    func test_editHouse_uploadSuccess_noChangeInPassword() {
        let newName = newName
        let (sut, alerts, remote) = makeSUT(isCreator: true)

        expect(alerts, toShowError: nil) {
            sut.editHouse()
            alerts.completeWithDetails(name: newName, password: "")
            remote.complete(with: nil, newName: newName)
        }

        XCTAssertFalse(alerts.passwordDidChange)
    }

    func test_editHouse_uploadSuccess_passwordChanged() {
        let newName = newName
        let newPassword = newPassword
        let (sut, alerts, remote) = makeSUT(isCreator: true)

        expect(alerts, toShowError: nil) {
            sut.editHouse()
            alerts.completeWithDetails(name: newName, password: newPassword)
            remote.complete(with: nil, newName: newName, newPassword: newPassword)
        }

        XCTAssertTrue(alerts.passwordDidChange)
    }
}


// MARK: - SUT
extension HouseDetailManagerTests {
    
    func makeSUT(isCreator: Bool = false, file: StaticString = #filePath, line: UInt = #line) -> (sut: HouseDetailManager, alerts: HouseDetailAlertsSpy, remote: HouseholdUploaderSpy) {

        let houseCache = MockHouseholdCache(house: makeTestHouse())
        let alerts = HouseDetailAlertsSpy()
        let remote = HouseholdUploaderSpy()
        let sut = HouseDetailManager(isCreator: isCreator,
                                     alerts: alerts,
                                     remote: remote,
                                     houseCache: houseCache)

        trackForMemoryLeaks(sut, file: file, line: line)

        return (sut, alerts, remote)
    }

    func makeTestHouse() -> Household {
        TestHouse(id: "",
                  name: "",
                  creator: "",
                  password: "testPassword",
                  members: [],
                  lastLogin: "")
    }
}


// MARK: - Helper Methods
extension HouseDetailManagerTests {
    
    func expect(_ alerts: HouseDetailAlertsSpy,
                toShowError expectedError: HouseDetailError?,
                when action: (() -> Void)? = nil,
                file: StaticString = #filePath, line: UInt = #line) {

        action?()

        guard let expectedError = expectedError else {
            return XCTAssertNil(alerts.error)
        }

        guard let error = alerts.error else {
            return XCTFail("No error", file: file, line: line)
        }

        guard let houseError = error as? HouseDetailError else {
            return XCTFail("unexpected error", file: file, line: line)
        }

        XCTAssertEqual(houseError, expectedError)
    }
}


// MARK: - Helper Classes
extension HouseDetailManagerTests {
    
    class MockHouseholdCache: HouseholdCache {

        var house: Household

        init(house: Household) {
            self.house = house
        }
    }

    class HouseDetailAlertsSpy: HouseDetailAlerts {

        var password: String?
        var error: Error?
        var errorCompletion: (() -> Void)?
        var namePlaceholder: String?
        var passwordPlaceholder: String?
        var passwordDidChange = false

        private var detailCompletion: ((String, String) -> Void)?

        func showPasswordChangedAlert() {
            passwordDidChange = true
        }

        func showPasswordAlert(_ password: String) {
            self.password = password
        }

        func showError(_ error: Error, completion: (() -> Void)?) {
            self.error = error
            self.errorCompletion = completion
        }

        func showEditHouseAlert(namePlaceholder: String,
                                passwordPlaceholder: String,
                                completion: @escaping (String, String) -> Void) {

            self.namePlaceholder = namePlaceholder
            self.passwordPlaceholder = passwordPlaceholder
            self.detailCompletion = completion
        }

        func completeWithDetails(name: String,
                                 password: String,
                                 file: StaticString = #filePath, line: UInt = #line) {
            guard
                let detailCompletion = detailCompletion
            else { return XCTFail("alert not called...", file: file, line: line)
            }

            detailCompletion(name, password)
        }
    }

    class HouseholdUploaderSpy: HouseholdUploader {

        private var house: Household?
        private var completion: ((Error?) -> Void)?

        func uploadHouse(_ house: Household, completion: @escaping (Error?) -> Void) {
            self.house = house
            self.completion = completion
        }

        func complete(with error: Error?,
                      newName: String? = nil,
                      newPassword: String? = nil,
                      file: StaticString = #filePath, line: UInt = #line) {
            guard
                let completion = completion
            else { return XCTFail("No request made...", file: file, line: line) }

            if let newName = newName {
                guard let house = house else {
                    return XCTFail("no house uploaded", file: file, line: line)
                }

                XCTAssertEqual(newName, house.name)
            }

            if let newPassword = newPassword {
                guard let house = house else {
                    return XCTFail("no house uploaded", file: file, line: line)
                }

                XCTAssertEqual(newPassword, house.password)
            }

            completion(error)
        }
    }
}

