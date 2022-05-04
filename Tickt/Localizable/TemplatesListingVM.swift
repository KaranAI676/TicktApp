//
//  TemplatesListingVM.swift
//  Tickt
//
//  Created by S H U B H A M on 02/04/21.
//

import Foundation

protocol TemplatesListingVMDelegate: AnyObject {
    func success(data: MilestoneListModel)
    func successDidGetTemplate()
    func deleteSuccess(indexPath: IndexPath)
    func failure(error: String)
}

class TemplatesListingVM: BaseVM {
    
    var pageNo = 1
    var isHittingApi: Bool = false
    var nextHit: Bool = false
    var tableViewOutlet = UITableView()
    ///
    var model: TemplateListModel?
    weak var delegate: TemplatesListingVMDelegate?
    
    func getTemplatesList(showLoader: Bool = true, isPullToRefresh: Bool = false) {
        
        self.setup(type: .willHit, shouldShowLoader: !(showLoader || isPullToRefresh), pullToRefresh: isPullToRefresh)
        ApiManager.request(methodName: EndPoint.templateList.path + "?\(ApiKeys.page)=\(pageNo)", parameters: nil, methodType: .get, showLoader: showLoader) { [weak self] result in
            guard let self = self else { return }
            self.isHittingApi = false
            switch result {
            case .success(let data):
                if let serverResponse: TemplateListModel = self.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        self.parseData(showLoader: showLoader, pullToRefresh: isPullToRefresh, model: serverResponse)
                    } else {
                        self.setup(type: .failure, shouldShowLoader: !(showLoader || isPullToRefresh), pullToRefresh: isPullToRefresh, error: "Something went wrong.")
                    }
                }
            case .failure(let error):
                self.setup(type: .failure, shouldShowLoader: !(showLoader || isPullToRefresh), pullToRefresh: isPullToRefresh, error: error?.localizedDescription ?? "Unknown error")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func getMilestonesList(templateId: String) {
        ApiManager.request(methodName: EndPoint.jobTempMilestoneList.path+"?tempId=\(templateId)", parameters: nil, methodType: .get) { [weak self] result in
            switch result {
            case .success(let data):
                if let serverResponse: MilestoneListModel = self?.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        self?.delegate?.success(data: serverResponse)
                    } else {
                        CommonFunctions.showToastWithMessage("Something went wrong.")
                    }
                }
            case .failure(let error):
                self?.delegate?.failure(error: error?.localizedDescription ?? "Unknown error")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func deleteTemplate(templateId: String, indexPath: IndexPath) {
        let param: [String: Any] = [ApiKeys.milestoneId: templateId]
        ApiManager.request(methodName: EndPoint.profileBuilderDeleteTemplate.path, parameters: param, methodType: .put) { [weak self] result in
            switch result {
            case .success( _):
                self?.delegate?.deleteSuccess(indexPath: indexPath)
            case .failure(let error):
                self?.delegate?.failure(error: error?.localizedDescription ?? "Unknown error")
            default:
                Console.log("Do Nothing")
            }
        }
    }
}

extension TemplatesListingVM {
    
    private func parseData(showLoader: Bool, pullToRefresh: Bool, model: TemplateListModel) {
        if pullToRefresh || self.pageNo == 1 {
            self.model = nil
        }
        
        if self.model == nil {
            self.model = model
        }else {
            self.model?.result.append(contentsOf: model.result)
        }
        pageNo += 1
        nextHit = !model.result.isEmpty
        setup(type: .success, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh)
        self.delegate?.successDidGetTemplate()
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
            self.delegate?.failure(error: error ?? "")
        }
    }
    
    func hitPagination(index: Int) {
        if nextHit && index == (model?.result.count ?? 0) - 1 && !isHittingApi {
            if CommonFunctions.isConnectedToNetwork() {
                getTemplatesList(showLoader: false)
            }else {
                setup(type: .willHit, shouldShowLoader: true, pullToRefresh: false)
            }
        }
    }
}

//MARK:- RetryButtonDelegate
//==========================
extension TemplatesListingVM: RetryButtonDelegate {
    
    func didPressRetryButton() {
        if CommonFunctions.isConnectedToNetwork(isShowToast: true) {
            tableViewOutlet.hideBottomLoader()
            getTemplatesList(showLoader: false)
        }
    }
}
