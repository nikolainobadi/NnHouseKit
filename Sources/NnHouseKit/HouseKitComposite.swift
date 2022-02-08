//
//  HouseKitComposite.swift
//  
//
//  Created by Nikolai Nobadi on 2/4/22.
//

import UIKit
import NnHousehold
import HouseDetailUI
import HouseListTable
import HouseDetailLogic

public final class HouseKitComposite {
    private init() { }
    
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
