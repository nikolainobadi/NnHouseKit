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
    
    // MARK: - User
    func makeTestUser(houseId: String = "",
                      house: TestNnHouse? = nil) -> TestNnHouseUser {
        
        TestNnHouseUser(id: getTestName(.testUserId),
                        name: getTestName(.testUsername),
                        houseId: houseId,
                        currentHouse: house,
                        createdHouseIds: [])
    }
    
    
    // MARK: - House
    func makeTestHouse(id: String? = nil,
                       name: String? = nil,
                       creator: String = "",
                       password: String? = nil,
                       members: [TestNnHouseMember] = []) -> TestNnHouse {
        
        TestNnHouse(id: id ?? getTestName(.testHouseId),
                    name: name ?? getTestName(.testHouseName),
                    creator: creator,
                    password: password ?? getTestName(.testHouseName),
                    members: members)
    }
    
    
    // MARK: - Members
    func makeTestMemberList(withNames: Bool = true) -> [TestNnHouseMember] {
        [makeTestMember(name: withNames ? nil : "",
                        isAdmin: true),
         makeTestMember(id: getTestName(.secondId),
                        name: withNames ?  getTestName(.secondName) : "")]
    }
    
    func makeTestMember(id: String? = nil,
                        name: String? = nil,
                        isAdmin: Bool = false) -> TestNnHouseMember {

        TestNnHouseMember(id: id ?? getTestName(.testUserId),
                          name: name ?? getTestName(.testUsername),
                          isAdmin: isAdmin)
    }
}


