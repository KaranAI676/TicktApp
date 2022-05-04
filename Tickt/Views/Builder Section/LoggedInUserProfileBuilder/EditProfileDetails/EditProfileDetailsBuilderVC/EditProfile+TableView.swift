//
//  EditProfile+TableView.swift
//  Tickt
//
//  Created by Vijay's Macbook on 30/06/21.
//

import Foundation

extension EditProfileDetailsBuilderVC: TableDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sectionArray[section] == .qualificationDocument {
            return (model.qualificationDoc?.count ?? 0) + 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sectionArray[indexPath.section] {
        case .changePassword:
            let cell = tableView.dequeueCell(with: TitleLabelTableCell.self)
            cell.topConstraint.constant = 5
            cell.bottomConstraint.constant = 25
            cell.titleLabel.font = UIFont.kAppDefaultFontBold(ofSize: 14)
            cell.titleLabel.text = "Change password"
            cell.titleLabel.textColor = AppColors.backGroundBlue
            return cell
        case .qualificationDocument:
            if indexPath.row == (model.qualificationDoc?.count ?? 0) {
                let cell = tableView.dequeueCell(with: AddQualificationDocument.self)
                cell.addQualificationAction = { [weak self] in
                    self?.currentIndex = indexPath.row
                    self?.viewModel.getTradeList()
                }
                return cell
            } else {
                let cell = tableView.dequeueCell(with: DocumentCell.self)
                cell.documentNameLabel.text = model.qualificationDoc?[indexPath.row].docName
                cell.deleteButtonAction = { [weak self] in
                    self?.deleteQualification(sender: cell.deleteButton)
                }
                return cell
            }
        case .mobileNumber:
            let cell = tableView.dequeueCell(with: PhoneNumberTextfieldTableCell.self)
            cell.phoneNumberTextfield.delegate = self
            cell.topConstraint.constant = 2
            cell.phoneNumberTextfield.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
            cell.phoneNumberTextfield.placeholder = sectionArray[indexPath.section].placeHolder
            cell.phoneNumberTextfield.keyboardType = sectionArray[indexPath.section].keyBoardType
            cell.phoneNumberTextfield.textColor = #colorLiteral(red: 0.6, green: 0.6431372549, blue: 0.7137254902, alpha: 1)
            cell.countryCodeTextfield.textColor = #colorLiteral(red: 0.6, green: 0.6431372549, blue: 0.7137254902, alpha: 1)
            cell.phoneNumberTextfield.isUserInteractionEnabled = false
            cell.phoneNumberTextfield.text = self.model.mobileNumber
            cell.phoneNumberTextfield.text?.insert(separator: " ", every: 3)
            ///
            cell.updateTextClosure = { [weak self] text in
                guard let self = self else { return }
                self.model.mobileNumber = text.removeSpaces
            }
            return cell
        case .email:
            let cell = tableView.dequeueCell(with: CommonTextfieldTableCell.self)
            cell.topConstraint.constant = 2
            cell.commonTextFiled.placeholder = sectionArray[indexPath.section].placeHolder
            cell.commonTextFiled.keyboardType = sectionArray[indexPath.section].keyBoardType
            cell.changeButton.isHidden = kUserDefaults.isSocialLogin()
            cell.commonTextFiled.isUserInteractionEnabled = false
            cell.commonTextFiled.text = model.email
            ///
            cell.buttonClosure = { [weak self] in
                guard let self = self else { return }
                self.goToChangeEmailVC()
            }
            return cell
        default:
            let cell = tableView.dequeueCell(with: CommonTextfieldTableCell.self)
            cell.tableView = tableView
            cell.topConstraint.constant = 2
            cell.commonTextFiled.delegate = self
            cell.commonTextFiled.textColor = AppColors.themeBlue
            cell.changeButton.isHidden = true
            cell.commonTextFiled.isUserInteractionEnabled = true
            cell.commonTextFiled.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
            cell.commonTextFiled.autocapitalizationType = .words
            cell.commonTextFiled.placeholder = sectionArray[indexPath.section].placeHolder
            cell.commonTextFiled.keyboardType = sectionArray[indexPath.section].keyBoardType
            cell.commonTextFiled.autocapitalizationType = .none
            switch self.sectionArray[indexPath.section] {
            case .fullName:
                cell.commonTextFiled.text = model.fullName
            case .mobileNumber:
                cell.commonTextFiled.text = model.mobileNumber
                cell.commonTextFiled.text?.insert(separator: " ", every: 3)
            case .changePassword:
                break
            case .companyName:
                cell.commonTextFiled.text = model.companyName
                cell.commonTextFiled.autocapitalizationType = .words
            case .businessName:
                cell.commonTextFiled.text = model.businessName
                cell.commonTextFiled.autocapitalizationType = .words
            case .yourPosition:
                cell.commonTextFiled.text = model.position
            case .abn:
                cell.commonTextFiled.text = model.abn
                cell.commonTextFiled.text?.insert(separator: " ",from: 2, every: 3)
            default:
                return cell
            }
            cell.updateTextWithIndexClosure = { [weak self] text, index in
                guard let self = self else { return }
                switch self.sectionArray[index.section] {
                case .fullName:
                    self.model.fullName = text
                case .mobileNumber:
                    self.model.mobileNumber = text.removeSpaces
                case .email:
                    self.model.email = text.lowercased()
                case .changePassword:
                    break
                case .companyName:
                    self.model.companyName = text
                case .businessName:
                    self.model.businessName = text
                case .yourPosition:
                    self.model.position = text
                case .abn:
                    self.model.abn = text.removeSpaces
                default:
                    break
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sectionArray[indexPath.section] {
        case .changePassword:
            goToChangePasswordVC()
        case .qualificationDocument:
            previewDoc(model.qualificationDoc?[indexPath.row].url ?? "")
        default:
            break
        }
    }
    
    func previewDoc(_ url: String) {
        if url.isValidUrl(url) {
            let vc = DocumentReaderVC.instantiate(fromAppStoryboard: .documentReader)
            vc.comingFromLocal = false
            vc.url = url
            push(vc: vc)
        } else {
            CommonFunctions.showToastWithMessage("Error while loading...")
        }
    }

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueHeaderFooter(with: TitleHeaderTableView.self)
        header.headerLabel.font = UIFont.systemFont(ofSize: 15)
        header.headerLabel.textColor = AppColors.themeGrey
        header.headerLabel.text = sectionArray[section].rawValue
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionArray[section].titleSize
    }
    
    func deleteQualification(sender: UIButton) {
        if let indexPath = tableViewOutlet.indexPath(forItem: sender) {
            model.qualificationDoc?.remove(at: indexPath.row)
            tableViewOutlet.beginUpdates()
            tableViewOutlet.deleteRows(at: [indexPath], with: .left)
            tableViewOutlet.endUpdates()
        }
    }
}
