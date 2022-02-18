//
//  HouseholdLoadManager.swift
//  
//
//  Created by Nikolai Nobadi on 2/18/22.
//

import NnHousehold

public final class HouseholdLoadManager {
    
    // MARK: - Properties
    private let houseId: String
    private let store: HouseholdStore
    private let policy: HouseholdLoadPolicy
    private let remote: HouseholdLoadRemoteAPI
    private let memberLoader: HouseholdMemberLoader
    private let modifier: ConvertedHouseholdModifier
    
    
    // MARK: - Init
    public init(houseId: String,
                store: HouseholdStore,
                policy: HouseholdLoadPolicy,
                remote: HouseholdLoadRemoteAPI,
                memberLoader: HouseholdMemberLoader,
                modifier: ConvertedHouseholdModifier) {

        self.houseId = houseId
        self.store = store
        self.policy = policy
        self.remote = remote
        self.memberLoader = memberLoader
        self.modifier = modifier
    }
}

// MARK: - Loader
extension HouseholdLoadManager: HouseholdLoader {
    
    public func loadHouse(completion: @escaping (Error?) -> Void) {
        guard houseId != "" else {
            return completion(HouseFetchError.noHouse)
        }
        
        remote.fetchHouse(houseId) { [weak self] result in
            switch result {
            case .success(let house):
                self?.handleRecievedHouse(house, completion: completion)
            case .failure(let error):
                completion(error)
            }
        }
    }
}


// MARK: - Private Methods
private extension HouseholdLoadManager {
    
    func handleRecievedHouse(_ house: Household, completion: @escaping (Error?) -> Void) {
    
        if policy.isMember(of: house) {
            saveHouse(house, completion: completion)
        } else if policy.isConverting(house) {
            convertHouse(house, completion: completion)
        } else {
            completion(HouseFetchError.noAccess)
        }
    }
    
    func saveHouse(_ house: Household, completion: @escaping (Error?) -> Void) {
        
        memberLoader.loadMembers(for: house) { [weak self] updatedHouse in
            guard let updatedHouse = updatedHouse else {
                return completion(HouseFetchError.fetchError)
            }
            
            self?.store.setHouse(updatedHouse, completion: completion)
        }
    }
    
    func convertHouse(_ house: Household, completion: @escaping (Error?) -> Void) {
        do {
            let updatedHouse = try modifier.convertHouse(house)
            
            remote.uploadHouse(updatedHouse, completion: completion)
        } catch {
            completion(error)
        }
    }
}


// MARK: - Dependencies
public protocol HouseholdStore {
    func setHouse(_ house: Household, completion: @escaping (Error?) -> Void)
}

public protocol HouseholdLoadPolicy {
    func isMember(of house: Household) -> Bool
    func isConverting(_ house: Household) -> Bool
}

public protocol HouseholdLoadRemoteAPI {
    func fetchHouse(_ id: String, completion: @escaping (Result<Household, Error>) -> Void)
    
    func uploadHouse(_ house: Household, completion: @escaping (Error?) -> Void)
}

public protocol HouseholdMemberLoader {
    func loadMembers(for house: Household,
                     completion: @escaping (Household?) -> Void)
}

public protocol ConvertedHouseholdModifier {
    func convertHouse(_ house: Household) throws -> Household
}
