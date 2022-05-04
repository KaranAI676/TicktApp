//
//  LodgeDispute+Methods.swift
//  Tickt
//
//  Created by S H U B H A M on 12/06/21.
//

import Foundation

extension LodgeDisputeVC {
    
    func initialSetup() {
        viewModel.delegate = self
        lodgeDisputeModel.jobId = self.jobId
        lodgeDisputeModel.jobName = self.jobName
        navTitleLabel.text = jobName
        sectionArray = [.reasons, .detail, .images]
        reasonsModel = CommonFunctions.getDisputeReasonsModel()
        setupTableView()
    }
    
    private func setupTableView() {
        tableViewOutlet.registerHeaderFooter(with: TitleHeaderTableView.self)
        tableViewOutlet.registerCell(with: CommonTextfieldTableCell.self)
        tableViewOutlet.registerCell(with: UploadImageTableCell.self)
        tableViewOutlet.registerCell(with: CommonCollectionViewTableCell.self)
        tableViewOutlet.registerCell(with: ReasonsTableViewCell.self)
        ///
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
    }
    
    func goToSuccessScreen() {
        let vc = AccountCreatedSuccessVC.instantiate(fromAppStoryboard: .registration)
        if kUserDefaults.isTradie() {
            vc.screenType = .lodgeDisputedTradie
        } else {
            vc.screenType = .lodgeDisputedBuilder
        }
        push(vc: vc)
    }
    
     func goToCommonPopupVC() {
        let vc = CommonButtonPopUpVC.instantiate(fromAppStoryboard: .registration)
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        vc.isAnimated = true
        vc.buttonTypeArray = [.photo, .gallery]
        mainQueue { [weak self] in
            self?.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
}

extension LodgeDisputeVC {
    
    func validate() -> Bool {
        
        guard let reasonModel = reasonsModel else { return false }
        
        let selectedReason = reasonModel.first(where: { eachModel -> Bool in
            return eachModel.isSelected == true
        })
        lodgeDisputeModel.disputeReasonType = selectedReason?.reasonType
        
        if lodgeDisputeModel.disputeReasonType == nil {
            CommonFunctions.showToastWithMessage("Please select a reason")
            return false
        }
        
        if lodgeDisputeModel.jobId.isEmpty {
            return false
        }
            
        return true
    }
}

extension LodgeDisputeVC {
    
    func getSectionArray() -> [SectionArray] {
        var sectionArray: [SectionArray] = [.reasons, .detail]
        self.lodgeDisputeModel.images.isEmpty ? sectionArray.append(.uploadPlaceHolder) : sectionArray.append(.images)
        self.sectionArray = sectionArray
        return sectionArray
    }
}
