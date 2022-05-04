//
//  SearchingBuilderVM.swift
//  Tickt
//
//  Created by S H U B H A M on 22/04/21.
//

import Foundation
import SwiftyJSON

protocol SearchingBuilderVMDelegate: AnyObject {
    func successByTyping(data: SearchingModel)
    func successByCategory(data: SearchingModel)
    func success(model: SearchedResultModel)
    func searchedResultNotFound()
    func success(model: RecentSearchModel)
    func success(data: TradeModel)
    func failure(error: String)
}

class SearchingBuilderVM: BaseVM {
    
    weak var delegate: SearchingBuilderVMDelegate?
    
    /// Used to get the trade list
    func getTradeList() {
        if let model = kAppDelegate.tradeModel, model.result?.trade?.count ?? 0 > 0 {
            delegate?.success(data: model)
        } else {
            ApiManager.request(methodName: EndPoint.tradeList.path, parameters: nil, methodType: .get) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                     let serverResponse: TradeModel = TradeModel(JSON(data))
                        if serverResponse.statusCode == StatusCode.success {
                            kAppDelegate.tradeModel = serverResponse
                            self.delegate?.success(data: serverResponse)
                        } else {
                            CommonFunctions.showToastWithMessage("Something went wrong.")
                        }
                case .failure(let error):
                    self.delegate?.failure(error: error?.localizedDescription ?? "Unknown error")
                    self.handleFailure(error: error)
                default:
                    Console.log("Do Nothing")
                }
            }
        }
    }
    
    /// Search trades by name
    func getSearchedTrades(searchText: String) {
        let modifiedSearchedText = (searchText.byRemovingLeadingTrailingWhiteSpaces).replace(string: CommonStrings.whiteSpace, withString: "%20")
        if modifiedSearchedText.isEmpty {
            return
        }
        ///
        ApiManager.request(methodName: EndPoint.getSearchedData.path + modifiedSearchedText, parameters: nil, methodType: .get, showLoader: false) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
         //       TicketMoengage.shared.postEvent(eventType: .searchedForTradies(timestamp: , category: <#T##String#>, location: <#T##String#>, maxbudget: <#T##NSNumber#>, lengthOfHire: <#T##NSNumber#>, startDate: <#T##Date#>, endDate: <#T##Date#>))
                if let serverResponse: SearchedResultModel = self.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        self.delegate?.success(model: serverResponse)
                    }
                }else {
                    self.delegate?.searchedResultNotFound()
                }
            case .failure(let error):
                self.delegate?.failure(error: error?.localizedDescription ?? "Unknown error")
                self.handleFailure(error: error)
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    /// Recent Jobs
    func getRecentJobs(showLoader: Bool = false) {
        ApiManager.request(methodName: EndPoint.getRecentSearch.path, parameters: nil, methodType: .get, showLoader: showLoader) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                if let serverResponse: RecentSearchModel = self.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success || serverResponse.statusCode == StatusCode.emptyData {
                        self.delegate?.success(model: serverResponse)
                    } else {
                        
                    }
                }
            case .failure(let error):
                self.delegate?.failure(error: error?.localizedDescription ?? "Unknown error")
                self.handleFailure(error: error)
            default:
                Console.log("Do Nothing")
            }
        }
    }
}

