//
//  File.swift
//  
//
//  Created by Nikolai Nobadi on 2/3/22.
//

import Combine
import NnHousehold

public final class HouseDetailPresentationAdapter {
    
    // MARK: - Properties
    private let config: HouseMemberCellConfig
    private let publisher: HouseMemberViewInfoPublisher
    private let responder: HouseMemberCellResponder


    // MARK: - Init
    public init(config: HouseMemberCellConfig,
                publisher: HouseMemberViewInfoPublisher,
                responder: HouseMemberCellResponder) {
        
        self.config = config
        self.publisher = publisher
        self.responder = responder
    }
}


// MARK: - Presenter
extension HouseDetailPresentationAdapter: HouseDetailPresenter {
    
    public var cellModelPublisher: AnyPublisher<[HouseMemberCellViewModel], Never> {
        publisher.viewModelPublisher
            .compactMap { [weak self] in self?.makeViewModels($0) }
            .eraseToAnyPublisher()
    }
}


// MARK: - Private Methods
private extension HouseDetailPresentationAdapter {
    
    func makeViewModels(_ list: [HouseMemberViewInfo]) -> [HouseMemberCellViewModel] {
        list.map {
            HouseMemberCellViewModel(info: $0,
                                     config: config,
                                     responder: responder)
        }
    }
}


// MARK: - Dependencies
public protocol HouseMemberViewInfoPublisher {
    var viewModelPublisher: AnyPublisher<[HouseMemberViewInfo], Never> { get }
}
