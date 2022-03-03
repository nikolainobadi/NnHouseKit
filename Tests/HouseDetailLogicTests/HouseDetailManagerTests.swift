//
//  HouseDetailManagerTests.swift
//
//
//  Created by Nikolai Nobadi on 3/1/22.
//

import XCTest
import TestHelpers
import NnHousehold
import HouseDetailLogic

final class HouseDetailManagerTests: XCTestCase {

    // MARK: - Properties
    private lazy var newName = getTestName(.secondName)
    private lazy var newPassword = getTestName(.thirdName)
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

    func test_editHouse_networkError() {
        let newName = newName
        let (sut, alerts, remote) = makeSUT(isCreator: true)

        expect(alerts, toShowError: .uploadFailed) {
            sut.editHouse()
            alerts.completeWithDetails(name: newName, password: "")
            remote.dupeComplete(with: nil)
            remote.complete(with: HouseDetailError.uploadFailed)
        }
    }

    func test_editHouse_nameTakenError() {
        let newName = newName
        let (sut, alerts, remote) = makeSUT(isCreator: true)

        expect(alerts, toShowError: .houseNameTaken) {
            sut.editHouse()
            alerts.completeWithDetails(name: newName, password: "")
            remote.dupeComplete(with: .nameTaken)
        }
    }

    func test_editHouse_uploadSuccess_noChangeInPassword() {
        let newName = newName
        let (sut, alerts, remote) = makeSUT(isCreator: true)

        expect(alerts, toShowError: nil) {
            sut.editHouse()
            alerts.completeWithDetails(name: newName, password: "")
            remote.dupeComplete(with: nil)
            remote.complete(with: nil, newName: newName)
        }

        XCTAssertFalse(alerts.passwordDidChange)
    }

    func test_editHouse_uploadSuccess_passwordChanged_houseNameSame() {
        
        let house = makeTestHouse(name: "")
        let newPassword = newPassword
        let (sut, alerts, remote) = makeSUT(isCreator: true,
                                            house: house)
        expect(alerts, toShowError: nil) {
            sut.editHouse()
            alerts.completeWithDetails(name: "",
                                       password: newPassword)
            remote.complete(with: nil,
                            newPassword: newPassword)
        }

        XCTAssertTrue(alerts.passwordDidChange)
    }

    func test_editHouse_uploadSuccess_passwordChanged() {
        let newName = newName
        let newPassword = newPassword
        let (sut, alerts, remote) = makeSUT(isCreator: true)

        expect(alerts, toShowError: nil) {
            sut.editHouse()
            alerts.completeWithDetails(name: newName, password: newPassword)
            remote.dupeComplete(with: nil)
            remote.complete(with: nil, newName: newName, newPassword: newPassword)
        }

        XCTAssertTrue(alerts.passwordDidChange)
    }

    func test_deleteMember_notCreatorError() {
        let members = makeTestMemberList()
        let house = makeTestHouse(members: members)
        let (sut, alerts, _) = makeSUT(house: house)
        let error = HouseDetailError.deleteMember

        guard let id = members.first?.id else {
            return XCTFail("WTF is the member?")
        }

        expect(alerts, toShowError: error) {
            sut.deleteMember(memberId: id)
        }
    }

    func test_deleteMember_uploadError() {
        let members = makeTestMemberList()
        let house = makeTestHouse(members: members)
        let (sut, alerts, remote) = makeSUT(isCreator: true, house: house)
        let error = HouseDetailError.uploadFailed

        guard let id = members.first?.id else {
            return XCTFail("WTF is the member?")
        }

        expect(alerts, toShowError: error) {
            sut.deleteMember(memberId: id)
            remote.complete(with: error)
        }
    }

    func test_deleteMember_uploadSuccess() {
        let members = makeTestMemberList()
        let house = makeTestHouse(members: members)
        let (sut, alerts, remote) = makeSUT(isCreator: true, house: house)

        guard let id = members.first?.id else {
            return XCTFail("WTF is the member?")
        }

        expect(alerts, toShowError: nil) {
            sut.deleteMember(memberId: id)
            remote.complete(with: nil)

            guard let house = remote.house else {
                return XCTFail("No house...")
            }

            XCTAssertFalse(house.members.contains(where: { $0.id == id }))
        }
    }

    func test_toggleAdminStatus_uploadError() {
        let members = makeTestMemberList()
        let house = makeTestHouse(members: members)
        let (sut, alerts, remote) = makeSUT(house: house)
        let error = HouseDetailError.uploadFailed

        guard let id = members.first?.id else {
            return XCTFail("WTF is the member?")
        }

        expect(alerts, toShowError: error) {
            sut.toggleAdminStatus(memberId: id)
            remote.complete(with: error)
        }
    }

    func test_toggleAdminStatus_uploadSuccess() {
        let members = makeTestMemberList()
        let house = makeTestHouse(members: members)
        let (sut, alerts, remote) = makeSUT(house: house)

        guard let id = members.first?.id else {
            return XCTFail("WTF is the member?")
        }

        expect(alerts, toShowError: nil) {
            sut.toggleAdminStatus(memberId: id)
            remote.complete(with: nil)

            guard
                let house = remote.house,
                let toggledMember = house.members.first(where: { $0.id == id })
            else { return XCTFail("WTF") }

            XCTAssertFalse(toggledMember.isAdmin)
        }
    }
}


// MARK: - SUT
extension HouseDetailManagerTests {

    func makeSUT(isCreator: Bool = false,
                 house: TestNnHouse? = nil,
                 file: StaticString = #filePath, line: UInt = #line) -> (sut: HouseDetailManager<TestNnHouse>, alerts: HouseDetailAlertsSpy, remote: HouseDetailRemoteAPISpy) {

        let house = house ?? makeTestHouse()
        let alerts = HouseDetailAlertsSpy()
        let remote = HouseDetailRemoteAPISpy()
        let adapter = makeAdapter(house: house,
                                  remote: remote)
        let sut = HouseDetailManager(isCreator: isCreator,
                                       alerts: alerts,
                                       adapter: adapter)

        trackForMemoryLeaks(sut, file: file, line: line)

        return (sut, alerts, remote)
    }
    
    func makeAdapter(house: TestNnHouse, remote: HouseDetailRemoteAPISpy) -> MyAdapter<TestNnHouse> {
        
        return (
            getHouse: { house },
            uploadHouse: { (house, completion) in
                remote.uploadHouse(house, completion: completion)
            }, checkForDuplicates: { (name, completion) in
                remote.checkForDuplicates(name: name, completion: completion)
            }
        )
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

    class MockHouseholdCache: GenericHouseholdCache {

        typealias House = TestNnHouse

        var house: House

        init(_ house: House) {
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

    class HouseDetailRemoteAPISpy: GenericDetailRemoteAPI {

        typealias House = TestNnHouse

        var house: House?
        private var dupeCompletion: ((DuplicateError?) -> Void)?
        private var uploadCompletion: ((Error?) -> Void)?

        func checkForDuplicates(name: String,
                                completion: @escaping (DuplicateError?) -> Void) {

            self.dupeCompletion = completion
        }

        func uploadHouse(_ house: House, completion: @escaping (Error?) -> Void) {
            self.house = house
            self.uploadCompletion = completion
        }

        func complete(with error: Error?,
                      newName: String? = nil,
                      newPassword: String? = nil,
                      file: StaticString = #filePath, line: UInt = #line) {
            guard
                let completion = uploadCompletion
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

        func complete(with error: Error?,
                      file: StaticString = #filePath, line: UInt = #line) {

            guard
                let completion = uploadCompletion
            else { return XCTFail("No request made...", file: file, line: line) }

            completion(error)
        }

        func dupeComplete(with error: DuplicateError?,
                          file: StaticString = #filePath,
                          line: UInt = #line) {
            guard
                let completion = dupeCompletion
            else { return XCTFail("No request made...", file: file, line: line) }

            completion(error)
        }
    }
}


