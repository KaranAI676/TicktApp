//
//  ActiveJobsVM.swift
//  Tickt
//
//  Created by S H U B H A M on 06/05/21.
//

import Foundation
import SwiftyJSON

protocol JobDashboardVMDelegate: AnyObject {
    func failure(message: String)
    func successPastJobsTradie()
    func successActiveTradie()
    func successPastJobsBuilder()
    func successOpenBuilder()
    func successAppliedTradie()
    func successActiveBuilder()
    func success(model: RepublishJobResult, jobId: String, status: String, canOpenRepublish: Bool)
}

extension JobDashboardVMDelegate {
    
    func failure(message: String) {}
    func successPastJobsTradie() {}
    func successActiveTradie() {}
    func successPastJobsBuilder() {}
    func successOpenBuilder() {}
    func successAppliedTradie() {}
    func successActiveBuilder() {}
    func success(model: RepublishJobResult, jobId: String, status: String, canOpenRepublish: Bool) {}
}

class JobDashboardVM: BaseVM {
    
    enum JobStatus: String {
        
        case open
        case past
        case active
        case applied
        case pastTradie
        case activeTradie
        
        var methodName: String {
            switch self {
            case .active:
                return EndPoint.activeJobsBuilder.path
            case .open:
                return EndPoint.openJobsBuilder.path
            case .past:
                return EndPoint.pastJobsBuilder.path
            case .applied:
                return EndPoint.appliedJobsTradie.path
            case .pastTradie:
                return EndPoint.pastJobsTradie.path
            case .activeTradie:
                return EndPoint.activeJobsTradie.path
            }
        }
    }
    
    var pageNo = 1
    var isHittingApi: Bool = false
    var nextHit: Bool = false
    var tableViewOutlet = UITableView()
    var hitPagination: (() -> Void)? = nil
    ///
    var activeBuilderModel: ActiveJobModel?
    var openBuilderModel: OpenJobModel?
    var pastJobBuilderModel: PastJobModel?
    ///
    var activeTradieModel: ActiveModel?
    var appliedJobTradie: AppliedModel?
    var pastJobTradieModel: PastModel?
    weak var delegate: JobDashboardVMDelegate? = nil
    
    func getJobs(status: JobStatus, showLoader: Bool = true, isPullToRefresh: Bool = false) {    
        self.setup(type: .willHit, shouldShowLoader: !(showLoader || isPullToRefresh), pullToRefresh: isPullToRefresh)
        ApiManager.request(methodName: status.methodName + "?page=\(pageNo)", parameters: nil, methodType: .get, showLoader: showLoader) { [weak self] result in
            guard let self = self else { return }
            self.isHittingApi = false
            switch result {
            case .success(let data):
                if status == .applied {
                    TicketMoengage.shared.postEvent(eventType: .appliedForAJob(timestamp: ""))
                }
                self.parsedTheData(status: status, data: data, showLoader: showLoader, pullToRefresh: isPullToRefresh)
            case .failure(let error):
                self.setup(type: .failure, shouldShowLoader: !(showLoader || isPullToRefresh), pullToRefresh: isPullToRefresh, error: error?.localizedDescription ?? "")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func getRepublishJobDetails(jobId: String, status: String, canOpenRepublish: Bool = false) {
        let endPoint: String = "?jobId=\(jobId)"
        ApiManager.request(methodName: EndPoint.jobRepublishJob.path + endPoint, parameters: nil, methodType: .get) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                let serverResponse: RepublishJobModel = RepublishJobModel(JSON(data))
                if serverResponse.statusCode == StatusCode.success {
                    self.delegate?.success(model: serverResponse.result, jobId: jobId, status: status, canOpenRepublish: canOpenRepublish)
                } else {
                    CommonFunctions.showToastWithMessage("Something went wrong.")
                }
            case .failure(let error):
                self.delegate?.failure(message: error?.localizedDescription ?? "")
            default:
                Console.log("Do Nothing")
            }
        }
    }
}

extension JobDashboardVM {
    
    private func parsedTheData(status: JobStatus, data: (Any), showLoader: Bool, pullToRefresh: Bool) {
        
        switch status {
        case .active:
             let serverResponse: ActiveJobModel = ActiveJobModel(JSON(data))
                if serverResponse.statusCode == StatusCode.success {
                    parseData(showLoader: showLoader, pullToRefresh: pullToRefresh, model: serverResponse)
                } else {
                    self.setup(type: .failure, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh, error: "Something went wrong.")
                }
        case .open:
            let serverResponse: OpenJobModel = OpenJobModel(JSON(data))
            if serverResponse.statusCode == StatusCode.success {
                parseData(showLoader: showLoader, pullToRefresh: pullToRefresh, model: serverResponse)
            } else {
                self.setup(type: .failure, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh, error: "Something went wrong.")
            }
        case .past:
            let serverResponse: PastJobModel = PastJobModel(JSON(data))
            if serverResponse.statusCode == StatusCode.success {
                parseData(showLoader: showLoader, pullToRefresh: pullToRefresh, model: serverResponse)
            } else {
                self.setup(type: .failure, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh, error: "Something went wrong.")
            }
        case .applied:
            let serverResponse: AppliedModel = AppliedModel(JSON(data))
            if serverResponse.statusCode == StatusCode.success {
                parseData(showLoader: showLoader, pullToRefresh: pullToRefresh, model: serverResponse)
            } else {
                self.setup(type: .failure, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh, error: "Something went wrong.")
            }
        case .pastTradie:
            let serverResponse: PastModel = PastModel(JSON(data))
            if serverResponse.statusCode == StatusCode.success {
                parseData(showLoader: showLoader, pullToRefresh: pullToRefresh, model: serverResponse)
            } else {
                self.setup(type: .failure, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh, error: "Something went wrong.")
            }
        case .activeTradie:
            let serverResponse: ActiveModel = ActiveModel(JSON(data))
            if serverResponse.statusCode == StatusCode.success {
                parseData(showLoader: showLoader, pullToRefresh: pullToRefresh, model: serverResponse)
            } else {
                self.setup(type: .failure, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh, error: "Something went wrong.")
            }
        }
    }
}

extension JobDashboardVM {
    
    private func parseData(showLoader: Bool, pullToRefresh: Bool, model: Any) {
        if pullToRefresh || self.pageNo == 1 {
            self.activeBuilderModel = nil
            self.openBuilderModel = nil
            self.pastJobBuilderModel = nil
            self.activeTradieModel = nil
            self.appliedJobTradie = nil
            self.pastJobTradieModel = nil
        }
        
        if let model = model as? ActiveJobModel {
            if self.activeBuilderModel == nil {
                self.activeBuilderModel = model
            }else {
                self.activeBuilderModel?.result.needApprovalCount = model.result.needApprovalCount
                self.activeBuilderModel?.result.newApplicantsCount = model.result.newApplicantsCount
                self.activeBuilderModel?.result.active?.append(contentsOf: model.result.active ?? [])
            }
            nextHit = !(model.result.active?.isEmpty ?? true)
            pageNo += 1
            setup(type: .success, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh)
            delegate?.successActiveBuilder()
        }
        
        if let model = model as? OpenJobModel {
            if self.openBuilderModel == nil {
                self.openBuilderModel = model
            }else {
                self.openBuilderModel?.result.needApprovalCount = model.result.needApprovalCount
                self.openBuilderModel?.result.newApplicantsCount = model.result.newApplicantsCount
                self.openBuilderModel?.result.open?.append(contentsOf: model.result.open ?? [])
            }
            nextHit = !(model.result.open?.isEmpty ?? true)
            pageNo += 1
            setup(type: .success, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh)
            delegate?.successOpenBuilder()
        }
        
        if let model = model as? PastJobModel {
            if self.pastJobBuilderModel == nil {
                self.pastJobBuilderModel = model
            }else {
                self.pastJobBuilderModel?.result.needApprovalCount = model.result.needApprovalCount
                self.pastJobBuilderModel?.result.newApplicantsCount = model.result.newApplicantsCount
                self.pastJobBuilderModel?.result.past?.append(contentsOf: model.result.past ?? [])
            }
            nextHit = !(model.result.past?.isEmpty ?? true)
            pageNo += 1
            setup(type: .success, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh)
            delegate?.successPastJobsBuilder()
        }
        
        
        if let model = model as? ActiveModel {
            if self.activeTradieModel == nil {
                self.activeTradieModel = model
            }else {
                self.activeTradieModel?.result.milestonesCount = model.result.milestonesCount
                self.activeTradieModel?.result.newJobsCount = model.result.newJobsCount
                self.activeTradieModel?.result.active.append(contentsOf: model.result.active)
            }
            nextHit = !(model.result.active.isEmpty)
            pageNo += 1
            setup(type: .success, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh)
            delegate?.successActiveTradie()
        }
        
        if let model = model as? AppliedModel {
            if self.appliedJobTradie == nil {
                self.appliedJobTradie = model
            }else {
                self.appliedJobTradie?.result.milestonesCount = model.result.milestonesCount
                self.appliedJobTradie?.result.newJobsCount = model.result.newJobsCount
                self.appliedJobTradie?.result.applied.append(contentsOf: model.result.applied)
            }
            nextHit = !(model.result.applied.isEmpty)
            pageNo += 1
            setup(type: .success, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh)
            delegate?.successAppliedTradie()
        }
        
        if let model = model as? PastModel {
            if self.pastJobTradieModel == nil {
                self.pastJobTradieModel = model
            }else {
                self.pastJobTradieModel?.result.milestonesCount = model.result.milestonesCount
                self.pastJobTradieModel?.result.newJobsCount = model.result.newJobsCount
                self.pastJobTradieModel?.result.completed.append(contentsOf: model.result.completed)
            }
            nextHit = !(model.result.completed.isEmpty)
            pageNo += 1
            setup(type: .success, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh)
            delegate?.successPastJobsTradie()
        }
    }
    
    private func setup(type: ResponseType, shouldShowLoader: Bool, pullToRefresh: Bool, error: String? = nil) {
        switch type {
        case .willHit:
            isHittingApi = true
            if pullToRefresh {
                self.pageNo = 1
            }
            
            if shouldShowLoader {
                tableViewOutlet.showBottomLoader(delegate: self)
            }
        case .success:
            tableViewOutlet.hideBottomLoader()
        case .failure:
            if shouldShowLoader {
                tableViewOutlet.showBottomLoader(delegate: self, isNetworkConnected: false)
            } else {
                tableViewOutlet.hideBottomLoader()
            }
            self.delegate?.failure(message: error ?? "")
        }
    }
    
    func hitPagination(index: Int, type: JobDashboardVM.JobStatus) {
        var totalDataCount = 0
        switch type {
        case .past:
            totalDataCount = pastJobBuilderModel?.result.past?.count ?? 0
        case .pastTradie:
            totalDataCount = pastJobTradieModel?.result.completed.count ?? 0
        case .active:
            totalDataCount = activeBuilderModel?.result.active?.count ?? 0
        case .activeTradie:
            totalDataCount = activeTradieModel?.result.active.count ?? 0
        case .open:
            totalDataCount = openBuilderModel?.result.open?.count ?? 0
        case .applied:
            totalDataCount = appliedJobTradie?.result.applied.count ?? 0
        }
        
        if nextHit && index == totalDataCount - 1 && !isHittingApi && totalDataCount > 8 {
            if CommonFunctions.isConnectedToNetwork() {
                self.hitPagination?()
            } else {
                setup(type: .willHit, shouldShowLoader: true, pullToRefresh: false)
            }
        }
    }
}

//MARK:- RetryButtonDelegate
//==========================
extension JobDashboardVM: RetryButtonDelegate {
    
    func didPressRetryButton() {
        if CommonFunctions.isConnectedToNetwork(isShowToast: true) {
            tableViewOutlet.hideBottomLoader()
            self.hitPagination?()
        }
    }
}
