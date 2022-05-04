//
//  LeaveVouchBuilderVC+TableView.swift
//  Tickt
//
//  Created by S H U B H A M on 20/06/21.
//

import Foundation

extension LeaveVouchBuilderVC: TableDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return getSectionArray().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sectionArray[section] {
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sectionArray[indexPath.section] {
        case .jobs:
            let cell = tableView.dequeueCell(with: CommonTextfieldTableCell.self)
            cell.commonTextFiled.placeholder = "Job Name"
            cell.commonTextFiled.text = model.jobName
            ///
            let button = UIButton()
            button.isUserInteractionEnabled = false
            let imageView = UIImageView()
            imageView.image = #imageLiteral(resourceName: "forwardArrow-1")
            cell.commonTextFiled.setViewToRightView(view: imageView, size: CGSize(width: 20, height: 20))
            cell.commonTextFiled.delegate = self
            return cell
        case .vouchText:
            let cell = tableView.dequeueCell(with: CommonTextViewTableCell.self)
            cell.tableView = tableView
            cell.textViewOutlet.text = model.vouchText
            cell.cellType = .addVouch
            cell.updateTextWithIndexClosure = { [weak self] (text, index) in
                guard let self = self else { return }
                self.model.vouchText = text
            }
            return cell
        case .images:
            let cell = tableView.dequeueCell(with: CommonCollectionViewTableCell.self)
            cell.photosModel = [self.model.recommendation?.image ?? UIImage()]
            cell.maxMediaCanAllow = 1
            cell.imageTapped = { [weak self] (tappedType, index) in
                guard let self = self else { return }
                switch tappedType {
                case .imageTapped:
                    if let url = self.model.recommendation?.finalUrl {
                        self.previewDoc(url)
                    }
                case .uploadImage:
                    self.goToCommonPopupVC()
                case .crossTapped:
                    self.model.recommendation = nil
                    self.tableViewOutlet.reloadData()
                }
            }
            cell.layoutIfNeeded()
            return cell
        case .uploadPlaceHolder:
            let cell = tableView.dequeueCell(with: UploadImageTableCell.self)
            cell.titleTextLabel.isHidden = true
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


extension LeaveVouchBuilderVC {
    
    func updateTableCell(indexPath: IndexPath) {
        if let listingView = Bundle.main.loadNibNamed("JobListingView", owner: self, options: nil)?.first as? JobListingView,
           let cell = tableViewOutlet.cellForRow(at: indexPath) as? CommonTextfieldTableCell {
            listingView.frame = view.frame
            view.addSubview(listingView)
            ///
            let buttonFrame = cell.commonTextFiled.frame
            let buttonRectInScreen = cell.commonTextFiled.convert(buttonFrame, to: tableViewOutlet.superview)
            let yCordinate = buttonRectInScreen.origin.y
            ///
            listingView.topConstraint.constant = yCordinate + cell.commonTextFiled.height + 10
            listingView.layoutIfNeeded()
            listingView.containerViewHeight = abs(listingView.topConstraint.constant - tableViewOutlet.frame.maxY)
            listingView.jobModel = jobModel
            ///
            listingView.jobDidSelectClosure = { [weak self] index in
                guard let self = self else { return }
                self.model.jobId = self.jobModel?[index.row].jobId ?? ""
                self.model.jobName = self.jobModel?[index.row].jobName ?? ""
                self.tableViewOutlet.reloadData()
            }
            listingView.dismissClosure = { [weak self] in
                guard let _ = self else { return }
//                self.dropIconImageView.transform = self.dropIconImageView.transform.rotated(by: CGFloat(Double.pi))
            }
            
            delay(time: 0.001) {
                listingView.containerView.popIn()
            }
        }
    }
}

extension LeaveVouchBuilderVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let index = textField.tableViewIndexPath(self.tableViewOutlet) else { return true }
        
        switch sectionArray[index.section] {
        case .jobs:
            goToChooseJobVC()
            return false
        default:
            return true
        }
    }
}
