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
    private let publisher: HouseholdMemberPublisher
    private let viewModelResponder: HouseMemberViewModelResponder
    
    @Published private var viewModels = [HouseMemberViewModel]()
    
    
    // MARK: - Init
    public init(publisher: HouseholdMemberPublisher,
                viewModelResponder: HouseMemberViewModelResponder) {
        
        self.publisher = publisher
        self.viewModelResponder = viewModelResponder
    }
}


// MARK: - Presenter
extension HouseDetailPresentationAdapter: HouseDetailPresenter {
    
    public var viewModelPublisher: AnyPublisher<[HouseMemberViewModel], Never> {
        publisher.memberPublisher
            .compactMap { [weak self] in self?.makeViewModels($0) }
            .eraseToAnyPublisher()
    }
}


// MARK: - Private Methods
private extension HouseDetailPresentationAdapter {
    
    func makeViewModels(_ list: [HouseholdMember]) -> [HouseMemberViewModel] {
        list.map {
            HouseMemberViewModel($0, responder: viewModelResponder)
        }
    }
}


// MARK: - Dependencies
public protocol HouseDetailPresenter {
    var viewModelPublisher: AnyPublisher<[HouseMemberViewModel], Never> { get }
}

public protocol HouseholdMemberPublisher {
    var memberPublisher: AnyPublisher<[HouseholdMember], Never> { get }
}
