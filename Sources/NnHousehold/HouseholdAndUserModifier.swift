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
    
    public static func removeUser(_ user: HouseholdUser,
                                  from house: Household) -> Household {
        var updatedHouse = house
        
        updatedHouse.members = updatedHouse.members.filter { $0.id != user.id }
        
        return updatedHouse
    }
    
    public static func addMember(_ member: HouseholdMember,
                                 to house: Household) -> Household {
        var updatedHouse = house
        
        updatedHouse.members.append(member)
        
        return updatedHouse
    }
}
