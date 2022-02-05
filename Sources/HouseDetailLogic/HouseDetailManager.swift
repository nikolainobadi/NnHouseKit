//
//  File.swift
//  
//
//  Created by Nikolai Nobadi on 2/3/22.
//

import NnHousehold

public final class HouseDetailManager {
    
    // MARK: - Properties
    private let isCreator: Bool
    private let alerts: HouseDetailAlerts
    private let remote: HouseholdUploader
    private let houseCache: HouseholdCache
    
    private var house: Household { houseCache.house }
    
    // MARK: - Init
    public init(isCreator: Bool,
                alerts: HouseDetailAlerts,
                remote: HouseholdUploader,
                houseCache: HouseholdCache) {
        
        self.isCreator = isCreator
        self.alerts = alerts
        self.remote = remote
        self.houseCache = houseCache
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
        
        uploadHouse(updatedHouse)
    }
    
    func makeUpdatedHouse(name: String, password: String) -> Household? {
        
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
    
    func uploadHouse(_ updatedHouse: Household) {
        let passwordChanged = house.password != updatedHouse.password
        
        remote.uploadHouse(updatedHouse) { [weak self] error in
            if let error = error {
                self?.showError(error)
            } else {
                self?.showPasswordChangedAlert(passwordChanged)
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
public protocol HouseholdCache {
    var house: Household { get }
}

public protocol HouseholdUploader {
    func uploadHouse(_ house: Household, completion: @escaping (Error?) -> Void)
}

public protocol HouseDetailAlerts {
    func showPasswordChangedAlert()
    func showPasswordAlert(_ password: String)
    func showError(_ error: Error, completion: (() -> Void)?)
    func showEditHouseAlert(namePlaceholder: String,
                            passwordPlaceholder: String,
                            completion: @escaping (String, String) -> Void)
}

