//
//  XCTestCase+MemoryLeakTracking.swift
//  
//
//  Created by Nikolai Nobadi on 2/3/22.
//

import XCTest
import NnHousehold

extension XCTestCase {
    
    struct TestHouse: Household {
        var id: String
        var name: String
        var creator: String
        var password: String
        var members: [HouseholdMember]
        var lastLogin: String
    }
    
    struct TestHouseMember: HouseholdMember {
        var id: String = ""
        var name: String = ""
        var isAdmin: Bool = false
    }
    
    func trackForMemoryLeaks(_ instance: AnyObject,
                             file: StaticString = #filePath,
                             line: UInt = #line) {
        
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
