//
//  HouseKitComposite.swift
//  
//
//  Created by Nikolai Nobadi on 2/4/22.
//

import UIKit
import NnHousehold
import NnHouseDetail
import NnHouseDetail_Logic_Presentation

public final class HouseKitComposite {
    
    public func makeHouseDetailVC(isCreator: Bool,
                                  houseName: String,
                                  alerts: HouseDetailAlerts,
                                  remote: HouseholdUploader,
                                  houseCache: HouseholdCache,
                                  houseMemberPublisher: HouseholdMemberPublisher,
                                  config: HouseDetailViewConfig,
                                  switchHouse: @escaping () -> Void) -> UIViewController {
        
        let manager = HouseDetailManager(isCreator: isCreator,
                                         alerts: alerts,
                                         remote: remote,
                                         houseCache: houseCache)
        
        let uiResponder = makeHouseDetailUIResponder(manager,
                                                     switchHouse: switchHouse)
    
        let rootView = HouseDetailRootView(isCreator: isCreator,
                                           houseName: houseName,
                                           config: config,
                                           responder: uiResponder)
        
        let vmResponder = makeHouseMemberViewModelResponder(manager)
        let presenter = HouseDetailPresentationAdapter(
            publisher: houseMemberPublisher,
            viewModelResponder: vmResponder)
        
        return HouseDetailVC(rootView: rootView,
                             presenter: presenter)
    }
}


// MARK: - Private Methods
private extension HouseKitComposite {
    
    func makeHouseDetailUIResponder(_ manager: HouseDetailManager,
                                    switchHouse: @escaping () -> Void) -> HouseDetailUIResponder {
        
        return (editHouse: manager.editHouse,
                switchHouse: switchHouse,
                showPassword: manager.showPassword)
    }
    
    func makeHouseMemberViewModelResponder(_ manager: HouseDetailManager) -> HouseMemberViewModelResponder {
        
        return (deleteMember: { member in
            manager.deleteMember(member)
        },toggleAdminStatus: { member in
            manager.toggleAdminStatus(of: member)
        })
    }
}
