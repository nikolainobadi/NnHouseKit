//
//  HouseDetailMembersDataSource.swift
//  
//
//  Created by Nikolai Nobadi on 2/3/22.
//

import UIKit
import HouseDetailLogic
import NnUIViewKitPackage

let CELL_ID = "Cell_ID"

final class HouseDetailMembersDataSource: UITableViewDiffableDataSource<TableSection, HouseMemberCellViewModel> {
    
    // MARK: - Properties
    typealias Snapshot = NSDiffableDataSourceSnapshot<TableSection, HouseMemberCellViewModel>
    
    
    // MARK: - Init
    init(_ table: UITableView) {
        super.init(tableView: table) { (table, indexPath, member) -> HouseMemberCell? in
            
            let cell = table.dequeueReusableCell(withIdentifier: CELL_ID,
                                                 for: indexPath) as? HouseMemberCell
            cell?.configure(member)
            
            return cell
        }
    }
    
    
    // MARK: - Update
    func update(_ members: [HouseMemberCellViewModel]) {
        var snapshot = Snapshot()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(members)
        
        apply(snapshot)
    }
    
    
    // MARK: - DataSource Methods
    override func tableView(_ tableView: UITableView,
                            titleForHeaderInSection section: Int) -> String? {
        "Household Members"
    }
    
    override func tableView(_ tableView: UITableView,
                            canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            itemIdentifier(for: indexPath)?.deleteMember()
        }
    }
}


// MARK: - Delegate Methods
extension HouseDetailMembersDataSource: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        tableView.getSize(xs: 65, xl: 75, xxl: 80)
    }
}


