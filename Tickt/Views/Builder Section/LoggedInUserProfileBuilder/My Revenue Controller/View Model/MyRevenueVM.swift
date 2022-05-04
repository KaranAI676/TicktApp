//
//  MyRevenueVM.swift
//  Tickt
//
//  Created by Vijay's Macbook on 21/07/21.
//

import Foundation
import SwiftyJSON

protocol MyRevenueDelegate: AnyObject {
    func failure(message: String)
    func success(model: RevenueListResult)
}

class MyRevenueVM: BaseVM {
    
    var searchTask : DispatchWorkItem?
    weak var delegate: MyRevenueDelegate?
    
    func getRevenueService(page: Int = 1, pullToRefresh: Bool = false) {
        let endPoints = getEndPoints(searchText: "", page: page)
        ApiManager.request(methodName: EndPoint.tradieRevenue.path + endPoints, parameters: nil, methodType: .get, showLoader: !pullToRefresh) { [weak self] result in
            switch result {
            case .success(let data):
                 let serverResponse: RevenueListModel = RevenueListModel(JSON(data))
                    if let model = serverResponse.result.first {
                        self?.delegate?.success(model: model)
                    } else {
                        self?.delegate?.failure(message: "Parsing Error")
                    }
            case .failure(let error):
                self?.delegate?.failure(message: error?.localizedDescription ?? "")
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
            ApiManager.request(methodName: EndPoint.tradieRevenue.path + endPoints, parameters: nil, methodType: .get, showLoader: false) { [weak self] result in
                switch result {
                case .success(let data):
                     let serverResponse: RevenueListModel = RevenueListModel(JSON(data))
                        if let model = serverResponse.result.first {
                            self?.delegate?.success(model: model)
                        } else {
                            self?.delegate?.failure(message: "Parsing Error")
                        }
                case .failure(let error):
                    self?.delegate?.failure(message: error?.localizedDescription ?? "")
                default:
                    Console.log("Do Nothing")
                }
            }
        }
        searchTask = task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: task)
    }
    
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
