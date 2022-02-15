//
//  HouseholdAndUserRemoteAPISpy.swift
//  
//
//  Created by Nikolai Nobadi on 2/15/22.
//

import XCTest
import NnHousehold

public final class HouseholdAndUserRemoteAPISpy {
    
    public var user: HouseholdUser?
    public var houses: [Household]?
    
    private var completion: ((Error?) -> Void)?
    
    public init() { }
}


// MARK: - Remote
extension HouseholdAndUserRemoteAPISpy: HouseholdAndUserRemoteAPI {
    
    public func upload(user: HouseholdUser,
                houses: [Household],
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
