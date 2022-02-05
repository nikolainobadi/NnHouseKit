//
//  HouseKitComposite.swift
//  
//
//  Created by Nikolai Nobadi on 2/4/22.
//

import UIKit
import NnHousehold
import HouseDetailUI
import HouseDetailLogic

public final class HouseKitComposite {
    private init() { }
    
    public static func makeHouseDetailVC(isCreator: Bool,
                                         houseName: String,
                                         alerts: HouseDetailAlerts,
                                         remote: HouseholdUploader,
                                         houseCache: HouseholdCache,
                                         memberInfoPublisher: HouseMemberViewInfoPublisher,
                                         viewConfig: HouseDetailViewConfig,
                                         cellViewConfig: HouseMemberCellConfig,
                                         switchHouse: @escaping () -> Void) -> UIViewController {
        
        let manager = HouseDetailManager(isCreator: isCreator,
                                         alerts: alerts,
                                         remote: remote,
                                         houseCache: houseCache)
        
        let uiResponder = makeHouseDetailUIResponder(manager,
                                                     switchHouse: switchHouse)
    
        let rootView = HouseDetailRootView(houseName: houseName,
                                           config: viewConfig,
                                           responder: uiResponder)
        
        let presenter = HouseDetailPresentationAdapter(
            config: cellViewConfig,
            publisher: memberInfoPublisher,
            responder: makeHouseMemberCellResponder(manager))
        
        return HouseDetailVC(rootView: rootView, presenter: presenter)
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
    
    static func makeHouseMemberCellResponder(_ manager: HouseDetailManager) -> HouseMemberCellResponder {
        
        return (deleteMember: { id in
            manager.deleteMember(memberId: id)
        },toggleAdminStatus: { id in
            manager.toggleAdminStatus(memberId: id)
        })
    }
}
