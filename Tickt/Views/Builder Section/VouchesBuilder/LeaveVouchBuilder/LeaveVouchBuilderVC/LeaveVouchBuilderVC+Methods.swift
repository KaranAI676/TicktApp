//
//  LeaveVouchBuilderVC+Methods.swift
//  Tickt
//
//  Created by S H U B H A M on 20/06/21.
//

import Foundation

extension LeaveVouchBuilderVC {
    
    func initialSetup() {
        setupTableView()
        model.tradieId = tradieId
        if !tradieId.isEmpty {
            viewModel.getJobList(tradieId: tradieId)
        }
        viewModel.delegate = self
    }
    
    private func setupTableView() {
        tableViewOutlet.registerHeaderFooter(with: TitleHeaderTableView.self)
        tableViewOutlet.registerCell(with: CommonTextViewTableCell.self)
        tableViewOutlet.registerCell(with: UploadImageTableCell.self)
        tableViewOutlet.registerCell(with: CommonTextfieldTableCell.self)
        tableViewOutlet.registerCell(with: CommonCollectionViewTableCell.self)
        tableViewOutlet.registerCell(with: ReasonsTableViewCell.self)
        ///
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
    }
    
    func getSectionArray() -> [SectionArray] {
        var sectionArray: [SectionArray] = []
        
        sectionArray.append(.jobs)
        if let _ = model.recommendation {
            sectionArray.append(.images)
        }else {
            sectionArray.append(.uploadPlaceHolder)
        }
        sectionArray.append(.vouchText)
        self.sectionArray = sectionArray
        return sectionArray
    }
    
    func goToCommonPopupVC() {
        let vc = CommonButtonPopUpVC.instantiate(fromAppStoryboard: .registration)
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        vc.isAnimated = true
        vc.buttonTypeArray = [.document]
        mainQueue { [weak self] in
            self?.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    func previewDoc(_ url: String) {
        let vc = DocumentReaderVC.instantiate(fromAppStoryboard: .documentReader)
        vc.comingFromLocal = true
        vc.url = url
        push(vc: vc)
    }
    
    func goToChooseJobVC() {
        let vc = JobListingBuilderVC.instantiate(fromAppStoryboard: .jobListingBuilder)
        vc.tradieId = tradieId
        vc.screenType = .forLeaveVouch
        vc.selectedJobId = model.jobId
        vc.delegate = self
        push(vc: vc)
    }
    
    func validate() -> Bool {
        
        if model.jobId.isEmpty {
            CommonFunctions.showToastWithMessage("Please choose a job")
            return false
        }
        
        if model.recommendation.isNil {
            CommonFunctions.showToastWithMessage("Please upload document")
            return false
        }
        
        if model.vouchText.isEmpty {
            CommonFunctions.showToastWithMessage("Please enter the vouch description")
            return false
        }
        
        return true
    }
}

extension LeaveVouchBuilderVC: JobListingBuilderVCDelegate {

    func getJobData(jobData: JobListingBuilderResult) {
        model.jobId = jobData.jobId
        model.jobName = jobData.jobName
        tableViewOutlet.reloadData()
    }
}
