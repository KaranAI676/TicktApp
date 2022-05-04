//
//  CancelJob+TableView.swift
//  Tickt
//
//  Created by Vijay's Macbook on 22/06/21.
//

import Foundation

extension CancelJobVC: TableDelegate {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reasonsModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: ReasonsTableViewCell.self)
        cell.tableView = tableView
        cell.reasonsModel = self.reasonsModel?[indexPath.row]
        cell.updateModel = { [weak self] index, bool in
            guard let self = self else { return }
            for i in 0..<(self.reasonsModel?.count ?? 0) {
                self.reasonsModel?[i].isSelected = false
            }
            self.reasonsModel?[index.row].isSelected = bool
            tableView.reloadData()
        }
        cell.layoutIfNeeded()
        return cell
    }
}
