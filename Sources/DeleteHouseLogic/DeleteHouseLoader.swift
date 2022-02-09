//
//  File.swift
//  
//
//  Created by Nikolai Nobadi on 2/9/22.
//

public protocol DeleteHouseLoader {
    func loadData(completion: @escaping (Result<String, DeleteHouseError>) -> Void)
}
