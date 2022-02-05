//
//  HouseSelectManagerTests.swift
//  
//
//  Created by Nikolai Nobadi on 2/5/22.
//

import XCTest
import NnHousehold
import HouseSelectLogic

final class HouseSelectManagerTests: XCTestCase {
    
    
}


// MARK: - SUT
extension HouseSelectManagerTests {
    
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) {
        
    }
}


// MARK: - Helper Classes
extension HouseSelectManagerTests {
    
    class MockHouseSelectPolicy: HouseSelectPolicy {
        
        var canCreateMoreHouses: Bool
        
        init(canCreate: Bool = false) {
            canCreateMoreHouses = canCreate
        }
        
    }
    
    class HouseSelectAlertsSpy: HouseSelectAlerts {
        
        private var completion: ((String, String) -> Void)?
        
        func showCreateHouseAlert(completion: @escaping (String, String) -> Void) {
            self.completion = completion
        }
        
        func complete(name: String, pwd: String,
                      file: StaticString = #filePath, line: UInt = #line) {
            guard
                let completion = completion
            else {
                return XCTFail("no alert made...", file: file, line: line)
            }

            completion(name, pwd)
        }
    }
    
    class HouseSelectRemoteAPISpy: HouseSelectRemoteAPI {
        
        private var house: Household?
        private var completion: ((Error?) -> Void)?
        
        func uploadNewHouse(_ house: Household,
                            completion: @escaping (Error?) -> Void) {
            
            self.house = house
            self.completion = completion
        }
        
        func complete(error: Error?,
                      file: StaticString = #filePath, line: UInt = #line) {
            guard
                let completion = completion, house != nil
            else {
                return XCTFail("no request made...", file: file, line: line)
            }

            completion(error)
        }
    }
}
