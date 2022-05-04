//
//  NewApplicantBuilderVM.swift
//  Tickt
//
//  Created by S H U B H A M on 16/05/21.
//

import Foundation

protocol NewApplicantBuilderVMDelegate: AnyObject {
    
    func successNeedsApproval(model: NeedApprovalBuilderModel)
    func successNewApplicant()
    func failure(message: String)
}

class NewApplicantBuilderVM: BaseVM {
    
    var modelNewApplicant: NewApplicantBuilderModel?
    var modelNeedApproval: NeedApprovalBuilderModel?
    ///
    var pageNo = 1
    var isHittingApi: Bool = false
    var nextHit: Bool = false
    var tableViewOutlet = UITableView()
    var hitPagination: (()-> Void)? = nil
    weak var delegate: NewApplicantBuilderVMDelegate? = nil
    
    func getNewApplicantsList(showLoader: Bool = true, isPullToRefresh: Bool = false) {

        self.setup(type: .willHit, shouldShowLoader: !(showLoader || isPullToRefresh), pullToRefresh: isPullToRefresh)
        let endPoints = "?page=\(pageNo)"
        ApiManager.request(methodName: EndPoint.newApplicantListing.path + endPoints, parameters: nil, methodType: .get, showLoader: showLoader) { [weak self] result in
            guard let self = self else { return }
            self.isHittingApi = false
            switch result {
            case .success(let data):
                if let serverResponse: NewApplicantBuilderModel = self.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        self.parseData(showLoader: showLoader, pullToRefresh: isPullToRefresh, model: serverResponse)
                    } else {
                        self.setup(type: .failure, shouldShowLoader: !(showLoader || isPullToRefresh), pullToRefresh: isPullToRefresh, error: "Something went wrong.")
                    }
                }
            case .failure(let error):
                self.setup(type: .failure, shouldShowLoader: !(showLoader || isPullToRefresh), pullToRefresh: isPullToRefresh, error: error?.localizedDescription ?? "")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func getNeedApprovalList(showLoader: Bool = true, isPullToRefresh: Bool = false) {
        
        self.setup(type: .willHit, shouldShowLoader: !(showLoader || isPullToRefresh), pullToRefresh: isPullToRefresh)
        let endPoints = "?page=\(pageNo)"
        ApiManager.request(methodName: EndPoint.needApprovalListing.path + endPoints, parameters: nil, methodType: .get, showLoader: showLoader) { [weak self] result in
            guard let self = self else { return }
            self.isHittingApi = false
            switch result {
            case .success(let data):
                if let serverResponse: NeedApprovalBuilderModel = self.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        self.parseData(showLoader: showLoader, pullToRefresh: isPullToRefresh, model: serverResponse)
                    } else {
                        self.setup(type: .failure, shouldShowLoader: !(showLoader || isPullToRefresh), pullToRefresh: isPullToRefresh, error: "Something went wrong.")
                    }
                }
            case .failure(let error):
                self.setup(type: .failure, shouldShowLoader: !(showLoader || isPullToRefresh), pullToRefresh: isPullToRefresh, error: error?.localizedDescription ?? "")
            default:
                Console.log("Do Nothing")
            }
        }
    }
}

extension NewApplicantBuilderVM {
    
    private func parseData(showLoader: Bool, pullToRefresh: Bool, model: Any) {
        if pullToRefresh || self.pageNo == 1 {
            self.modelNewApplicant = nil
            self.modelNeedApproval = nil
        }
        
        if let model = model as? NewApplicantBuilderModel {
            if self.modelNewApplicant == nil {
                self.modelNewApplicant = model
            }else {
                self.modelNewApplicant?.result.append(contentsOf: model.result)
            }
            pageNo += 1
            nextHit = !model.result.isEmpty
            setup(type: .success, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh)
            self.delegate?.successNewApplicant()
        }
        
        if let model = model as? NeedApprovalBuilderModel {
            if self.modelNeedApproval == nil {
                self.modelNeedApproval = model
            }else {
                self.modelNeedApproval?.result.append(contentsOf: model.result)
            }
            pageNo += 1
            nextHit = !model.result.isEmpty
            setup(type: .success, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh)
            self.delegate?.successNewApplicant()
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
            }else {
                tableViewOutlet.hideBottomLoader()
            }
            self.delegate?.failure(message: error ?? "")
        }
    }
    
    func hitPagination(index: Int, screenType: ScreenType) {
        var totalCount = 0
        switch screenType {
        case .newApplicatants:
            totalCount = modelNewApplicant?.result.count ?? 0
        case .needApproval:
            totalCount = modelNeedApproval?.result.count ?? 0
        default:
            break
        }
        
        if nextHit && index == totalCount - 1 && !isHittingApi && totalCount > 5 {
            if CommonFunctions.isConnectedToNetwork() {
                hitPagination?()
            }else {
                setup(type: .willHit, shouldShowLoader: true, pullToRefresh: false)
            }
        }
    }
}

//MARK:- RetryButtonDelegate
//==========================
extension NewApplicantBuilderVM: RetryButtonDelegate {
    
    func didPressRetryButton() {
        if CommonFunctions.isConnectedToNetwork(isShowToast: true) {
            tableViewOutlet.hideBottomLoader()
            hitPagination?()
        }
    }
}
