//
//  JoinHouseModifier.swift
//  
//
//  Created by Nikolai Nobadi on 2/8/22.
//

public final class HouseholdAndUserModifier {
    private init() { }
    
    public static func makeUpdatedUser(_ user: HouseholdUser, houseId: String) -> HouseholdUser {
        
        var updatedUser = user
        
        updatedUser.houseId = houseId
        
        return updatedUser
    }
    
    public static func makeUpdatedHouseList(oldHouse: Household?,
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
