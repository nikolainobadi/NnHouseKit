//
//  DuplcatesRemoteAPI.swift
//  
//
//  Created by Nikolai Nobadi on 2/15/22.
//

public enum DuplicateError: Error {
    case nameTaken
    case networkError
}

public protocol DuplcatesRemoteAPI {
    func checkForDuplicates(name: String,
                            completion: @escaping (DuplicateError?) -> Void)
}
