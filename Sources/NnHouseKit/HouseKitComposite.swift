//
//  HouseKitComposite.swift
//  
//
//  Created by Nikolai Nobadi on 2/4/22.
//

// MARK: - Imports
import UIKit

import HouseFetch
import NnHousehold
import HouseListTable

import HouseDetailUI
import HouseDetailLogic

import HouseSelectUI
import HouseSelectLogic

import HouseSearchUI
import HouseSearchLogic

import JoinHouseUI
import JoinHouseLogic


public final class HouseKitComposite {
    private init() { }
}

public extension HouseKitComposite {
    
    // MARK: HouseFetch
    static func makeHouseholdLoader<Store: NnHouseStore, Remote: HouseholdLoadRemoteAPI>(
        houseId: String,
        store: Store,
        remote: Remote,
        currentMemberList: [Remote.House.Member]) -> NnHouseLoader where Store.House == Remote.House {
    
            HouseholdLoadManager(houseId: houseId,
                                 store: store,
                                 remote: remote,
                                 currentMembers: currentMemberList)
    }
    
    
    // MARK: HouseDetail
    static func makeHouseDetailVC<Cache: NnHouseCache, Remote: NnHouseDetailRemoteAPI>(isCreator: Bool,
                                houseName: String,
                                alerts: HouseDetailAlerts,
                                remote: Remote,
                                houseCache: Cache,
                                cellInfoPublisher: HouseListCellInfoPublisher,
                                viewConfig: HouseDetailViewConfig,
                                switchHouse: @escaping () -> Void) -> UIViewController where Remote.House == Cache.House {
        
        let adapter = makeDetailAdapter(remote: remote, cache: houseCache)
        let manager = HouseDetailManager(isCreator: isCreator,
                                           alerts: alerts,
                                           adapter: adapter)
        let tableVC = makeHouseListTable(
            title: "Household Members",
            publisher: cellInfoPublisher,
            responder: (delete: manager.deleteMember(memberId:),
                        buttonAction: manager.toggleAdminStatus(memberId:)))
            
        return HouseDetailVC(
            tableVC: tableVC,
            houseName: houseName,
            config: viewConfig,
            responder: (editHouse: manager.editHouse,
                        switchHouse: switchHouse,
                        showPassword: manager.showPassword)
        )
    }
    
    
    // MARK: HouseSelect
    static func makeHouseSelectVC<Remote: HouseSelectRemoteAPI,
                                    Factory: NnHouseFactory>(
                                        user: Remote.User,
                                        selectType: HouseholdSelectType,
                                        config: HouseSelectViewConfig,
                                        policy: HouseSelectPolicy,
                                        alerts: HouseSelectAlerts,
                                        remote: Remote,
                                        factory: Factory,
                                        joinHouse: @escaping () -> Void,
                                        showDeleteHouse: @escaping () -> Void,
                                        reloadData: @escaping () -> Void) -> UIViewController where Remote.House == Factory.House {
        let manager = HouseSelectManager(
            user: user,
            policy: policy,
            alerts: alerts,
            remote: remote,
            factory: factory,
            router: (finished: reloadData, showDeleteHouse: showDeleteHouse))

        let viewModel = HouseSelectViewModel(selectType: selectType,
                                             createHouse: manager.createNewHouse,
                                             joinHouse: joinHouse)

        let rootView = HouseSelectRootView(config: config,
                                           viewModel: viewModel)

        return HouseSelectVC(rootView: rootView)
    }
    
    
    // MARK: HouseSeearch
    static func makeHouseSearchVC(config: SearchViewConfig,
                                  backgroundColor: UIColor?,
                                  alerts: HouseSearchAlerts,
                                  remote: HouseSearchRemoteAPI,
                                  cellInfoPublisher: HouseListCellInfoPublisher,
                                  showJoinHouse: @escaping (String) -> Void) -> UIViewController {
        
        let manager = HouseSearchManager(alerts: alerts, remote: remote)
        let searchView = HouseSearchSearchView(
            config: config,
            responder: (
                changeSearchParameter: manager.changeSearchParameter(_:),
                searchForHouse: manager.searchForHouse(_:))
        )
        
        let tableVC = makeHouseListTable(
            publisher: cellInfoPublisher,
            responder: (delete: nil, buttonAction: showJoinHouse))
        
        return HouseSearchVC(searchView: searchView,
                             tableVC: tableVC,
                             backgroundColor: backgroundColor)
    }
    
    
    // MARK: JoinHouse
    static func makeJoinHouseVC<Remote: NnUserAndHouseRemoteAPI,
                                Factory: NnHouseMemberFactory>(
                                    user: Remote.User,
                                    houseToJoin: Remote.House,
                                    alerts: JoinHouseAlerts,
                                    remote: Remote,
                                    factory: Factory,
                                    config: JoinHouseViewConfig,
                                    viewModelInfo: JoinHouseViewModelInfo,
                                    finished: @escaping () -> Void) -> UIViewController where Remote.House.Member == Factory.Member {

        let manager = JoinHouseManager(user: user,
                                       houseToJoin: houseToJoin,
                                       alerts: alerts,
                                       remote: remote,
                                       factory: factory,
                                       finished: finished)

        let viewModel = JoinHouseViewModel(
            info: viewModelInfo,
            joinHouse: manager.joinHouse(password:))

        let rootView = JoinHouseRootView(config: config,
                                         viewModel: viewModel)

        return JoinHouseVC(rootView: rootView,
                           fieldsToObserve: [rootView.passwordField])
    }
    
    
    // MARK: - HouseList
    static func makeHouseListTable(title: String = "",
                                   publisher: HouseListCellInfoPublisher,
                                   responder: HouseListCellResponder) -> UIViewController {
        HouseListTableVC(
            presenter:HouseListPresentationAdapter(title: title,
                                                   publisher: publisher,
                                                   responder: responder))
    }
}


// MARK: - Private Methods
private extension HouseKitComposite {
    
    static func makeDetailAdapter<Remote: NnHouseDetailRemoteAPI, Cache: NnHouseCache>(remote: Remote, cache: Cache) -> MyAdapter<Remote.House> where Remote.House == Cache.House {
        
        return (
            getHouse: { cache.house },
            uploadHouse: { (house, completion) in
                remote.uploadHouse(house, completion: completion)
            }, checkForDuplicates: { (name, completion) in
                remote.checkForDuplicates(name: name, completion: completion)
            }
        )
    }
}
