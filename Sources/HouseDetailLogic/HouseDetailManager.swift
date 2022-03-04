//
//  HouseDetailManager.swift
//  
//
//  Created by Nikolai Nobadi on 3/1/22.
//

import NnHousehold

public final class HouseDetailManager<NnHouse: NnHousehold> {
    
    // MARK: - Properties
    private let isCreator: Bool
    private let alerts: HouseDetailAlerts
    private let adapter: MyAdapter<NnHouse>
    
    private var house: NnHouse { adapter.getHouse() }
    
    
    // MARK: - Init
    public init(isCreator: Bool,
                alerts: HouseDetailAlerts,
                adapter: MyAdapter<NnHouse>) {
        
        self.isCreator = isCreator
        self.alerts = alerts
        self.adapter = adapter
    }
}


// MARK: - UIResponder
extension HouseDetailManager {
    
    public func showPassword() {
        alerts.showPasswordAlert(house.password)
    }
    
    public func editHouse() {
        guard isCreator else { return showError(HouseDetailError.editHouse) }

        alerts.showEditHouseAlert(namePlaceholder: house.name,
                                  passwordPlaceholder: house.password) { [weak self] (newName, newPassword) in

            self?.updateHouseDetails(name: newName, password: newPassword)
        }
    }
}


// MARK: - ViewModelResponder
extension HouseDetailManager {
    
    public func deleteMember(memberId: String) {
        guard isCreator else { return showError(HouseDetailError.deleteMember) }

        var updatedHouse = house

        updatedHouse.members = updatedHouse.members.filter { $0.id != memberId }

        uploadHouse(updatedHouse)
    }
    
    public func toggleAdminStatus(memberId: String) {
        guard
            let index = house.members.firstIndex(where: { $0.id == memberId })
        else { fatalError("No Member found") }

        var updatedHouse = house
        updatedHouse.members[index].isAdmin.toggle()

        uploadHouse(updatedHouse)
    }
}


// MARK: - Private Methods
private extension HouseDetailManager {
    
    func updateHouseDetails(name: String, password: String) {
        guard
            let updatedHouse = makeUpdatedHouse(name: name, password: password)
        else { return showError(HouseDetailError.noChange) }
        
        checkForDuplicates(newName: name) { [weak self] error in
            if let error = error {
                self?.showError(error)
            } else {
                self?.uploadHouse(updatedHouse)
            }
        }
    }
    
    func makeUpdatedHouse(name: String, password: String) -> NnHouse? {

        var updatedHouse = house
        var didChange = false

        if name != "" && name != house.name {
            didChange = true
            updatedHouse.name = name
        }

        if password != "" && password != house.password {
            didChange = true
            updatedHouse.password = password
        }

        return didChange ? updatedHouse : nil
    }
    
    func uploadHouse(_ updatedHouse: NnHouse) {
        let passwordChanged = house.password != updatedHouse.password

        adapter.uploadHouse(updatedHouse) { [weak self] error in
            if let error = error {
                self?.showError(error)
            } else {
                self?.showPasswordChangedAlert(passwordChanged)
            }
        }
    }
    
    func checkForDuplicates(newName: String,
                            completion: @escaping (HouseDetailError?) -> Void) {
        guard
            newName != house.name
        else { return completion(nil) }

        adapter.checkForDuplicates(newName) { error in
            guard let error = error else { return completion(nil) }

            if error == .nameTaken {
                completion(.houseNameTaken)
            } else {
                completion(.uploadFailed)
            }
        }
    }
    
    func showPasswordChangedAlert(_ passwordChanged: Bool) {
        if passwordChanged { alerts.showPasswordChangedAlert() }
    }
    
    func showError(_ error: Error) {
        alerts.showError(error, completion: nil)
    }
}


// MARK: - Dependencies
public protocol NnHouseCache {
    associatedtype NnHouse: NnHousehold

    var house: NnHouse { get }
}

public protocol NnHouseDetailRemoteAPI: DuplcatesRemoteAPI {
    associatedtype NnHouse: NnHousehold
    
    func uploadHouse(_ house: NnHouse,
                     completion: @escaping (Error?) -> Void)
}

public protocol HouseDetailAlerts {
    func showPasswordChangedAlert()
    func showPasswordAlert(_ password: String)
    func showError(_ error: Error, completion: (() -> Void)?)
    func showEditHouseAlert(namePlaceholder: String,
                            passwordPlaceholder: String,
                            completion: @escaping (String, String) -> Void)
}

public typealias MyAdapter<NnHouse: NnHousehold> = (
    getHouse: () -> NnHouse,
    uploadHouse: (NnHouse, @escaping (Error?) -> Void) -> Void,
    checkForDuplicates: (String, @escaping (DuplicateError?) -> Void) -> Void)
