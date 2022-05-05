//
//  LoggedInUserProfileBuilderVC + TableView.swift
//  Tickt
//
//  Created by S H U B H A M on 27/06/21.
//

import Foundation

extension LoggedInUserProfileBuilderVC: TableDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sectionArray[section] {
        case .options:
            return cellArray.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch sectionArray[indexPath.section] {
        case .top:
            let cell = tableView.dequeueCell(with: ProfileTopViewTableCell.self)
            cell.model = model?.result
            cell.buttonClosure = { [weak self] type in
                guard let self = self else { return }
                switch type {
                case .viewProfile:
                    self.viewProfile(isEdit: false)
                case .completeProfile:
                    self.completeProfile()
                case .profilePreview:
                    (self.model?.result.userImage.isEmpty ?? true) ?
                        self.goToCommonPopupVC() :
                        self.goToPreviewImage(image: nil, url: self.model?.result.userImage)
                case .editProfile:
                    self.goToCommonPopupVC()
                }
            }
            return cell
        case .ratingBlock:
            let cell = tableView.dequeueCell(with: RatingProfileBlocksTableCell.self)
            cell.loggedinModel = model?.result
            return cell
        case .options:
            let cell = tableView.dequeueCell(with: ProfileOptionTableCell.self)
            let option = cellArray[indexPath.row]
            cell.imageBackView.isHidden = option.optionImage == nil
            cell.optionImageView.image = option.optionImage
            cell.optionNameLabel.text = option.rawValue
            cell.optionNameLabel.font = option.font
            cell.optionNameLabel.textColor = option.textColor
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if sectionArray[indexPath.section] == .options {
            optionTappedAction(option: cellArray[indexPath.row])
        }
    }
    
    func viewProfile(isEdit: Bool) {
        if kUserDefaults.isTradie() {
            if isEdit {
                let vc = EditableOptionBuilderVC.instantiate(fromAppStoryboard: .loggedInUserProfileBuilder)                
                push(vc: vc)
            } else {
                let vc = TradieProfilefromBuilderVC.instantiate(fromAppStoryboard: .tradieProfilefromBuilder)
                vc.tradieId = kUserDefaults.getUserId()
                push(vc: vc)
            }
        } else {
            let vc = TradieProfilefromBuilderVC.instantiate(fromAppStoryboard: .tradieProfilefromBuilder)
            vc.loggedInBuilder = true
            push(vc: vc)
        }
    }
    
    func completeProfile() {
            let vc = EditProfileDetailsBuilderVC.instantiate(fromAppStoryboard: .loggedInUserProfileBuilder)
            push(vc: vc)
        }
}

