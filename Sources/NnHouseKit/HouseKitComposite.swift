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
    
    // MARK: HouseFetch
    public typealias HouseFetchRemoteAPI = HouseholdLoadRemoteAPI & HouseholdMemberRemoteAPI
    
    public static func makeHouseholdLoader(
        houseId: String,
        store: HouseholdStore,
        policy: HouseholdLoadPolicy,
        remote: HouseFetchRemoteAPI,
        memberLoader: HouseholdMemberLoader,
        modifier: ConvertedHouseholdModifier,
        currentMemberList: [HouseholdMember]) -> HouseholdLoader {
            
            let memberLoader = makeMemberLoader(remote: remote,
                                            memberList: [])
        
            return HouseholdLoadManager(houseId: houseId,
                                        store: store,
                                        policy: policy,
                                        remote: remote,
                                        memberLoader: memberLoader,
                                        modifier: modifier)
    }
    
    
    // MARK: HouseDetail
    public static func makeHouseDetailVC(isCreator: Bool,
                                         houseName: String,
                                         alerts: HouseDetailAlerts,
                                         remote: HouseDetailRemoteAPI,
                                         houseCache: HouseholdCache,
                                         cellInfoPublisher: HouseListCellInfoPublisher,
                                         viewConfig: HouseDetailViewConfig,
                                         switchHouse: @escaping () -> Void) -> UIViewController {
        
        let manager = HouseDetailManager(isCreator: isCreator,
                                         alerts: alerts,
                                         remote: remote,
                                         houseCache: houseCache)
        
        let uiResponder = makeHouseDetailUIResponder(manager,
                                                     switchHouse: switchHouse)
        let presenter = HouseListPresentationAdapter(
            title: "Household Members",
            publisher: cellInfoPublisher,
            responder: (delete: manager.deleteMember(memberId:),
                        buttonAction: manager.toggleAdminStatus(memberId:)))
        
        let tableVC = HouseListTableVC(presenter: presenter)
    
        return HouseDetailVC(tableVC: tableVC,
                             houseName: houseName,
                             config: viewConfig,
                             responder: uiResponder)
    }
    
    
    // MARK: HouseSelect
    public static func makeHouseSelectVC(user: HouseholdUser,
                                         selectType: HouseholdSelectType,
                                         config: HouseSelectViewConfig,
                                         policy: HouseSelectPolicy,
                                         alerts: HouseSelectAlerts,
                                         remote: HouseSelectRemoteAPI,
                                         factory: HouseholdFactory,
                                         joinHouse: @escaping () -> Void,
                                         showDeleteHouse: @escaping () -> Void,
                                         reloadData: @escaping () -> Void) -> UIViewController {
        
        let manager = HouseSelectManager(user: user,
                                         policy: policy,
                                         alerts: alerts,
                                         remote: remote,
                                         factory: factory,
                                         finished: reloadData,
                                         showDeleteHouse: showDeleteHouse)
        
        let viewModel = HouseSelectViewModel(selectType: selectType,
                                             createHouse: manager.createNewHouse,
                                             joinHouse: joinHouse)
        
        let rootView = HouseSelectRootView(config: config,
                                           viewModel: viewModel)
        
        return HouseSelectVC(rootView: rootView)
    }
    
    
    // MARK: HouseSeearch
    public static func makeHouseSearchVC(config: SearchViewConfig,
                                        backgroundColor: UIColor?,
                                        alerts: HouseSearchAlerts,
                                        remote: HouseSearchRemoteAPI,
                                        cellInfoPublisher: HouseListCellInfoPublisher,
                                        showJoinHouse: @escaping (String) -> Void) -> UIViewController {
        
        let manager = HouseSearchManager(alerts: alerts,
                                         remote: remote)
        let searchView = HouseSearchSearchView(
            config: config,
            responder: (changeSearchParameter: manager.changeSearchParameter(_:),
                        searchForHouse: manager.searchForHouse(_:)))
        
        let presenter = HouseListPresentationAdapter(
            title: "",
            publisher: cellInfoPublisher,
            responder: (delete: nil, buttonAction: showJoinHouse))
        
        let tableVC = HouseListTableVC(presenter: presenter)
        
        return HouseSearchVC(searchView: searchView,
                             tableVC: tableVC,
                             backgroundColor: backgroundColor)
    }
    
    
    // MARK: JoinHouse
    public static func makeJoinHouseVC(user: HouseholdUser,
                                       houseToJoin: Household,
                                       alerts: JoinHouseAlerts,
                                       remote: HouseholdAndUserRemoteAPI,
                                       factory: HouseholdMemberFactory,
                                       finished: @escaping () -> Void) -> UIViewController {
        
        let manager = JoinHouseManager(user: user,
                                       houseToJoin: houseToJoin,
                                       alerts: alerts,
                                       remote: remote,
                                       factory: factory,
                                       finished: finished)
        
        let viewModel = JoinHouseViewModel(
            joinHouse: manager.joinHouse(password:))
        
        let rootView = JoinHouseRootView(presenter: viewModel)
        
        return JoinHouseVC(store: viewModel,
                           rootView: rootView,
                           fieldsToObserve: [rootView.passwordField])
    }
}


// MARK: - Private Methods
private extension HouseKitComposite {
    
    static func makeMemberLoader(remote: HouseholdMemberRemoteAPI,
                                 memberList: [HouseholdMember]) -> HouseholdMemberLoader {
        
        HouseholdMemberLoadManager(remote: remote,
                                   memberList: memberList)
    }
    
    static func makeHouseDetailUIResponder(_ manager: HouseDetailManager,
                                           switchHouse: @escaping () -> Void) -> HouseDetailUIResponder {
        return (editHouse: manager.editHouse,
                switchHouse: switchHouse,
                showPassword: manager.showPassword)
    }
}
