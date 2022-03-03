//
//  JoinHouseModifier.swift
//  
//
//  Created by Nikolai Nobadi on 2/8/22.
//

public final class NnUserAndHouseModifier {
    private init() { }
}

public extension NnUserAndHouseModifier {

    static func makeUpdatedUser<User>(_ user: User,
                                      houseId: String,
                                      isCreator: Bool = false) -> User where User: NnHouseUser {
        var updatedUser = user
        
        updatedUser.houseId = houseId
        
        if isCreator {
            updatedUser.createdHouseIds.append(houseId)
        }
        
        return updatedUser
    }
    
    static func removeUser<User>(_ user: User,
                                 from house: User.House) -> User.House where User: NnHouseUser {
        var updatedHouse = house
        
        updatedHouse.members = updatedHouse.members.filter { $0.id != user.id }
        
        return updatedHouse
    }
    
    static func addMember<House>(_ member: House.Member,
                                 to house: House) -> House where House: NnHouse {
        var updatedHouse = house
        
        updatedHouse.members.append(member)
        
        return updatedHouse
    }
}


// MARK: - Old
public final class HouseholdAndUserModifier {
    private init() { }
    
    public static func makeUpdatedUser(_ user: HouseholdUser, houseId: String, isCreator: Bool = false) -> HouseholdUser {
        
        var updatedUser = user
        
        updatedUser.houseId = houseId
        
        if isCreator {
            updatedUser.createdHouseIds.append(houseId)
        }
        
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
