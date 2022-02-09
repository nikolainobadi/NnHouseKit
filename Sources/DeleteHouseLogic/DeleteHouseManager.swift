//
//  DeleteHouseManager.swift
//  
//
//  Created by Nikolai Nobadi on 2/8/22.
//

public final class DeleteHouseManager {
    
    // MARK: - Properies
    private let remote: DeleteHouseRemoteAPI
    
    
    // MARK: - Init
    public init(remote: DeleteHouseRemoteAPI) {
        self.remote = remote
    }
}


// MARK: - Loader
extension DeleteHouseManager: DeleteHouseLoader {
    
    public func loadData(completion: @escaping (Result<String, DeleteHouseError>) -> Void) {
        
        
    }
}


// MARK: - Dependencies
public protocol DeleteHouseRemoteAPI {
    
}

