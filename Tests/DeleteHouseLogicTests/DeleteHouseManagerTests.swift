//
//  DeleteHouseManagerTests.swift
//  
//
//  Created by Nikolai Nobadi on 2/8/22.
//

import XCTest
import TestHelpers
import DeleteHouseLogic

final class DeleteHouseManagerTests: XCTestCase {
    
    
}


// MARK: - SUT
extension DeleteHouseManagerTests {
    
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: DeleteHouseManager, remote: DeleteHouseRemoteAPISpy) {
        
        let remote = DeleteHouseRemoteAPISpy()
        let sut = DeleteHouseManager(remote: remote)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, remote)
    }
}


// MARK: - Helper Classes
extension DeleteHouseManagerTests {
    
    class DeleteHouseRemoteAPISpy: DeleteHouseRemoteAPI {
        
    }
}
