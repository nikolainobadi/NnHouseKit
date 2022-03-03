//
//  NnHouseUser.swift
//  
//
//  Created by Nikolai Nobadi on 2/8/22.
//

public protocol NnHouseUser {
    associatedtype House: NnHouse
    
    var id: String { get }
    var name: String { get }
    var houseId: String { get set }
    var currentHouse: House? { get }
    var createdHouseIds: [String] { get set }
}
