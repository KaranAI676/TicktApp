//
//  SettingsBuilderVC + TableView.swift
//  Tickt
//
//  Created by S H U B H A M on 12/07/21.
//

import Foundation

extension SettingsBuilderVC: TableDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if kUserDefaults.isTradie() {
            return tradieSectionArray.count
        }else{
            return sectionArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1//cellArray.count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /*     switch cellArray[indexPath.row] {
        case .subText:
            let cell = tableView.dequeueCell(with: TitleLabelForNamesTableCell.self)
            cell.titleNameLabel.text = sectionArray[indexPath.section].sectionSubText
            cell.titleNameLabel.font = UIFont.systemFont(ofSize: 15)
            cell.titleNameLabel.textColor = #colorLiteral(red: 0.4549019608, green: 0.5019607843, blue: 0.5725490196, alpha: 1)
            return cell
        default:
            let cell = tableView.dequeueCell(with: CommonTitleWithSwitchTableCell.self)
            cell.tableView = tableView
            cell.titleNameLabel.text = cellArray[indexPath.row].rawValue
            ///
            let model = sectionArray[indexPath.section] == .reminders ? self.model?.reminders : self.model?.messages
            switch cellArray[indexPath.row] {
            case .email:
                cell.switchButton.isOn = model?.email ?? true
            case .push:
                cell.switchButton.isOn = model?.pushNotification ?? true
            case .smsMessages:
                cell.switchButton.isOn = model?.smsMessages ?? true
            default:
                break
            }
            ///
            cell.switchClosure = { [weak self] (index, state) in
                guard let self = self else { return }
                self.viewModel.updateSettingData(index: index, sectionArray: self.sectionArray[index.section], cellArray: self.cellArray[index.row], state: state)
            }
            return cell
        } */
        let header = tableView.dequeueCell(with: CommonTitleWithSwitchTableCell.self)
        if kUserDefaults.isTradie() {
            header.titleNameLabel.text = tradieSectionArray[indexPath.section].rawValue
            header.tableView = tableView
            if let dataModel = model{
                if dataModel.pushNotificationCategory.contains(tradieSectionArray[indexPath.section].keyIndex){
                    header.switchButton.isOn = true
                }else{
                    header.switchButton.isOn = false
                }
                header.switchClosure = { [weak self] (index, state) in
                    guard let self = self else { return }
                    var selectedArray = [Int]()
                    selectedArray.removeAll()
                    selectedArray = self.selectedPushArray
                    if selectedArray.contains(self.sectionArray[indexPath.section].keyIndex){
                        selectedArray.remove(object: self.tradieSectionArray[indexPath.section].keyIndex)
                    }else{
                        selectedArray.append(self.tradieSectionArray[indexPath.section].keyIndex)
                    }
                    self.viewModel.updateSettingData(index: index, selectedIndex: selectedArray,oldIndex: dataModel.pushNotificationCategory, state: state)
                }
            }
        }else{
            header.titleNameLabel.text = sectionArray[indexPath.section].rawValue
            header.tableView = tableView
            if let dataModel = model{
                if dataModel.pushNotificationCategory.contains(sectionArray[indexPath.section].keyIndex){
                    header.switchButton.isOn = true
                }else{
                    header.switchButton.isOn = false
                }
                header.switchClosure = { [weak self] (index, state) in
                    guard let self = self else { return }
                    var selectedArray = [Int]()
                    selectedArray.removeAll()
                    selectedArray = self.selectedPushArray
                    if selectedArray.contains(self.sectionArray[indexPath.section].keyIndex){
                        selectedArray.remove(object: self.sectionArray[indexPath.section].keyIndex)
                    }else{
                        selectedArray.append(self.sectionArray[indexPath.section].keyIndex)
                    }
                    self.viewModel.updateSettingData(index: index, selectedIndex: selectedArray,oldIndex: dataModel.pushNotificationCategory, state: state)
                }
            }
        }
        header.titleNameLabel.font = UIFont.kAppDefaultFontBold(ofSize: 17)
        header.titleNameLabel.textColor = AppColors.themeBlue
        return header
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueHeaderFooter(with: TitleHeaderTableView.self)
        header.headerLabel.font = UIFont.kAppDefaultFontBold(ofSize: 17)
        header.headerLabel.textColor = AppColors.themeBlue
        header.headerLabel.text = ""//sectionArray[section].rawValue
        header.topConstraint?.isActive = false
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        } else {
            return 20//sectionArray[section].sectionHeight
        }
    }
}
