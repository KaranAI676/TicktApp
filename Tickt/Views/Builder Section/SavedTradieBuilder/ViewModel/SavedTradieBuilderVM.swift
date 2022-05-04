//
//  SavedTradieBuilderVM.swift
//  Tickt
//
//  Created by S H U B H A M on 21/06/21.
//

import Foundation
import SwiftyJSON

protocol SavedTradieBuilderVMDelegate: class {
    
    func success(pulToRefresh: Bool)
    func failure(message: String)
}

class SavedTradieBuilderVM: BaseVM {
    
    //MARK:- Variables
    weak var delegate: SavedTradieBuilderVMDelegate? = nil
    var model: SavedTradieBuilderModel? = nil
    var tableViewOutlet = UITableView()
    var pageNo = 1
    var isHittingApi: Bool = false
    var nextHit: Bool = false
    
    //MARK:- Methods
    func getSavedTradies(showLoader: Bool = true,  pullToRefresh: Bool = false) {
        
        setup(type: .willHit, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh)
        ///
        let endPoint = "?" + ApiKeys.page + "=" + "\(pageNo)"
        ApiManager.request(methodName: EndPoint.profileBuilderGetSavedTradies.path + endPoint, parameters: nil, methodType: .get, showLoader: showLoader) { [weak self] result in
            guard let self = self else { return }
            CommonFunctions.hideActivityLoader()
            self.isHittingApi = false
            switch result {
            case .success(let data):
                let serverResponse: SavedTradieBuilderModel = SavedTradieBuilderModel(JSON(data))
                if serverResponse.statusCode == StatusCode.success {
                    self.parseModel(showLoader: showLoader, pullToRefresh: pullToRefresh, model: serverResponse)
                }else {
                    self.setup(type: .failure, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh, error: "Something went wrong.")
                }
            case .failure(let error):
                self.setup(type: .failure, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh, error: error?.localizedDescription ?? "")
            default:
                Console.log("Do Nothing")
            }
        }
    }
}

extension SavedTradieBuilderVM {
    
    private func parseModel(showLoader: Bool, pullToRefresh: Bool, model: SavedTradieBuilderModel) {
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
        self.delegate?.success(pulToRefresh: pullToRefresh)
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
        if nextHit && index == (model?.result.count ?? 0) - 1 && !isHittingApi {
            if CommonFunctions.isConnectedToNetwork() {
                getSavedTradies(showLoader: false)
            }else {
                setup(type: .willHit, shouldShowLoader: true, pullToRefresh: false)
            }
        }
    }
}


//MARK:- RetryButtonDelegate
//==========================
extension SavedTradieBuilderVM: RetryButtonDelegate {
    
    func didPressRetryButton() {
        if CommonFunctions.isConnectedToNetwork(isShowToast: true) {
            tableViewOutlet.hideBottomLoader()
            getSavedTradies(showLoader: false)
        }
    }
}
