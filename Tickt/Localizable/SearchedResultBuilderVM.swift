//
//  SearchedResultBuilderVM.swift
//  Tickt
//
//  Created by S H U B H A M on 28/04/21.
//

import Foundation
import SwiftyJSON

protocol SearchedResultBuilderVMDelegate: AnyObject {
    
    func sucess()
    func failure(error: String)
}

class SearchedResultBuilderVM: BaseVM {
    
    //MARK:- Variables
    var model: SearchingModel?
    var tradeId: [String]?
    var specilId: [String]?
    var delegate: SearchedResultBuilderVMDelegate? = nil
    ///
    var pageNo = 1
    var isHittingApi: Bool = false
    var nextHit: Bool = false
    var tableViewOutlet = UITableView()
    
    //MARK:- Methods
    /// Search Data: Search by Typing
    func getSearchedData(showLoader: Bool = true, isPullToRefresh: Bool = false) {
        self.setup(type: .willHit, shouldShowLoader: !(showLoader || isPullToRefresh), pullToRefresh: isPullToRefresh)
        guard let params = getParameteres(tradeId: tradeId, specilId: specilId) else { return }
        ///
        ApiManager.request(methodName: EndPoint.homeSearch.path, parameters: params, methodType: .post, showLoader: showLoader) { [weak self] result in
            guard let self = self else { return }
            self.isHittingApi = false
            switch result {
            case .success(let data):
                 let serverResponse: SearchingModel = SearchingModel(JSON(data))
                    if serverResponse.statusCode == StatusCode.success {
                        self.parseData(showLoader: showLoader, pullToRefresh: isPullToRefresh, model: serverResponse)
                    } else {
                        self.setup(type: .failure, shouldShowLoader: !(showLoader || isPullToRefresh), pullToRefresh: isPullToRefresh, error: "Something went wrong.")
                    }
            case .failure(let error):
                self.setup(type: .failure, shouldShowLoader: !(showLoader || isPullToRefresh), pullToRefresh: isPullToRefresh, error: error?.localizedDescription ?? "Unknown error")
            default:
                Console.log("Do Nothing")
            }
        }
    }
}

extension SearchedResultBuilderVM {
    
    
    private func getParameteres(tradeId: [String]?, specilId: [String]?) -> [String: Any]? {
        
        guard let model = kAppDelegate.searchingBuilderModel else { return nil }
        
        var params: [String: Any] = [ApiKeys.page: pageNo,
                                     ApiKeys.isFiltered: model.isFiltered]
        
        if let tradeId = tradeId {
            params[ApiKeys.tradeId] = tradeId
        }
        
        if let specilId = specilId {
            params[ApiKeys.specializationId] = specilId
        }
        
        if let location = model.location {
            params[ApiKeys.location] =  [ApiKeys.coordinates: [location.locationLong, location.locationLat]]
        }
        
        if let fromDate = model.fromDate, fromDate.backendFormat != "" {
            params[ApiKeys.fromDate] = fromDate.backendFormat
        }
        
        if let toDate = model.toDate, toDate.backendFormat != "" {
            params[ApiKeys.toDate] = toDate.backendFormat
        }
        
        if let sortBy = model.sortBy {
            params[ApiKeys.sortBy] = sortBy.tagValue
        }
        
        return params
    }
}

extension SearchedResultBuilderVM {
    
    private func parseData(showLoader: Bool, pullToRefresh: Bool, model: SearchingModel) {
        if pullToRefresh || self.pageNo == 1 {
            self.model = nil
        }
        
        if self.model == nil {
            self.model = model
        } else {
            self.model?.result?.data.append(contentsOf: model.result?.data ?? [])
        }
        pageNo += 1
        nextHit = !(model.result?.data.isEmpty ?? false)
        setup(type: .success, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh)
        self.delegate?.sucess()
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
    
    func hitPagination(index: Int) {
        if nextHit && index == (model?.result?.data.count ?? 0) - 1 && !isHittingApi {
            if CommonFunctions.isConnectedToNetwork() {
                getSearchedData(showLoader: false)
            } else {
                setup(type: .willHit, shouldShowLoader: true, pullToRefresh: false)
            }
        }
    }
}

//MARK:- RetryButtonDelegate
//==========================
extension SearchedResultBuilderVM: RetryButtonDelegate {
    
    func didPressRetryButton() {
        if CommonFunctions.isConnectedToNetwork(isShowToast: true) {
            tableViewOutlet.hideBottomLoader()
            getSearchedData(showLoader: false)
        }
    }
}
