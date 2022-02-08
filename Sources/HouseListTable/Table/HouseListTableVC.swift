//
//  HouseListTableVC.swift
//  
//
//  Created by Nikolai Nobadi on 2/7/22.
//

import UIKit
import Combine
import NnUIViewKitPackage

public final class HouseListTableVC: NiblessViewController {
    
    // MARK: - Properties
    private let presenter: HouseListPresenter
    
    private var changes = Set<AnyCancellable>()
    private lazy var dataSource: HouseListDataSource = {
        HouseListDataSource(table, sectionTitle: presenter.sectionTitle)
    }()
    
    
    // MARK: - Views
    public lazy var table: UITableView = {
        let table = UITableView()
        
        table.separatorColor = .label
        table.backgroundColor = .clear
        
        return table
    }()
    
    
    
    // MARK: - Init
    public init(presenter: HouseListPresenter) {
        self.presenter = presenter
        super.init(hasTextFields: false)
    }
    
    
    // MARK: - Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupTable()
        startObservers()
    }
}


// MARK: - Private Methods
private extension HouseListTableVC {
    
    func setupView() {
        view.addSubview(table)
        table.fillSuperview()
    }
    
    func setupTable() {
        table.delegate = dataSource
        table.dataSource = dataSource
        table.register(HouseListCell.self, forCellReuseIdentifier: CELL_ID)
    }
    
    func startObservers() {
        guard changes.isEmpty else { return }
        
        presenter.cellModelPublisher
            .sink { [weak self] in self?.updateList($0) }
            .store(in: &changes)
    }
    
    func updateList(_ list: [HouseListCellViewModel]) {
        dataSource.update(list)
    }
}


// MARK: - Dependencies
public protocol HouseListPresenter {
    var sectionTitle: String { get }
    var cellModelPublisher: AnyPublisher<[HouseListCellViewModel], Never> { get }
}
