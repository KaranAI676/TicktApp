//
//  VouchesLisitngBuilderVM.swift
//  Tickt
//
//  Created by S H U B H A M on 19/06/21.
//

import Foundation
import SwiftyJSON

protocol VouchesLisitngBuilderVMDelegate: AnyObject {
    func success()
    func failure(message: String)
}

class VouchesLisitngBuilderVM: BaseVM {
    
    var model: VouchesLisitngBuilderModel? = nil
    weak var delegate: VouchesLisitngBuilderVMDelegate? = nil
    var hitPagination: (()-> Void)? = nil
    ///
    var pageNo = 1
    var isHittingApi: Bool = false
    var nextHit: Bool = false
    var tableViewOutlet = UITableView()
    
    func getVouchesList(tradieId: String, showLoader: Bool = true, pullToRefresh: Bool = false) {
        
        self.setup(type: .willHit, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh)
        var endParams = EndPoint.jobBuilderGetVoucher.path
        endParams += "?\(ApiKeys.tradieId)=\(tradieId)"
        endParams += "&\(ApiKeys.page)=\(pageNo)"
        
        if kUserDefaults.isTradie() {
            endParams = EndPoint.tradieVouchers.path + "?\(ApiKeys.tradieId)=\(tradieId)&\(ApiKeys.page)=1"
        }
        ApiManager.request(methodName: endParams, parameters: nil, methodType: .get, showLoader: showLoader) { [weak self] result in
            guard let self = self else { return }
            CommonFunctions.hideActivityLoader()
            self.isHittingApi = false
            switch result {
            case .success(let data):
                let serverResponse: VouchesLisitngBuilderModel = VouchesLisitngBuilderModel(JSON(data))
                if serverResponse.statusCode == StatusCode.success {
                    self.parseData(showLoader: showLoader, pullToRefresh: pullToRefresh, model: serverResponse)
                } else {
                    self.setup(type: .failure, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh, error: "Something went wrong.")
                }
            case .failure(let error):
                self.setup(type: .failure, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh, error: error?.localizedDescription ?? "Unknown error")
            default:
                Console.log("Do Nothing")
            }
        }
    }
}

extension VouchesLisitngBuilderVM {
    
    private func parseData(showLoader: Bool, pullToRefresh: Bool, model: VouchesLisitngBuilderModel) {
        if pullToRefresh || self.pageNo == 1 {
            self.model = nil
        }
        
        if self.model == nil {
            self.model = model
        }else {
            self.model?.result.totolVouches = model.result.totolVouches
            self.model?.result.voucher.append(contentsOf: model.result.voucher)
        }
        pageNo += 1
        nextHit = !(model.result.voucher.isEmpty || model.result.voucher.count < 10)
        setup(type: .success, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh)
        self.delegate?.success()
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
        if nextHit && index == (model?.result.voucher.count ?? 0) - 1 && !isHittingApi {
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
extension VouchesLisitngBuilderVM: RetryButtonDelegate {
    
    func didPressRetryButton() {
        if CommonFunctions.isConnectedToNetwork(isShowToast: true) {
            tableViewOutlet.hideBottomLoader()
            hitPagination?()
        }
    }
}
