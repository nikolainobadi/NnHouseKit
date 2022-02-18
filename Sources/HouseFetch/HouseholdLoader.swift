//
//  HouseholdLoader.swift
//  
//
//  Created by Nikolai Nobadi on 2/18/22.
//

public protocol HouseholdLoader {
    func loadHouse(completion: @escaping (Error?) -> Void)
}
