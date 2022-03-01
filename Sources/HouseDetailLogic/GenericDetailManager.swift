//
//  GenericDetailManager.swift
//  
//
//  Created by Nikolai Nobadi on 3/1/22.
//

import NnHousehold

public final class GenericDetailManager<House: Household> {
    
    // MARK: - Properties
    private let isCreator: Bool
    private let alerts: HouseDetailAlerts
    private let adapter: MyAdapter<House>
    
    private var house: House { adapter.getHouse() }
    
    
    // MARK: - Init
    public init(isCreator: Bool,
                alerts: HouseDetailAlerts,
                adapter: MyAdapter<House>) {
        
        self.isCreator = isCreator
        self.alerts = alerts
        self.adapter = adapter
    }
}


// MARK: - UIResponder
extension GenericDetailManager {
    
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
extension GenericDetailManager {
    
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
private extension GenericDetailManager {
    
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
    
    func makeUpdatedHouse(name: String, password: String) -> House? {

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
    
    func uploadHouse(_ updatedHouse: House) {
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
public protocol GenericHouseholdCache {
    associatedtype House: Household

    var house: House { get }
}

public protocol GenericDetailRemoteAPI: DuplcatesRemoteAPI {
    associatedtype House: Household
    
    func uploadHouse(_ house: House,
                     completion: @escaping (Error?) -> Void)
}

public typealias MyAdapter<House: Household> = (
    getHouse: () -> House,
    uploadHouse: (House, @escaping (Error?) -> Void) -> Void,
    checkForDuplicates: (String, @escaping (DuplicateError?) -> Void) -> Void)
