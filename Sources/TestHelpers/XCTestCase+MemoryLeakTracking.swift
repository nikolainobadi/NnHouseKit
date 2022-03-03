//
//  XCTestCase+MemoryLeakTracking.swift
//  
//
//  Created by Nikolai Nobadi on 2/7/22.
//

import XCTest
import NnHousehold

public extension XCTestCase {
    
    struct TestHouseholdUser: HouseholdUser {
        public var id: String
        public var name: String
        public var houseId: String
        public var currentHouse: Household?
        public var createdHouseIds: [String]
        
        public init(id: String = "",
                    name: String = "",
                    houseId: String = "",
                    currentHouse: Household? = nil,
                    createdHouseIds: [String] = []) {
            
            self.id = id
            self.name = name
            self.houseId = houseId
            self.currentHouse = currentHouse
            self.createdHouseIds = createdHouseIds
        }
    }
    
    struct TestNnHouse: NnHouse {
        public typealias Member = TestNnHouseMember
        
        public var id: String
        public var name: String
        public var creator: String
        public var password: String
        public var members: [Member]
        public var lastLogin: String
        
        public init(id: String = "",
                    name: String = "",
                    creator: String = "",
                    password: String = "",
                    members: [Member] = [],
                    lastLogin: String = "") {
            
            self.id = id
            self.name = name
            self.creator = creator
            self.password = password
            self.members = members
            self.lastLogin = lastLogin
        }
    }
    
    struct TestHouse: Household {
        public var id: String
        public var name: String
        public var creator: String
        public var password: String
        public var members: [HouseholdMember]
        public var lastLogin: String
        
        public init(id: String = "",
                    name: String = "",
                    creator: String = "",
                    password: String = "",
                    members: [HouseholdMember] = [],
                    lastLogin: String = "") {
            
            self.id = id
            self.name = name
            self.creator = creator
            self.password = password
            self.members = members
            self.lastLogin = lastLogin
        }
    }
    
    struct TestNnHouseMember: NnHouseMember {
        public var id: String
        public var name: String
        public var isAdmin: Bool
        
        public init(id: String = "",
                    name: String = "",
                    isAdmin: Bool = false) {
            
            self.id = id
            self.name = name
            self.isAdmin = isAdmin
        }
    }
    
    struct TestHouseMember: HouseholdMember {
        public var id: String
        public var name: String
        public var isAdmin: Bool
        
        public init(id: String = "",
                    name: String = "",
                    isAdmin: Bool = false) {
            
            self.id = id
            self.name = name
            self.isAdmin = isAdmin
        }
    }
    
    func trackForMemoryLeaks(_ instance: AnyObject,
                             file: StaticString = #filePath,
                             line: UInt = #line) {
        
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
    
    enum TestName: String {
        case testUserId
        case testUsername
        
        case testHouseId
        case testHouseName
        
        case testRoomId
        case testRoomName
        
        case testTaskId
        case testTaskName
        
        case firstId
        case secondId
        case thirdId
        
        case firstName
        case secondName
        case thirdName
    }
    
    func getTestName(_ value: TestName) -> String {
        value.rawValue
    }
}

