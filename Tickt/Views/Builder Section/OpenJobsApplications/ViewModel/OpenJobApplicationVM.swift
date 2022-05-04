//
//  OpenJobApplicationVM.swift
//  Tickt
//
//  Created by S H U B H A M on 20/05/21.
//

import Foundation
import SwiftyJSON

protocol OpenJobApplicationVMDelegate: class {
    func success(model: OpenJobApplicationModel)
    func quoteSuccess(model: QuotesModel)
    func failure(message: String)
}
extension OpenJobApplicationVMDelegate {
    func quoteSuccess(model: QuotesModel){}
    
}

class OpenJobApplicationVM: BaseVM {
    
    weak var delegate: OpenJobApplicationVMDelegate? = nil
    
    func getApplicationList(jobId: String, sortBy: SortingType = .highestRated, isPullToRefresh: Bool = false) {
        ///
        
        ApiManager.request(methodName: EndPoint.jobBuilderNewJobApplicationList.path, parameters: getParams(jobId: jobId, sortBy: sortBy), methodType: .post, showLoader: !isPullToRefresh) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                if let serverResponse: OpenJobApplicationModel = self.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        self.delegate?.success(model: serverResponse)
                    } else {
                        CommonFunctions.showToastWithMessage("Something went wrong.")
                    }
                }
            case .failure(let error):
                self.delegate?.failure(message: error?.localizedDescription ?? "")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func getQuoteList(jobId: String, sortBy: Int, isPullToRefresh: Bool = false) {
        ApiManager.request(methodName: EndPoint.quoteListing.path + "?\(ApiKeys.jobId)=\(jobId)&sort=\(sortBy)", parameters: nil, methodType: .get, showLoader: !isPullToRefresh) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                let serverResponse: QuotesModel = QuotesModel(JSON(data))
                if serverResponse.statusCode == StatusCode.success {
                    self.delegate?.quoteSuccess(model: serverResponse)
                } else {
                    CommonFunctions.showToastWithMessage("Something went wrong.")
                }
            case .failure(let error):
                self.delegate?.failure(message: error?.localizedDescription ?? "")
            default:
                Console.log("Do Nothing")
            }
        }
    }
}


extension OpenJobApplicationVM {
    
    private func getParams(jobId: String, sortBy: SortingType) -> [String: Any] {
        var params = [String: Any]()
        
        params[ApiKeys.page] = 1
        params[ApiKeys.jobId] = jobId
        params[ApiKeys.sortBy] = sortBy.tagValue
        if sortBy == .closestToMe {
            params[ApiKeys.location] =  [ApiKeys.coordinates: [kUserDefaults.getUserLongitude(), kUserDefaults.getUserLatitude()], ApiKeys.type: "Point"]
        }
        return params
    }
}
