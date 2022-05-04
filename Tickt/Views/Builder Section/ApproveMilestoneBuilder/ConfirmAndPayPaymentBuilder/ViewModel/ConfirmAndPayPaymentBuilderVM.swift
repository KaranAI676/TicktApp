//
//  ConfirmAndPayPaymentBuilderVM.swift
//  Tickt
//
//  Created by S H U B H A M on 18/06/21.
//

import Foundation

protocol ConfirmAndPayPaymentBuilderVMDelegate: class {
    
    func cardDeleteSuccess(index: IndexPath)
    func successGetCardList()
    func successApprove()
    func paymentFailed(message: String)
    func failure(message: String)
}

class ConfirmAndPayPaymentBuilderVM: BaseVM {
    
    var model: [CardListResultModel]?
    ///
    var pageNo = 1
    var isHittingApi: Bool = false
    var nextHit: Bool = false
    var tableViewOutlet = UITableView()
    weak var delegate: ConfirmAndPayPaymentBuilderVMDelegate? = nil
    
    func approveMilestone(model: ApproveDeclineMilestoneModel) {
        ApiManager.request(methodName: EndPoint.jobBuilderMilestoneApproveDecline.path, parameters: getParams(model), methodType: .put) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success( _):
                self.delegate?.successApprove()
            case .failure(let error):
                self.delegate?.paymentFailed(message: error?.localizedDescription ?? "Unknown")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func cardListing(showLoader: Bool = true, pullToRefresh: Bool = false) {
        
        self.setup(type: .willHit, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh)
        ApiManager.request(methodName: EndPoint.paymentBuilderCardList.path, parameters: nil, methodType: .get, showLoader: showLoader) { [weak self] result in
            guard let self = self else { return }
            self.isHittingApi = false
            switch result {
            case .success(let data):
                if let serverResponse: CardListModel = self.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        self.parseData(showLoader: showLoader, pullToRefresh: pullToRefresh, model: serverResponse)
                    } else {
                        self.setup(type: .failure, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh, error: "Something went wrong.")
                    }
                }
            case .failure(let error):
                self.setup(type: .failure, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh, error: error?.localizedDescription ?? "")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func deleteCard(cardId: String, index: IndexPath) {
        
        let params = [ApiKeys.cardId: cardId]
        
        ApiManager.request(methodName: EndPoint.paymentBuilderDeleteCard.path, parameters: params, methodType: .delete) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success( _):
                self.delegate?.cardDeleteSuccess(index: index)
            case .failure(let error):
                self.delegate?.failure(message: error?.localizedDescription ?? "Unknown")
            default:
                Console.log("Do Nothing")
            }
        }
    }
}

extension ConfirmAndPayPaymentBuilderVM {
    
    private func getParams(_ model: ApproveDeclineMilestoneModel) -> [String: Any] {
        let params: [String: Any] = [ApiKeys.jobId: model.jobId,
                                     ApiKeys.milestoneAmount: model.milestoneData.milestoneAmount.decimalValue,
                                     ApiKeys.amount: model.milestoneData.total.decimalValue,
                                     ApiKeys.paymentMethodId: model.paymentMethods,
                                     ApiKeys.milestoneId: model.milestoneData.milestoneId,
                                     ApiKeys.status: AcceptDecline.accept.tag]
        return params
    }
}


extension ConfirmAndPayPaymentBuilderVM {
    
    private func parseData(showLoader: Bool, pullToRefresh: Bool, model: CardListModel) {
        if pullToRefresh || self.pageNo == 1 {
            self.model = nil
        }
        
        if self.model == nil {
            self.model = model.result
        }else {
            self.model?.append(contentsOf: model.result)
        }
        pageNo += 1
        nextHit = !model.result.isEmpty
        setup(type: .success, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh)
        self.delegate?.successGetCardList()
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
    
    func hitPagination(index: Int) {
        if nextHit && index == (model?.count ?? 0) - 1 && !isHittingApi {
            if CommonFunctions.isConnectedToNetwork() {
                cardListing(showLoader: false)
            }else {
                setup(type: .willHit, shouldShowLoader: true, pullToRefresh: false)
            }
        }
    }
}

//MARK:- RetryButtonDelegate
//==========================
extension ConfirmAndPayPaymentBuilderVM: RetryButtonDelegate {
    
    func didPressRetryButton() {
        if CommonFunctions.isConnectedToNetwork(isShowToast: true) {
            tableViewOutlet.hideBottomLoader()
            cardListing(showLoader: false)
        }
    }
}
