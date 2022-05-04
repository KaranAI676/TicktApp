//
//  CancelJobBuilderVC+TableView.swift
//  Tickt
//
//  Created by S H U B H A M on 02/06/21.
//

import Foundation

extension CancelJobBuilderVC: TableDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sectionArray[section] {
        case .reasons:
            return reasonsModel?.count ?? 0
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sectionArray[indexPath.section] {
        case .reasons:
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
        case .note:
            let cell = tableView.dequeueCell(with: CommonTextfieldTableCell.self)
            cell.commonTextFiled.placeholder = "Our schedule has changed..."
            cell.updateTextClosure = { [weak self] (text) in
                guard let self = self else { return }
                self.cancelJobModel.note = text
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueHeaderFooter(with: TitleHeaderTableView.self)
        header.headerLabel.text = sectionArray[section].title
        header.headerLabel.textColor = sectionArray[section].color
        header.headerLabel.font = sectionArray[section].font
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionArray[section].height
    }
}
