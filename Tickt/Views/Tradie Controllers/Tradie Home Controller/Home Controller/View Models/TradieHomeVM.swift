//
//  HomeVM.swift
//  Tickt
//
//  Created by Admin on 27/03/21.
//

import UIKit
import Foundation
import CoreLocation
import SwiftyJSON

protocol HomeDelegate: AnyObject {
    func didGetJobs(model: RecommmendedJobModel)
    func failure(error: String)
    func successTradies(model: TradeModel)
    func didGetJobTypes(jobModel: JobModel)
    func successBuilder(model: BuilderHomeModel)
}

class TradieHomeVM: BaseVM {
    
    var pageNo = 1
    var nextHit = false
    var isHittingApi = false
    weak var delegate: HomeDelegate?
    var homeTableView = UITableView()
    var hitPaginationClosure: (()-> Void)?
    var recommendedModel: RecommmendedJobModel?
    
    func getRecommendedJobs(location: CLLocationCoordinate2D, showLoader: Bool = true, isPullToRefresh: Bool) {
        setup(type: .willHit, shouldShowLoader: !(showLoader || isPullToRefresh), pullToRefresh: isPullToRefresh)
        let endPoint = EndPoint.recommendedJob.path + "?\(ApiKeys.page)=\(pageNo)" + "&lat=\(location.latitude)&long=\(location.longitude)"
        ApiManager.request(methodName: endPoint, parameters: nil, methodType: .get, showLoader: showLoader) { [weak self] result in
            self?.isHittingApi = false
            switch result {
            case .success(let data):
                let serverResponse: RecommmendedJobModel = RecommmendedJobModel(JSON(data))
                if serverResponse.statusCode == StatusCode.success {
                    self?.parseData(showLoader: showLoader, pullToRefresh: isPullToRefresh, model: serverResponse)
                } else {
                    CommonFunctions.showToastWithMessage("Something went wrong.")
                }
                
            case .failure(let error):
                self?.setup(type: .failure, shouldShowLoader: !(showLoader || isPullToRefresh), pullToRefresh: isPullToRefresh, error: error?.localizedDescription ?? "Unknown error")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func getJobTypes() {
        ApiManager.request(methodName: EndPoint.jobTypeList.path, parameters: nil, methodType: .get) { [weak self] result in
            switch result {
            case .success(let data):
                if let serverResponse: JobModel = self?.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        self?.delegate?.didGetJobTypes(jobModel: serverResponse)
                    } else {
                        CommonFunctions.showToastWithMessage("Something went wrong.")
                    }
                }
            case .failure(let error):
                self?.delegate?.failure(error: error?.localizedDescription ?? "Unknown error")
                self?.handleFailure(error: error)
            default:
                Console.log("Do Nothing")
            }
        }
    }
}

extension TradieHomeVM {
    
    func getTradeList() {
        if let model = kAppDelegate.tradeModel {
            self.delegate?.successTradies(model: model)
        } else {
            ApiManager.request(methodName: EndPoint.tradeList.path, parameters: nil, methodType: .get) { [weak self] result in
                switch result {
                case .success(let data):
                    let serverResponse: TradeModel = TradeModel(JSON(data))
                    if serverResponse.statusCode == StatusCode.success {
                        kAppDelegate.tradeModel = serverResponse
                        self?.delegate?.successTradies(model: serverResponse)
                    } else {
                        CommonFunctions.showToastWithMessage("Something went wrong.")
                    }
                case .failure(let error):
                    self?.delegate?.failure(error: error?.localizedDescription ?? "Unknown error")
                    self?.handleFailure(error: error)
                default:
                    Console.log("Do Nothing")
                }
            }
        }
    }
    
    func getHomeData(location: CLLocationCoordinate2D) {
        ApiManager.request(methodName: EndPoint.recommendedJob.path+"?lat=\(location.latitude)&long=\(location.longitude)", parameters: nil, methodType: .get) { [weak self] result in
            switch result {
            case .success(let data):
                let serverResponse: BuilderHomeModel = BuilderHomeModel(JSON(data))
                if serverResponse.statusCode == StatusCode.success {
                    self?.delegate?.successBuilder(model: serverResponse)
                } else {
                    CommonFunctions.showToastWithMessage("Something went wrong.")
                }
            case .failure(let error):
                self?.delegate?.failure(error: error?.localizedDescription ?? "Unknown error")
                self?.handleFailure(error: error)
            default:
                Console.log("Do Nothing")
            }
        }
    }
}


extension TradieHomeVM: RetryButtonDelegate {
    
    private func parseData(showLoader: Bool, pullToRefresh: Bool, model: Any) {
        if pullToRefresh || self.pageNo == 1 {
            recommendedModel = nil
        }
        
        if let model = model as? RecommmendedJobModel {
            if recommendedModel == nil {
                recommendedModel = model
            } else {
                recommendedModel?.result?.recomendedJobs?.append(contentsOf: model.result?.recomendedJobs ?? [])
            }
            pageNo += 1
            nextHit = !(model.result?.recomendedJobs?.isEmpty ?? true)
            setup(type: .success, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh)
            delegate?.didGetJobs(model: model)
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
                homeTableView.showBottomLoader(delegate: self)
            }
        case .success:
            homeTableView.hideBottomLoader()
        case .failure:
            if shouldShowLoader {
                homeTableView.showBottomLoader(delegate: self, isNetworkConnected: false)
            } else {
                homeTableView.hideBottomLoader()
            }
            self.delegate?.failure(error: error ?? "")
        }
    }
    
    func hitPagination(index: Int, screenType: TradieHomeVC.CellTypes) {
        var totalCount = 0
        switch screenType {
        case .recommentedJobs :
            totalCount = recommendedModel?.result?.recomendedJobs?.count ?? 0
        default:
            break
        }
        if nextHit && index == totalCount - 1 && !isHittingApi && totalCount > 8 {
            if CommonFunctions.isConnectedToNetwork() {
                hitPaginationClosure?()
            } else {
                setup(type: .willHit, shouldShowLoader: true, pullToRefresh: false)
            }
        }
    }
    
    func didPressRetryButton() {
        if CommonFunctions.isConnectedToNetwork(isShowToast: true) {
            homeTableView.hideBottomLoader()
            hitPaginationClosure?()
        }
    }
}
