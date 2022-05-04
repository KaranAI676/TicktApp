//
//  JobListVM.swift
//  Tickt
//
//  Created by Vijay's Macbook on 15/05/21.
//
import SwiftyJSON                                               

protocol JobListingDelegate: AnyObject {
    func failure(error: String)
    func didReplyDeleted(index: Int)
    func didReplyDeletedHeader(index: Int)
    func didGetNewJobs()
    func didGetAllReviews()
    func didGetMilestone()
    func success(model: RepublishJobResult, jobId: String, status: String)
}

class JobListingVM: BaseVM {
    
    var jobModel: NewJobModel?
    var reviewModel: AllReviewsModel?
    var milestoneModel: ApprovedMilestone?
    ///
    var pageNo = 1
    var isHittingApi: Bool = false
    var nextHit: Bool = false
    var tableViewOutlet = UITableView()
    var hitPaginationClosure: (()-> Void)?
    weak var delegate: JobListingDelegate?
    
    func getBuildersReviews(showLoader: Bool = true, isPullToRefresh: Bool, builderId: String) {
        setup(type: .willHit, shouldShowLoader: !(showLoader || isPullToRefresh), pullToRefresh: isPullToRefresh)
        ApiManager.request(methodName: EndPoint.getBuilderReviews.path + "?page=\(pageNo)&\(ApiKeys.builderId)=\(builderId)", parameters: nil, methodType: .get, showLoader: showLoader) { [weak self] result in
            self?.isHittingApi = false
            switch result {
            case .success(let data):
                if let serverResponse: AllReviewsModel = self?.handleSuccess(data: data) {
                    self?.parseData(showLoader: showLoader, pullToRefresh: isPullToRefresh, model: serverResponse)
                }
            case .failure(let error):
                self?.setup(type: .failure, shouldShowLoader: !(showLoader || isPullToRefresh), pullToRefresh: isPullToRefresh, error: error?.localizedDescription ?? "Unknown error")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func getBuildersJobs(showLoader: Bool = true, isPullToRefresh: Bool, builderId: String) {        
        self.setup(type: .willHit, shouldShowLoader: !(showLoader || isPullToRefresh), pullToRefresh: isPullToRefresh)
        ApiManager.request(methodName: EndPoint.getBuilderJobs.path + "?page=\(pageNo)&\(ApiKeys.builderId)=\(builderId)", parameters: nil, methodType: .get, showLoader: showLoader) { [weak self] result in
            self?.isHittingApi = false
            switch result {
            case .success(let data):
                let serverResponse: NewJobModel = NewJobModel(JSON(data))
                self?.parseData(showLoader: showLoader, pullToRefresh: isPullToRefresh, model: serverResponse)
            case .failure(let error):
                self?.setup(type: .failure, shouldShowLoader: !(showLoader || isPullToRefresh), pullToRefresh: isPullToRefresh, error: error?.localizedDescription ?? "Unknown error")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func getNewJobs(showLoader: Bool = true, isPullToRefresh: Bool) {
        
        self.setup(type: .willHit, shouldShowLoader: !(showLoader || isPullToRefresh), pullToRefresh: isPullToRefresh)
        ApiManager.request(methodName: EndPoint.newJobList.path + "?page=\(pageNo)", parameters: nil, methodType: .get, showLoader: showLoader) { [weak self] result in
            self?.isHittingApi = false
            switch result {
            case .success(let data):
                let serverResponse: NewJobModel = NewJobModel(JSON(data))
                self?.parseData(showLoader: showLoader, pullToRefresh: isPullToRefresh, model: serverResponse)
            case .failure(let error):
                self?.setup(type: .failure, shouldShowLoader: !(showLoader || isPullToRefresh), pullToRefresh: isPullToRefresh, error: error?.localizedDescription ?? "Unknown error")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func getSavedJobs(showLoader: Bool = true, isPullToRefresh: Bool) {
        self.setup(type: .willHit, shouldShowLoader: !(showLoader || isPullToRefresh), pullToRefresh: isPullToRefresh)
        ApiManager.request(methodName: EndPoint.savedJobs.path + "?page=\(pageNo)", parameters: nil, methodType: .get, showLoader: showLoader) { [weak self] result in
            self?.isHittingApi = false
            switch result {
            case .success(let data):
                let serverResponse: NewJobModel = NewJobModel(JSON(data))
                self?.parseData(showLoader: showLoader, pullToRefresh: isPullToRefresh, model: serverResponse)
            case .failure(let error):
                self?.setup(type: .failure, shouldShowLoader: !(showLoader || isPullToRefresh), pullToRefresh: isPullToRefresh, error: error?.localizedDescription ?? "Unknown error")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func getApprovedMilestones(showLoader: Bool = true, isPullToRefresh: Bool) {
        setup(type: .willHit, shouldShowLoader: !(showLoader || isPullToRefresh), pullToRefresh: isPullToRefresh)
        ApiManager.request(methodName: EndPoint.approvedMilestone.path + "?page=\(pageNo)", parameters: nil, methodType: .get, showLoader: showLoader) { [weak self] result in
            self?.isHittingApi = false
            switch result {
            case .success(let data):
                let serverResponse: ApprovedMilestone = ApprovedMilestone(JSON(data))
                self?.parseData(showLoader: showLoader, pullToRefresh: isPullToRefresh, model: serverResponse)
            case .failure(let error):
                self?.setup(type: .failure, shouldShowLoader: !(showLoader || isPullToRefresh), pullToRefresh: isPullToRefresh, error: error?.localizedDescription ?? "Unknown error")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func getLoggedInBuilderJobs(showLoader: Bool = true, isPullToRefresh: Bool = false) {
        self.setup(type: .willHit, shouldShowLoader: !(showLoader || isPullToRefresh), pullToRefresh: isPullToRefresh)
        ApiManager.request(methodName: EndPoint.profileBuilderGetAllJobs.path + "?page=\(pageNo)", parameters: nil, methodType: .get, showLoader: showLoader) { [weak self] result in
            self?.isHittingApi = false
            switch result {
            case .success(let data):
                let serverResponse: NewJobModel = NewJobModel(JSON(data))
                self?.parseData(showLoader: showLoader, pullToRefresh: isPullToRefresh, model: serverResponse)
            case .failure(let error):
                self?.setup(type: .failure, shouldShowLoader: !(showLoader || isPullToRefresh), pullToRefresh: isPullToRefresh, error: error?.localizedDescription ?? "Unknown error")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func getRepublishJobDetails(jobId: String, status: String) {
        let endPoint: String = "?jobId=\(jobId)"
        ApiManager.request(methodName: EndPoint.jobRepublishJob.path + endPoint, parameters: nil, methodType: .get) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                let serverResponse: RepublishJobModel = RepublishJobModel(JSON(data))
                if serverResponse.statusCode == StatusCode.success {
                    self.delegate?.success(model: serverResponse.result, jobId: jobId, status: status)
                } else {
                    CommonFunctions.showToastWithMessage("Something went wrong.")
                }
            case .failure(let error):
                self.delegate?.failure(error: error?.localizedDescription ?? "")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func deleteReply(reviewId: String, replyId: String, index: Int) {
        ApiManager.request(methodName: EndPoint.removeReviewReply.path + "\(ApiKeys.reviewId)=\(reviewId)&\(ApiKeys.replyId)=\(replyId)" , parameters: nil, methodType: .delete) { [weak self] result in
            switch result {
            case .success(let data):
                if let serverResponse: GenericResponse = self?.handleSuccess(data: data) {                    
                    if serverResponse.statusCode == StatusCode.success {
                        self?.delegate?.didReplyDeleted(index: index)
                    }
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func deleteReplyHeaderView(reviewId: String, index: Int) {
        ApiManager.request(methodName: EndPoint.removeReview.path , parameters: nil, methodType: .delete) { [weak self] result in
            switch result {
            case .success(let data):
                if let serverResponse: GenericResponse = self?.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        self?.delegate?.didReplyDeletedHeader(index: index)
                    }
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
}

extension JobListingVM {
    
    private func parseData(showLoader: Bool, pullToRefresh: Bool, model: Any) {
        if pullToRefresh || self.pageNo == 1 {
            self.jobModel = nil
            self.reviewModel = nil
            self.milestoneModel = nil
        }
        
        if let model = model as? NewJobModel {
            if self.jobModel == nil {
                self.jobModel = model
            } else {
                self.jobModel?.result?.append(contentsOf: model.result ?? [])
            }
            pageNo += 1
            nextHit = !(model.result?.isEmpty ?? true)
            setup(type: .success, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh)
            self.delegate?.didGetNewJobs()
        } else if let model = model as? AllReviewsModel {
            if reviewModel == nil {
                reviewModel = model
            } else {
                reviewModel?.result?.list?.append(contentsOf: model.result?.list ?? [])
            }
            pageNo += 1
            nextHit = !(model.result?.list?.isEmpty ?? true)
            setup(type: .success, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh)
            self.delegate?.didGetAllReviews()
        } else if let model = model as? ApprovedMilestone {
            if self.milestoneModel == nil {
                self.milestoneModel = model
            } else {
                self.milestoneModel?.result?.append(contentsOf: model.result ?? [])
            }
            pageNo += 1
            nextHit = !(model.result?.isEmpty ?? true)
            setup(type: .success, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh)
            self.delegate?.didGetMilestone()
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
            self.delegate?.failure(error: error ?? "")
        }
    }
    
    func hitPagination(index: Int, screenType: JobListingVC.ScreenTypee) {
        var totalCount = 0
        switch screenType {
        case .loggedInBuilder, .allJobs, .newJob, .savedjobs:
            totalCount = jobModel?.result?.count ?? 0
        case .allReviews:
            totalCount = reviewModel?.result?.count ?? 0
        case .newMilestone:
            totalCount = milestoneModel?.result?.count ?? 0
        }
        if nextHit && index == totalCount - 1 && !isHittingApi && totalCount > 5 {
            if CommonFunctions.isConnectedToNetwork() {
                hitPaginationClosure?()
            } else {
                setup(type: .willHit, shouldShowLoader: true, pullToRefresh: false)
            }
        }
    }
}

extension JobListingVM: RetryButtonDelegate {
    
    func didPressRetryButton() {
        if CommonFunctions.isConnectedToNetwork(isShowToast: true) {
            tableViewOutlet.hideBottomLoader()
            hitPaginationClosure?()
        }
    }
}
