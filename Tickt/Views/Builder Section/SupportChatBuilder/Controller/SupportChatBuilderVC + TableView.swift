//
//  SupportChatBuilderVC + TableView.swift
//  Tickt
//
//  Created by S H U B H A M on 14/07/21.
//

import Foundation

extension SupportChatBuilderVC: TableDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionArray[section] == .message ? 1 : 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sectionArray[indexPath.section] {
        case .options:
            let cell = tableView.dequeueCell(with: ReasonsTableViewCell.self)
            cell.tableView = tableView
            cell.optionsModel = optionsModel?[indexPath.row]
            ///
            cell.updateModel = { [weak self] index, bool in
                guard let self = self else { return }
                for i in 0..<(self.optionsModel?.count ?? 0) {
                    self.optionsModel?[i].isSelected = false
                }
                self.optionsModel?[index.row].isSelected = bool
                tableView.reloadData()
            }
            cell.layoutIfNeeded()
            return cell
        case .message:
            let cell = tableView.dequeueCell(with: CommonTextfieldTableCell.self)
            cell.topConstraint.constant = 2
            cell.commonTextFiled.autocapitalizationType = .sentences
            cell.commonTextFiled.placeholder = "Please share details.."
            ///
            cell.updateTextClosure = { [weak self] (text) in
                guard let self = self else { return }
                self.model.message = text
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueHeaderFooter(with: TitleHeaderTableView.self)
        header.headerLabel.text = sectionArray[section].rawValue
        header.headerLabel.textColor = AppColors.themeGrey
        header.headerLabel.font = UIFont.systemFont(ofSize: 15)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionArray[section].height
    }
}
