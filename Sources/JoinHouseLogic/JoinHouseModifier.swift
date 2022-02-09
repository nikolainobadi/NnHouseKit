//
//  JoinHouseModifier.swift
//  
//
//  Created by Nikolai Nobadi on 2/8/22.
//

import NnHousehold

final class JoinHouseModifier {
    private init() { }
    
    static func makeUpdatedUser(_ user: HouseholdUser, houseId: String) -> HouseholdUser {
        
        var updatedUser = user
        
        updatedUser.houseId = houseId
        
        return updatedUser
    }
    
    static func makeUpdatedHouseList(oldHouse: Household?,
                                     newHouse: Household,
                                     newMember: HouseholdMember) -> [Household] {
        var list = [Household]()
        
        if var updatedOldHouse = oldHouse {
            updatedOldHouse.members = updatedOldHouse.members.filter { $0.id != newMember.id }
            
            list.append(updatedOldHouse)
        }
        
        var updatedNewHouse = newHouse
        
        updatedNewHouse.members.append(newMember)
        list.append(updatedNewHouse)
        
        return list
    }
}
