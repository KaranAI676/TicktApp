//
//  ItemListViewModel.swift
//  Tickt
//
//  Created by Admin on 18/04/21.
//

import Foundation
import CoreLocation
import SwiftyJSON

protocol ItemListViewModelDelegate: APIResultDelegate {
    func didReceiveSuccess(message: String, model: SearchResultModel)
    func didReceiveError(message: String)
}

class ItemListViewModel: BaseVM {
    
    var pageNo = 1
    var nextHit = false
    var isHittingApi = false
    var filterData = FilterData()
    var dataModel: SearchResultModel?
    var totalCountString: String = ""
    var tableViewOutlet = UITableView()
    var hitPaginationClosure: (()-> Void)?
    weak var delegate: ItemListViewModelDelegate?
    var isShowNoEmptyData: Bool {
        return dataModel?.result?.isEmpty ?? false
    }
    var coordinates: CLLocationCoordinate2D? = nil
    
    func getSearchedResult(model: SearchModel, showLoader: Bool, isPullToRefresh: Bool) {
            
        setup(type: .willHit, shouldShowLoader: !(showLoader || isPullToRefresh), pullToRefresh: isPullToRefresh)
        var param: [String: Any] = [ApiKeys.page: pageNo,
                                    ApiKeys.isFiltered: filterData.isFiltered]
        
        if let sortBy = model.sortBy {
            param[ApiKeys.sortBy] = sortBy.tagValue
        }
        
        var specializations = model.specializationId
        specializations.removeAll { $0.isEmpty }
        
        if !specializations.isEmpty {
            param[ApiKeys.specializationId] = model.specializationId            
        }
        
        if !model.tradeId.isEmpty {
            param[ApiKeys.tradeId] = model.tradeId
        }
        
        if !model.jobTypes.isEmpty {
            param[ApiKeys.jobTypes] = model.jobTypes
        }
        
        if !model.fromDate.isEmpty {
            param[ApiKeys.fromDate] = model.fromDate
        }
        
        if !model.toDate.isEmpty {
            param[ApiKeys.toDate] = model.toDate
        }
        
        if !model.payType.isEmpty {
            param[ApiKeys.payType] = model.payType
            if filterData.isFiltered {
                param[ApiKeys.minBudget] = model.minBudget
                param[ApiKeys.maxBudget] = model.maxBudget
            } else {
                param[ApiKeys.maxBudget] = model.maxBudget
            }
        }
        
        if model.location.count > 1, (model.location[0] != 0.0 && model.location[1] != 0.0) {
            param[ApiKeys.location] = [ApiKeys.coordinates: [model.location[1], model.location[0]]]
        }
        ApiManager.request(methodName: EndPoint.jobSearch.path , parameters: param, methodType: .post, showLoader: showLoader) { [weak self] result in
            self?.isHittingApi = false
            switch result {
            case .success(let data):
                 let serverResponse: SearchResultModel = SearchResultModel(JSON(data))
                    if serverResponse.statusCode == StatusCode.success {
                        self?.parseData(showLoader: showLoader, pullToRefresh: isPullToRefresh, model: serverResponse)
                    } else {
                        CommonFunctions.showToastWithMessage("Something went wrong.")
                    }
            case .failure(let error):
                self?.delegate?.didReceiveError(message: error?.localizedDescription ?? "Unknown error")
                self?.handleFailure(error: error)
            default:
                Console.log("Do Nothing")
            }
        }
    }
}
 
extension ItemListViewModel: RetryButtonDelegate {
    
    private func parseData(showLoader: Bool, pullToRefresh: Bool, model: Any) {
        if pullToRefresh || pageNo == 1 {
            dataModel = nil
        }
        
        if filterData.isFiltered  && pageNo == 1 {
            dataModel = nil
        }
        
        if let model = model as? SearchResultModel {
            if dataModel == nil {
                dataModel = model
            } else {
                dataModel?.result?.append(contentsOf: model.result ?? [])
            }
            totalCountString = "\(dataModel?.result?.count ?? 0) Results"
            pageNo += 1
            nextHit = !(model.result?.isEmpty ?? true)
            setup(type: .success, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh)
            delegate?.didReceiveSuccess(message: model.message, model: dataModel!)
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
            delegate?.didReceiveError(message: error ?? "Unknown error")
        }
    }
    
    func hitPagination(index: Int) {
        let totalCount = dataModel?.result?.count ?? 0
        if nextHit && index == totalCount - 1 && !isHittingApi {
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

