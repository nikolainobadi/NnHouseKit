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
    private let publisher: HouseMemberViewModelPublisher
//    private let viewModelResponder: HouseMemberViewModelResponder
//
//    @Published private var viewModels = [HouseMemberViewModel]()
//
//
//    // MARK: - Init
    public init(publisher: HouseMemberViewModelPublisher) {
        self.publisher = publisher
    }
//    public init(publisher: HouseholdMemberPublisher,
//                viewModelResponder: HouseMemberViewModelResponder) {
//
//        self.publisher = publisher
//        self.viewModelResponder = viewModelResponder
//    }
}


// MARK: - Presenter
extension HouseDetailPresentationAdapter {
    
//    public var viewModelPublisher: AnyPublisher<[HouseMemberViewModel], Never> {
//        publisher.memberPublisher
//            .compactMap { [weak self] in self?.makeViewModels($0) }
//            .eraseToAnyPublisher()
//    }
}


// MARK: - Private Methods
private extension HouseDetailPresentationAdapter {
    
//    func makeViewModels(_ list: [HouseholdMember]) -> [HouseMemberViewModel] {
//        list.map {
//            HouseMemberViewModel($0, responder: viewModelResponder)
//        }
//    }
}


// MARK: - Dependencies
public protocol HouseMemberViewModelPublisher {
    var viewModelPublisher: AnyPublisher<[HouseoldMemberViewModel], Never> { get }
}

public protocol HouseoldMemberViewModel {
    var member: HouseholdMember { get }
    var adminStatus: String { get }
    var showAdminButton: Bool { get }
}
