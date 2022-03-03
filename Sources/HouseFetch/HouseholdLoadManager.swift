//
//  HouseholdLoadManager.swift
//  
//
//  Created by Nikolai Nobadi on 2/18/22.
//

import NnHousehold

public final class HouseholdLoadManager<Store: HouseholdStore, Remote: HouseholdLoadRemoteAPI> where Store.House == Remote.House  {
    
    // MARK: - Properties
    public typealias House = Remote.House
    public typealias Member = House.Member
    
    private let houseId: String
    private let store: Store
    private let remote: Remote
    
    // MARK: - TODO
    private var completeMembers = [Member]()
    
    
    // MARK: - Init
    public init(houseId: String,
                store: Store,
                remote: Remote,
                currentMembers: [Member]) {
        
        self.houseId = houseId
        self.store = store
        self.remote = remote
        self.completeMembers = currentMembers
    }
}

// MARK: - Loader
extension HouseholdLoadManager: NnHouseLoader {
    
    public func loadHouse(completion: @escaping (Error?) -> Void) {
        guard houseId != "" else {
            return completion(HouseFetchError.noHouse)
        }
        
        remote.fetchHouse(houseId) { [weak self] result in
            switch result {
            case .success(let house):
                self?.handleRecievedHouse(house, completion)
            case .failure(let error):
                completion(error)
            }
        }
    }
}


// MARK: - Private Methods
private extension HouseholdLoadManager {
    
    func handleRecievedHouse(_ house: House,
                             _ completion: @escaping (Error?) -> Void) {
        guard
            store.isMember(of: house)
        else { return completion(HouseFetchError.noAccess) }
        
        fetchHouseMembers(for: house) { [weak self] members in
            guard let members = members else {
                return completion(HouseFetchError.fetchError)
            }

            self?.saveHouse(house, members: members)
            completion(nil)
        }
    }
    
    func fetchHouseMembers(for house: House,
                           completion: @escaping ([Member]?) -> Void) {
        
        let missingIds = getMissingMemberIds(house.members.map({ $0.id }))

        guard missingIds.count != 0 else { return completion([]) }

        remote.fetchInfoList(memberIds: missingIds) { result in
            switch result {
            case .success(let infoList): completion(infoList)
            case .failure: completion(nil)
            }
        }
    }
    
    func getMissingMemberIds(_ memberIds: [String]) -> [String] {
        memberIds.filter { id in
            !(completeMembers.map({ $0.id }).contains(id))
        }
    }
    
    func saveHouse(_ house: House, members: [Member]) {
        var updatedHouse = house
        
        updatedHouse.members = getUpdatedMembers(houseMembers: house.members, newList: members)
        
        store.setHouse(updatedHouse)
    }
    
    func getUpdatedMembers(houseMembers: [Member],
                           newList: [Member]) -> [Member] {

        // get current info list
        let allMembers = completeMembers + newList
        let currentList = allMembers.filter { info in
            houseMembers.contains(where: { $0.id == info.id })
        }

        // save current info
        completeMembers = currentList.compactMap { member in
            makeUpdatedMember(member, houseMembers: houseMembers)
        }

        return completeMembers
    }
    
    func makeUpdatedMember(_ member: Member,
                           houseMembers: [Member]) -> Member? {
        guard
            let houseMember = houseMembers.first(where: {$0.id == member.id })
        else { return nil }

        var updatedMember = member

        updatedMember.isAdmin = houseMember.isAdmin

        return updatedMember
    }
}


// MARK: - Dependencies
public protocol HouseholdStore {
    associatedtype House: NnHouse
    
    func isMember(of house: House) -> Bool
    func setHouse(_ house: House)
}

public protocol HouseholdLoadRemoteAPI {
    associatedtype House: NnHouse
    
    func fetchHouse(_ id: String,
                    completion: @escaping (Result<House, Error>) -> Void)
    func fetchInfoList(memberIds: [String],
                       completion: @escaping (Result<[House.Member], Error>) -> Void)
}
