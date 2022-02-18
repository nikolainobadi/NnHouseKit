//
//  HouseholdLoadManager.swift
//  
//
//  Created by Nikolai Nobadi on 2/18/22.
//

import NnHousehold

public final class HouseholdLoadManager {
    
    // MARK: - Properties
    private let user: HouseholdUser
    private let store: HouseholdStore
    private let policy: HouseholdLoadPolicy
    private let remote: HouseholdLoadRemoteAPI
    private let memberLoader: HouseholdMemberLoader
    private let modifier: ConvertedHouseholdModifier
    
    
    // MARK: - Init
    public init(user: HouseholdUser,
                store: HouseholdStore,
                policy: HouseholdLoadPolicy,
                remote: HouseholdLoadRemoteAPI,
                memberLoader: HouseholdMemberLoader,
                modifier: ConvertedHouseholdModifier) {

        self.user = user
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
        // MARK: - TODO
        // complete with .noHouse error
        guard user.houseId != "" else { return }
        
        remote.fetchHouse(user.houseId) { [weak self] result in
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
            // MARK: - TODO
            // complete with .noAccess error
        }
    }
    
    func saveHouse(_ house: Household, completion: @escaping (Error?) -> Void) {
        
        memberLoader.loadMembers(for: house) { [weak self] updatedHouse in
            
            guard let updatedHouse = updatedHouse else {
                // MARK: - TODO -> complete with error
                return
            }
            
            self?.store.setHouse(updatedHouse)
            completion(nil)
        }
    }
    
    func convertHouse(_ house: Household, completion: @escaping (Error?) -> Void) {
        
        // MARK: - TODO
    }
}


// MARK: - Dependencies
public protocol HouseholdLoadPolicy {
    func isMember(of house: Household) -> Bool
    func isConverting(_ house: Household) -> Bool
}

public protocol HouseholdStore {
    func setHouse(_ house: Household)
}

public protocol HouseholdLoadRemoteAPI {
    func fetchHouse(_ id: String, completion: @escaping (Result<Household, Error>) -> Void)
}

public protocol ConvertedHouseholdModifier {
    func convertHouse(_ house: Household) -> Household
}

public protocol HouseholdLoader {
    func loadHouse(completion: @escaping (Error?) -> Void)
}

public protocol HouseholdMemberLoader {
    func loadMembers(for house: Household,
                     completion: @escaping (Household?) -> Void)
}
