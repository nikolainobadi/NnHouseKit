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
    
    // MARK: - Enum
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
    
    
    // MARK: - Test Structs
    struct TestNnHouseUser: NnHouseUser {
        public typealias House = TestNnHouse
        
        public var id: String
        public var name: String
        public var houseId: String
        public var currentHouse: House?
        public var createdHouseIds: [String]
        
        public init(id: String = "",
                    name: String = "",
                    houseId: String = "",
                    currentHouse: House? = nil,
                    createdHouseIds: [String] = []) {
            
            self.id = id
            self.name = name
            self.houseId = houseId
            self.currentHouse = currentHouse
            self.createdHouseIds = createdHouseIds
        }
    }
    
    struct TestNnHouse: NnHousehold {
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
    
    struct TestNnHouseMember: NnHouseMember, Equatable {
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
}


// MARK: - Factory

public extension XCTestCase {
    
    // MARK: User
    func makeTestUser(houseId: String = "",
                      house: TestNnHouse? = nil) -> TestNnHouseUser {
        
        TestNnHouseUser(id: getTestName(.testUserId),
                        name: getTestName(.testUsername),
                        houseId: houseId,
                        currentHouse: house,
                        createdHouseIds: [])
    }
    
    
    // MARK: House
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
    
    
    // MARK: Members
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


