//
//  MapViewModel.swift
//  Tickt
//
//  Created by Admin on 15/02/21.
//  Copyright © 2021 Tickt. All rights reserved.
//

import Foundation
import CoreLocation

protocol MapViewModelDelegate: AnyObject {
    func didReceiveSuccess(message: String)
    func didReceiveError(message: String)
}

class MapViewModel: BaseVM {
    
    var dataModel: SearchResultModel?
    
    var coordinates: CLLocationCoordinate2D? = nil
    var startDate: Date?
    var endDate: Date?
    weak var delegate: MapViewModelDelegate?
    var isShowNoEmptyData: Bool = false
    var isHittingApi: Bool = false
    var address: String = ""
    var tags: [String] = []
    var needToUpdateData: Bool = false
    var filterData = FilterData()
        
//    func getSearchedResult(model: SearchModel) {
//        
//        var param: [String: Any] = [ApiKeys.page: 1,
//                                    ApiKeys.isFiltered: filterData.isFiltered]
//        
//        if !model.specializationId.isEmpty {
//            param[ApiKeys.specializationId] = model.specializationId
//        }
//        
//        if !model.tradeId.isEmpty {
//            param[ApiKeys.tradeId] = model.tradeId
//        }
//        
//        if !model.fromDate.isEmpty {            
//            param[ApiKeys.fromDate] = model.fromDate
//        }
//        
//        if !model.toDate.isEmpty {
//            param[ApiKeys.toDate] = model.toDate
//        }
//        
//        if !model.payType.isEmpty {
//            param[ApiKeys.payType] = model.payType
//            param[ApiKeys.maxBudget] = model.maxBudget
//        }
//        
//        if model.location.count > 0 {
//            param[ApiKeys.location] = [ApiKeys.coordinates: [model.location[1], model.location[0]]]
//        }
//        
//        ApiManager.request(methodName: EndPoint.jobSearch.path , parameters: param, methodType: .post) { [weak self] result in
//            switch result {
//            case .success(let data):
//                if let serverResponse: SearchResultModel = self?.handleSuccess(data: data) {
//                    if serverResponse.statusCode == StatusCode.success {
//                        self?.dataModel = serverResponse
//                        self?.delegate?.didReceiveSuccess(message: serverResponse.message)
//                    } else {
//                        CommonFunctions.showToastWithMessage("Something went wrong.")
//                    }
//                }
//            case .failure(let error):
//                self?.delegate?.didReceiveError(message: error?.localizedDescription ?? "Unknown error")
//                self?.handleFailure(error: error)
//            default:
//                Console.log("Do Nothing")
//            }
//        }
//    }
}

