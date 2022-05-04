//
//  TradieProfilefromBuilderVC + Delegate.swift
//  Tickt
//
//  Created by S H U B H A M on 27/06/21.
//

import Foundation

extension TradieProfilefromBuilderVC: JobChatDelegate {
    func didJobSelected(jobDetail: JobListData) {
        openMessageDetail(jobDetail: jobDetail)
    }
}

extension TradieProfilefromBuilderVC: TradieProfilefromBuilderVMDelegate {
    
    func success(model: RepublishJobResult, jobId: String, status: String) {
        goToDetailVC(jobId, screenType: .pastJobsExpired, status: status, republishModel: model)
    }
    
    func getlogginBuilder(model: BuilderProfileModel) {
        loggedInBuilderModel = model        
        editButton.isHidden = false
        let photosArray = loggedInBuilderModel?.result.portfolio.map({ eachModel -> String in
            return eachModel.portfolioImage?.first ?? ""
        })
        self.photosArray = photosArray
        tableViewOutlet.reloadData {
            self.tableViewOutlet.reloadData()
        }
    }
    
    func successCancelInvite() {
        goToNextVC(status: .decline)
    }
        
    func successSavedTradie() {
        guard let model = self.tradieModel?.result else { return }
        self.tradieModel?.result.isSaved = !(model.isSaved ?? false)
        NotificationCenter.default.post(name: NotificationName.refreshHomeBuilder, object: nil, userInfo: [ApiKeys.tradieModel: getTradieObject(model: model), ApiKeys.isSaved: !(model.isSaved ?? false)])
        tableViewOutlet.reloadData()
    }
    
    func successAccpetDecline(status: AcceptDecline) {
        isOpenJob = status == .decline
        goToNextVC(status: status)
    }
    
    func success(model: TradieProfilefromBuilderModel) {
        tradieModel = model
        let photosArray = self.tradieModel?.result.portfolio.map({ eachModel -> String in
            return eachModel.portfolioImage.first ?? ""
        })
        if kUserDefaults.isTradie() {
            editButton.isHidden = false
        }
        self.photosArray = photosArray
        self.tableViewOutlet.reloadData {
            self.tableViewOutlet.reloadData()
        }
    }
        
    func failure(message: String) {
        CommonFunctions.showToastWithMessage(message)
    }
}

extension TradieProfilefromBuilderVC: JobListingBuilderVCDelegate {
    
    func getCancelInvitationUpdate(isInvited: Bool) {
        tradieModel?.result.isInvited = isInvited
        tradieModel?.result.invitationId = nil
        tableViewOutlet.reloadData()
    }
    
    func getInvitationId(invitationModel: InvitationResultModel) {
        if invitationModel.jobId == self.jobId {
            tradieModel?.result.invitationId = invitationModel.invitationId
            tradieModel?.result.isInvited = true
            tableViewOutlet.reloadData()
        }
    }
}

extension TradieProfilefromBuilderVC: LeaveVouchBuilderVCDelegate {
    
    func getNewlyAddedVouch(model: TradieProfileVouchesData) {
        tradieModel?.result.vouchesData.insert(model, at: 0)
        let updatedCount = (tradieModel?.result.voucherCount ?? 0) + 1
        tradieModel?.result.voucherCount = updatedCount
        tableViewOutlet.reloadData()
    }
}

extension TradieProfilefromBuilderVC: QuestionListingBuilderVCDelegate {
    
    func getDeletedReview(id: String) {
        let index = tradieModel?.result.reviewData.firstIndex(where: { eachModel -> Bool in
            return eachModel.reviewId == id
        })
        
        if let index = index {
            tradieModel?.result.reviewData.remove(at: index)
            tableViewOutlet.reloadData()
        }
    }
    
    func getEditReview(id: String, editReview: String, rating: Double) {
        let index = tradieModel?.result.reviewData.firstIndex(where: { eachModel -> Bool in
            return eachModel.reviewId == id
        })
        
        if let index = index {
            tradieModel?.result.reviewData[index].review = editReview
            tradieModel?.result.reviewData[index].ratings = rating
            tableViewOutlet.reloadData()
        }
    }
    
    func getEditReply(reviewId: String, model: ReviewListBuilderResultModel) {
//        let index = tradieModel?.result.reviewData.firstIndex(where: { eachModel -> Bool in
//            return eachModel.reviewId == reviewId
//        })
//
//        if let index = index {
//            tradieModel?.result.reviewData[index] = model.reviewData.replyData.replyId ?? ""
//            tableViewOutlet.reloadData()
//        }
    }
}
