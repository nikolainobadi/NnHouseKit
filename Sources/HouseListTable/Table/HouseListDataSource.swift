//
//  File.swift
//
//
//  Created by Nikolai Nobadi on 2/7/22.
//

import UIKit
import HouseDetailLogic
import NnUIViewKitPackage

let CELL_ID = "Cell_ID"
enum TableSection { case main }

final class HouseListDataSource: UITableViewDiffableDataSource<TableSection, HouseListCellViewModel> {
    
    // MARK: - Properties
    private let sectionTitle: String
    typealias Snapshot = NSDiffableDataSourceSnapshot<TableSection, HouseListCellViewModel>
    
    
    // MARK: - Init
    init(_ table: UITableView, sectionTitle: String) {
        self.sectionTitle = sectionTitle
        super.init(tableView: table) { (table, indexPath, viewModel) -> HouseListCell? in
            
            let cell = table.dequeueReusableCell(withIdentifier: CELL_ID,
                                                 for: indexPath) as? HouseListCell
            cell?.configure(viewModel)
            
            return cell
        }
    }
    
    
    // MARK: - Update
    func update(_ list: [HouseListCellViewModel]) {
        var snapshot = Snapshot()

        snapshot.appendSections([.main])
        snapshot.appendItems(list)

        apply(snapshot)
    }
    
    
    // MARK: - DataSource Methods
    override func tableView(_ tableView: UITableView,
                            titleForHeaderInSection section: Int) -> String? {
        return sectionTitle
    }
    
    override func tableView(_ tableView: UITableView,
                            canEditRowAt indexPath: IndexPath) -> Bool {
        
        itemIdentifier(for: indexPath)?.canDelete ?? false
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            itemIdentifier(for: indexPath)?.delete()
        }
    }
}


// MARK: - Delegate Methods
extension HouseListDataSource: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        tableView.getSize(xs: 65, xl: 75, xxl: 80)
    }
}
