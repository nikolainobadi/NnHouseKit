//
//  NnUserAndHouseModifier.swift
//  
//
//  Created by Nikolai Nobadi on 2/8/22.
//

public final class NnUserAndHouseModifier {
    private init() { }
}

public extension NnUserAndHouseModifier {

    static func makeUpdatedUser<NnUser>(_ user: NnUser,
                                      houseId: String,
                                      isCreator: Bool = false) -> NnUser where NnUser: NnHouseUser {
        var updatedUser = user
        
        updatedUser.houseId = houseId
        
        if isCreator {
            updatedUser.createdHouseIds.append(houseId)
        }
        
        return updatedUser
    }
    
    static func removeUser<NnUser>(_ user: NnUser,
                                 from house: NnUser.NnHouse) -> NnUser.NnHouse where NnUser: NnHouseUser {
        var updatedHouse = house
        
        updatedHouse.members = updatedHouse.members.filter { $0.id != user.id }
        
        return updatedHouse
    }
    
    static func addMember<NnHouse>(_ member: NnHouse.Member,
                                 to house: NnHouse) -> NnHouse where NnHouse: NnHousehold {
        var updatedHouse = house
        
        updatedHouse.members.append(member)
        
        return updatedHouse
    }
}
