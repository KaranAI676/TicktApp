//
//  SearchingTransactionHistoryVC + TableView.swift
//  Tickt
//
//  Created by S H U B H A M on 20/07/21.
//

import Foundation

extension SearchingTransactionHistoryVC: TableDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayOfModel.isEmpty ? 1 : arrayOfModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfModel.isEmpty ? 1 : arrayOfModel[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if arrayOfModel.isEmpty {
            let cell = tableView.dequeueCell(with: NoDataFoundTableCell.self)
            return cell
        } else {
            let cell = tableView.dequeueCell(with: TransactionTableCell.self)
            cell.topConstraint.constant = indexPath.row == 0 ? 10 : 24
            cell.transationModel = arrayOfModel[indexPath.section].rows[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueHeaderFooter(with: TitleHeaderTableView.self)
        header.headerLabel.text = arrayOfModel.isEmpty ? "" : arrayOfModel[section].section
        header.headerLabel.font = UIFont.systemFont(ofSize: 14)
        header.headerLabel.textColor = AppColors.themeGrey
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !arrayOfModel.isEmpty {
            goToMyRevenueVC(model: arrayOfModel[indexPath.section].rows[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if arrayOfModel.isEmpty {
            return tableView.bounds.height
        }else {
            return UITableView.automaticDimension
        }
    }
}
