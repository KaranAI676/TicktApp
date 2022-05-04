//
//  LodgeDisputeVC+TableView.swift
//  Tickt
//
//  Created by S H U B H A M on 12/06/21.
//

import Foundation

extension LodgeDisputeVC: TableDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return getSectionArray().count
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
            cell.disputeModel = self.reasonsModel?[indexPath.row]
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
        case .detail:
            let cell = tableView.dequeueCell(with: CommonTextfieldTableCell.self)
            cell.commonTextFiled.placeholder = "It’s really bad work, because"
            cell.commonTextFiled.autocapitalizationType = .sentences
            cell.updateTextClosure = { [weak self] (text) in
                guard let self = self else { return }
                self.lodgeDisputeModel.detail = text
            }
            return cell
        case .images:
            let cell = tableView.dequeueCell(with: CommonCollectionViewTableCell.self)
            cell.photosModel = self.lodgeDisputeModel.images
            cell.maxMediaCanAllow = 6
            cell.imageTapped = { [weak self] (tappedType, index) in
                guard let self = self else { return }
                switch tappedType {
                case .imageTapped:
                    break
//                    CommonFunctions.showToastWithMessage("Preview")
                case .uploadImage:
                    self.goToCommonPopupVC()
                case .crossTapped:
                    self.lodgeDisputeModel.images.remove(at: index.row)
                    self.tableViewOutlet.reloadData()
                }
            }
            cell.layoutIfNeeded()
            return cell
        case .uploadPlaceHolder:
            let cell = tableView.dequeueCell(with: UploadImageTableCell.self)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sectionArray[indexPath.section] {
        case .uploadPlaceHolder:
            self.goToCommonPopupVC()
        default:
            break
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
