//
//  File.swift
//  
//
//  Created by Nikolai Nobadi on 3/1/22.
//

//import NnHousehold
//
//public protocol HouseDetailAdapter: GenericHouseholdCache, GenericDetailRemoteAPI { }
//
//public class GenericDetailAdapter<Cache: GenericHouseholdCache, Remote: GenericDetailRemoteAPI>: HouseDetailAdapter where Remote.House == Cache.House {
//
//    public typealias House = Remote.House
//
//    private let cache: Cache
//    private let remote: Remote
//
//    public var house: Remote.House { cache.house }
//
//    public init(cache: Cache, remote: Remote) {
//        self.cache = cache
//        self.remote = remote
//    }
//
//    public func uploadHouse(_ house: Remote.House, completion: @escaping (Error?) -> Void) {
//
//        remote.uploadHouse(house, completion: completion)
//    }
//
//    public func checkForDuplicates(name: String, completion: @escaping (DuplicateError?) -> Void) {
//
//        remote.checkForDuplicates(name: name, completion: completion)
//    }
//}
