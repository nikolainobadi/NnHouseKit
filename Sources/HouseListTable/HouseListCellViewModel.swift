//
//  HouseListCellViewModel.swift
//  
//
//  Created by Nikolai Nobadi on 2/7/22.
//

import UIKit
import NnHousehold

public struct HouseListCellViewModel {
    
    // MARK: - Properties
    private let info: HouseListCellInfo
    private let responder: HouseListCellResponder
    
    
    // MARK: - Init
    public init(info: HouseListCellInfo, responder: HouseListCellResponder) {
        self.info = info
        self.responder = responder
    }
}


// MARK: - View Model
public extension HouseListCellViewModel {
    
    var name: String { info.name }
    var details: String { info.details }
    var detailsColor: UIColor? { info.detailsColor }
    var buttonText: String { info.buttonText }
    var buttonColor: UIColor? { info.buttonColor }
    var showButton: Bool { info.showButton }
    var canDelete: Bool { info.canDelete }
    
    func delete() {
        responder.delete(info.id)
    }
    
    func buttonAction() {
        responder.buttonAction(info.id)
    }
}


// MARK: - Hashable
extension HouseListCellViewModel: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(info.id)
    }
    
    public static func == (lhs: HouseListCellViewModel, rhs: HouseListCellViewModel) -> Bool {
        
        lhs.info.id == rhs.info.id
    }
}


// MARK: - Dependencies
public typealias HouseListCellResponder = (
    delete: (String) -> Void,
    buttonAction: (String) -> Void
)
