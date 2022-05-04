//
//  JobListVM.swift
//  Tickt
//
//  Created by Vijay's Macbook on 12/08/21.
//

import Foundation

protocol JobListDelegate: AnyObject {
    func didGetJobList()
    func failure(error: String)
}

class JobListVM: BaseVM, RetryButtonDelegate {
    
    var pageNo = 1
    var nextHit = false
    var isHittingApi = false
    var jobModel: JobListModel?
    var tableViewOutlet = UITableView()
    var hitPaginationClosure: (()-> Void)?
    
    weak var delegate: JobListDelegate?
    
    func getJobList(userId: String, userType: String, showLoader: Bool = true, isPullToRefresh: Bool) {
        setup(type: .willHit, shouldShowLoader: !(showLoader || isPullToRefresh), pullToRefresh: isPullToRefresh)
        ApiManager.request(methodName: EndPoint.jobList.path + "?\(ApiKeys.userId)=\(userId)&\(ApiKeys.userType)=\(userType)" + "&\(ApiKeys.page)=\(pageNo)&perPage=15", parameters: nil, methodType: .get, showLoader: showLoader) { [weak self] result in
            self?.isHittingApi = false
            switch result {
            case .success(let data):
                if let serverResponse: JobListModel = self?.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        self?.parseData(showLoader: showLoader, pullToRefresh: isPullToRefresh, model: serverResponse)
                    }
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    private func parseData(showLoader: Bool, pullToRefresh: Bool, model: Any) {
        if pullToRefresh || pageNo == 1 {
            jobModel = nil
        }
        
        if let model = model as? JobListModel {
            if jobModel == nil {
                jobModel = model
            } else {
                jobModel?.result.data.append(contentsOf: model.result.data)
            }
            pageNo += 1
            nextHit = !(model.result.data.isEmpty)
            setup(type: .success, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh)
            delegate?.didGetJobList()
        }
    }
    
    private func setup(type: ResponseType, shouldShowLoader: Bool, pullToRefresh: Bool, error: String? = nil) {
        switch type {
        case .willHit:
            isHittingApi = true
            if pullToRefresh {
                pageNo = 1
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
            delegate?.failure(error: error ?? "")
        }
    }
    
    func hitPagination(index: Int) {
        if nextHit && index == (jobModel?.result.data.count ?? 0) - 1 && !isHittingApi {
            if CommonFunctions.isConnectedToNetwork() {
                hitPaginationClosure?()
            } else {
                setup(type: .willHit, shouldShowLoader: true, pullToRefresh: false)
            }
        }
    }
    
    func didPressRetryButton() {
        if CommonFunctions.isConnectedToNetwork(isShowToast: true) {
            tableViewOutlet.hideBottomLoader()
            hitPaginationClosure?()
        }
    }
}
