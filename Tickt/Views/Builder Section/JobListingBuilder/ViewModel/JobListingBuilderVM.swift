//
//  JobListingBuilderVM.swift
//  Tickt
//
//  Created by S H U B H A M on 16/06/21.
//

import Foundation

protocol JobListingBuilderVMDelegate: AnyObject {
    
    func successCancelInvite(index: Int)
    func successInvite(invitationModel: InvitationResultModel)
    func successGetJobs(model: JobListingBuilderModel)
    func failure(message: String)
}

class JobListingBuilderVM: BaseVM {
    
    weak var delegate: JobListingBuilderVMDelegate? = nil
    
    func getJobList(pageNo: Int = 1, tradieId: String = "", type: JobListingBuilderVC.ScreenType, pullToRefresh: Bool = false) {
        
        var endPoints = "?" + ApiKeys.page + "=" + "\(pageNo)"
        if type != .forInvite { endPoints += "&" + ApiKeys.tradieId + "=" + tradieId }
        
        ApiManager.request(methodName: getMethodName(type) + endPoints, parameters: nil, methodType: .get, showLoader: !pullToRefresh) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                if let serverResponse: JobListingBuilderModel = self.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        self.delegate?.successGetJobs(model: serverResponse)
                    } else {
                        CommonFunctions.showToastWithMessage("Something went wrong.")
                    }
                }
            case .failure(let error):
                self.delegate?.failure(message: error?.localizedDescription ?? "Unknown")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func inviteTradie(tradieId: String, jobId: String, pageNo: Int = 1) {
        
        var endPoint = "?" + ApiKeys.tradieId + "=" + tradieId
        endPoint += "&" + ApiKeys.jobId + "=" + jobId
        
        ApiManager.request(methodName: EndPoint.jobBuilderInviteForJob.path + endPoint, parameters: nil, methodType: .put) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                if let serverResponse: InvitationModel = self.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        self.delegate?.successInvite(invitationModel: serverResponse.result)
                    } else {
                        CommonFunctions.showToastWithMessage("Something went wrong.")
                    }
                }
            case .failure(let error):
                self.delegate?.failure(message: error?.localizedDescription ?? "Unknown")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func cancelInvite(tradieId: String, jobId: String, invitationId: String, index: Int) {
        
        var endPoint: String = "?" + ApiKeys.tradieId + "=" + tradieId
        endPoint += "&" + ApiKeys.jobId + "=" + jobId
        endPoint += "&" + ApiKeys.invitationId + "=" + invitationId
        
        ApiManager.request(methodName: EndPoint.jobBuilderCancelInviteForJob.path + endPoint, parameters: nil, methodType: .put) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.delegate?.successCancelInvite(index: index)
            case .failure(let error):
                self.delegate?.failure(message: error?.localizedDescription ?? "")
            default:
                Console.log("Do Nothing")
            }
        }
    }
}

extension JobListingBuilderVM {
    
    private func getMethodName(_ type: JobListingBuilderVC.ScreenType) -> String {
        switch type {
        case .forInvite:
            return EndPoint.jobBuilderChooseJob.path
        case .forCancelInvite:
            return EndPoint.homeInvitedJobIds.path
        case .forLeaveVouch:
            return EndPoint.jobBuilderVouchesJob.path
        }
    }
}
