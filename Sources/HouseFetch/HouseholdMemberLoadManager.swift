//
//  HouseholdMemberLoadManager.swift
//  
//
//  Created by Nikolai Nobadi on 2/18/22.
//

import NnHousehold

public final class HouseholdMemberLoadManager {
    
    // MARK: - Properties
    private let remote: HouseholdMemberRemoteAPI
    
    private var storedMemberList: [HouseholdMember]
    
    
    // MARK: - Init
    public init(remote: HouseholdMemberRemoteAPI,
                memberList: [HouseholdMember]) {
        
        self.remote = remote
        self.storedMemberList = memberList
    }
}


// MARK: - Loader
extension HouseholdMemberLoadManager: HouseholdMemberLoader {
    
    public func loadMembers(for house: Household,
                            completion: @escaping (Household?) -> Void) {
        
        fetchHouseMembers(for: house) { [weak self] newList in
            guard let newList = newList else { return completion(nil) }
            
            self?.updateHouse(house, newList: newList, completion: completion)
        }
    }
}


// MARK: - Private Methods
private extension HouseholdMemberLoadManager {
    
    func fetchHouseMembers(for house: Household,
                           completion: @escaping ([HouseholdMember]?) -> Void) {
        
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
            !(storedMemberList.map({ $0.id }).contains(id))
        }
    }
    
    func updateHouse(_ house: Household,
                     newList: [HouseholdMember],
                     completion: @escaping (Household?) -> Void) {
        
        let currentMembers = getUpdatedMembers(houseMembers: house.members,
                                               newList: newList)
        var updatedHouse = house

        updatedHouse.members = currentMembers
        completion(updatedHouse)
    }
    
    func getUpdatedMembers(houseMembers: [HouseholdMember],
                           newList: [HouseholdMember]) -> [HouseholdMember] {

        // get current info list
        let currentMemberList = (storedMemberList + newList).filter { info in
            houseMembers.contains(where: { $0.id == info.id })
        }

        // save current info
        storedMemberList = currentMemberList.compactMap { member in
            guard var updatedMember = houseMembers.first(where: {$0.id == member.id }) else { return nil }
            
            updatedMember.isAdmin = member.isAdmin // mainly for currentUser
            
            return updatedMember
        }
        
        return storedMemberList
    }
}


// MARK: - Dependencies
public protocol HouseholdMemberRemoteAPI {
    func fetchInfoList(memberIds: [String],
                       completion: @escaping (Result<[HouseholdMember], Error>) -> Void)
}
