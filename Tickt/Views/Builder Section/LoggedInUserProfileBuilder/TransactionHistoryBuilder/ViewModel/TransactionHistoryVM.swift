//
//  TransactionHistoryVM.swift
//  Tickt
//
//  Created by S H U B H A M on 20/07/21.
//

import Foundation
import SwiftyJSON

protocol TransactionHistoryVMDelegate: AnyObject {
    func success(model: TransactionHistoryResultModel)
    func failure(message: String)
}

class TransactionHistoryVM: BaseVM {
    
    var searchTask : DispatchWorkItem?
    weak var delegate: TransactionHistoryVMDelegate? = nil
    
    func getTransactionHistory(page: Int = 1, pullToRefresh: Bool = false) {
        
        let endPoints = getEndPoints(searchText: "", page: page)
        ApiManager.request(methodName: EndPoint.profileBuilderMyRevenue.path + endPoints, parameters: nil, methodType: .get, showLoader: !pullToRefresh) { [weak self] result in
            guard let self = self else { return }
            CommonFunctions.hideActivityLoader()
            switch result {
            case .success(let data):
                let serverResponse: TransactionHistoryModel = TransactionHistoryModel(JSON(data))
                if serverResponse.statusCode == StatusCode.success, let model = serverResponse.result.first {
                    self.delegate?.success(model: model)
                } else {
                    self.delegate?.failure(message: "Something went wrong.")
                }
            case .failure(let error):
                self.delegate?.failure(message: error?.localizedDescription ?? "")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func getSearchedData(searchText: String = "", page: Int = 1) {
        searchTask?.cancel()
        if !self.isValid(searchText: searchText) { return }
        let task = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            
            let endPoints = self.getEndPoints(searchText: searchText, page: page)
            ApiManager.request(methodName: EndPoint.profileBuilderMyRevenue.path + endPoints, parameters: nil, methodType: .get, showLoader: false) { [weak self] result in
                guard let self = self else { return }
                CommonFunctions.hideActivityLoader()
                switch result {
                case .success(let data):
                    let serverResponse: TransactionHistoryModel = TransactionHistoryModel(JSON(data))
                    if serverResponse.statusCode == StatusCode.success, let model = serverResponse.result.first {
                        self.delegate?.success(model: model)
                    } else {
                        self.delegate?.failure(message: "Something went wrong.")
                    }
                case .failure(let error):
                    self.delegate?.failure(message: error?.localizedDescription ?? "")
                default:
                    Console.log("Do Nothing")
                }
            }
        }
        
        searchTask = task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: task)
    }
}

extension TransactionHistoryVM {
    
    private func getEndPoints(searchText: String, page: Int) -> String {
        
        var endPoints = "?" + ApiKeys.page + "=" + "\(page)"
        let modifiedSearchedText = (searchText.byRemovingLeadingTrailingWhiteSpaces).replace(string: CommonStrings.whiteSpace, withString: "%20")
        
        if !modifiedSearchedText.isEmpty {
            endPoints += "&" + ApiKeys.search + "=" + "\(modifiedSearchedText)"
        }
        return endPoints
    }
    
    private func isValid(searchText: String) -> Bool {
        let modifiedSearchedText = (searchText.byRemovingLeadingTrailingWhiteSpaces).replace(string: CommonStrings.whiteSpace, withString: "%20")
        
        if modifiedSearchedText.isEmpty {
            return false
        }
        return true
    }
}
