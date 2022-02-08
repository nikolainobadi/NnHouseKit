//
//  HouseKitComposite.swift
//  
//
//  Created by Nikolai Nobadi on 2/4/22.
//

// MARK: - Imports
import UIKit
import NnHousehold
import HouseListTable

import HouseDetailUI
import HouseDetailLogic

import HouseSelectUI
import HouseSelectLogic

public final class HouseKitComposite {
    private init() { }
    
    // MARK: HouseDetail
    public static func makeHouseDetailVC(isCreator: Bool,
                                         houseName: String,
                                         alerts: HouseDetailAlerts,
                                         remote: HouseholdUploader,
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
    public static func makeHouseSelectVC(selectType: HouseSelectType,
                                         config: HouseSelectViewConfig,
                                         policy: HouseSelectPolicy,
                                         alerts: HouseSelectAlerts,
                                         remote: HouseSelectRemoteAPI,
                                         factory: HouseholdFactory,
                                         showJoinHouse: @escaping () -> Void,
                                         showDeleteHouse: @escaping () -> Void,
                                         finished: @escaping () -> Void) -> UIViewController {
        
        let manager = HouseSelectManager(policy: policy,
                                         alerts: alerts,
                                         remote: remote,
                                         factory: factory,
                                         finished: finished,
                                         showDeleteHouse: showDeleteHouse)
        
        let viewModel = HouseSelectViewModel(selectType: selectType,
                                             createHouse: manager.createNewHouse,
                                             showJoinHouse: showJoinHouse)
        
        let rootView = HouseSelectRootView(config: config,
                                           viewModel: viewModel)
        
        return HouseSelectVC(rootView: rootView, finished: finished)
    }
}


// MARK: - Private Methods
private extension HouseKitComposite {
    
    static func makeHouseDetailUIResponder(_ manager: HouseDetailManager,
                                           switchHouse: @escaping () -> Void) -> HouseDetailUIResponder {
        return (editHouse: manager.editHouse,
                switchHouse: switchHouse,
                showPassword: manager.showPassword)
    }
}
