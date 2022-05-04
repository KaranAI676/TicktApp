//
//  TransactionHistoryBuilder + TableView.swift
//  Tickt
//
//  Created by S H U B H A M on 20/07/21.
//

import Foundation

extension TransactionHistoryBuilder: TableDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayOfModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfModel[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: TransactionTableCell.self)
        cell.topConstraint.constant = indexPath.row == 0 ? 10 : 24
        cell.transationModel = arrayOfModel[indexPath.section].rows[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goToMyRevenueVC(model: arrayOfModel[indexPath.section].rows[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueHeaderFooter(with: TitleHeaderTableView.self)
        header.headerLabel.text = arrayOfModel[section].section
        header.headerLabel.textColor = AppColors.themeGrey
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
}
