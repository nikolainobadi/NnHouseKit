//
//  File.swift
//  
//
//  Created by Nikolai Nobadi on 3/3/22.
//

import XCTest
import NnHousehold

public final class NnUserAndHouseRemoteAPISpy<User: NnHouseUser> {
    
    public var user: User?
    public var houses: [User.House]?
    
    private var dupeCompletion: ((DuplicateError?) -> Void)?
    private var completion: ((Error?) -> Void)?
    
    public init() { }
}


// MARK: - Remote
extension NnUserAndHouseRemoteAPISpy: NnUserAndHouseRemoteAPI {
    public func upload(user: User,
                       houses: [House],
                       completion: @escaping (Error?) -> Void) {
        self.user = user
        self.houses = houses
        self.completion = completion
    }
    
    public func complete(with error: Error?,
                  file: StaticString = #filePath, line: UInt = #line) {
        guard
            let completion = completion
        else {
            return XCTFail("no request made", file: file, line: line)
        }
        
        completion(error)
    }
}


extension NnUserAndHouseRemoteAPISpy: DuplcatesRemoteAPI {
    
    public func checkForDuplicates(name: String,
                                   completion: @escaping (DuplicateError?) -> Void) {
        
        self.dupeCompletion = completion
    }
    
    public func dupeComplete(with error: DuplicateError?,
                             file: StaticString = #filePath,
                             line: UInt = #line) {
        guard
            let completion = dupeCompletion
        else { return XCTFail("No request made...", file: file, line: line) }
        
        completion(error)
    }
}

