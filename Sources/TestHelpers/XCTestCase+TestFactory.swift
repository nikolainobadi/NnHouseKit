//
//  XCTestCase+TestFactory.swift
//  
//
//  Created by Nikolai Nobadi on 3/2/22.
//

//
//  XCTestCase+MemoryLeakTracking.swift
//
//
//  Created by Nikolai Nobadi on 2/7/22.
//

import XCTest
import NnHousehold

public extension XCTestCase {
    
    func makeTestHouse(members: [TestNnHouseMember] = []) -> TestNnHouse {
        
        TestNnHouse(id: getTestName(.testHouseId),
                    password: getTestName(.testHouseName),
                    members: members)
    }
    
    func makeTestMemberList() -> [TestNnHouseMember] {
        [makeTestMember(isAdmin: true),
         makeTestMember(id: getTestName(.secondId),
                        name: getTestName(.secondName))]
    }
    
    func makeTestMember(id: String? = nil,
                        name: String? = nil,
                        isAdmin: Bool = false) -> TestNnHouseMember {

        TestNnHouseMember(id: id ?? getTestName(.testUserId),
                          name: name ?? getTestName(.testUsername),
                          isAdmin: isAdmin)
    }
}


