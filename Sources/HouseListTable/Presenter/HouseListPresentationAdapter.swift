//
//  HouseListPresentationAdapter.swift
//  
//
//  Created by Nikolai Nobadi on 2/7/22.
//

import Combine
import NnHousehold

public final class HouseListPresentationAdapter {
    
    // MARK: - Properties
    private let title: String
    private let responder: HouseListCellResponder
    private let publisher: HouseListCellInfoPublisher
    

    // MARK: - Init
    public init(title: String,
                publisher: HouseListCellInfoPublisher,
                responder: HouseListCellResponder) {
        
        self.title = title
        self.responder = responder
        self.publisher = publisher
    }
}


// MARK: - Presenter
extension HouseListPresentationAdapter: HouseListPresenter {
    
    public var sectionTitle: String { title }
    public var cellModelPublisher: AnyPublisher<[HouseListCellViewModel], Never> {
        
        publisher.viewModelPublisher
            .compactMap { [weak self] in self?.makeViewModels($0) }
            .eraseToAnyPublisher()
    }
}


// MARK: - Private Methods
private extension HouseListPresentationAdapter {
    
    func makeViewModels(_ list: [HouseListCellInfo]) -> [HouseListCellViewModel] {
        
        list.map {
            HouseListCellViewModel(info: $0, responder: responder)
        }
    }
}


// MARK: - Dependencies
public typealias HouseListCellResponder = (
    delete: ((String) -> Void)?,
    buttonAction: (String) -> Void
)

public protocol HouseListCellInfoPublisher {
    var viewModelPublisher: AnyPublisher<[HouseListCellInfo], Never> { get }
}
