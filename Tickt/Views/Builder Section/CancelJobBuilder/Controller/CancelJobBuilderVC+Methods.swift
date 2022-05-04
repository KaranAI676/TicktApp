//
//  CancelJobBuilderVC+Methods.swift
//  Tickt
//
//  Created by S H U B H A M on 02/06/21.
//

import Foundation

extension CancelJobBuilderVC {
    
    func initialSetup() {
        viewModel.delegate = self
        cancelJobModel.jobId = self.jobId
        cancelJobModel.jobName = self.jobName
        navTitleLabel.text = jobName
        sectionArray = [.reasons, .note]
        reasonsModel = CommonFunctions.getReasonsModel()
        setupTableView()
    }
    
    private func setupTableView() {
        tableViewOutlet.registerHeaderFooter(with: TitleHeaderTableView.self)
        tableViewOutlet.registerCell(with: CommonTextfieldTableCell.self)
        tableViewOutlet.registerCell(with: ReasonsTableViewCell.self)
        ///
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
    }
    
    func goToSuccessScreen() {
        let vc = AccountCreatedSuccessVC.instantiate(fromAppStoryboard: .registration)
        vc.screenType = .jobCancelled
        push(vc: vc)
    }
}

extension CancelJobBuilderVC {
    
    func validate() -> Bool {
        
        guard let reasonModel = self.reasonsModel else { return false }
        
        let selectedReason = reasonModel.first(where: { eachModel -> Bool in
            return eachModel.isSelected == true
        })
        self.cancelJobModel.reasonType = selectedReason?.reasonType
        
        
        if self.cancelJobModel.reasonType == nil {
            CommonFunctions.showToastWithMessage("Please select a reason")
            return false
        }
        
//        if self.cancelJobModel.note.isEmpty {
//            CommonFunctions.showToastWithMessage("Please enter a note")
//            return false
//        }
        
        return true
    }
}
