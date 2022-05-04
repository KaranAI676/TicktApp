//
//  MyRevenueBuilderVC + TableView.swift
//  Tickt
//
//  Created by S H U B H A M on 21/07/21.
//

import Foundation

extension MyRevenueBuilderVC: TableDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.milestones.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: RevenueDetailTableCell.self)
        cell.model = model?.milestones[indexPath.row]
        return cell
    }
}
