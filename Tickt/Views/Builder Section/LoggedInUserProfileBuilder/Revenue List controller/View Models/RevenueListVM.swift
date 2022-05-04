//
//  RevenueListVM.swift
//  Tickt
//
//  Created by Vijay's Macbook on 21/07/21.
//

import Foundation
import SwiftyJSON

protocol RevenueListDelegate: AnyObject {
    func failure(message: String)
    func success(model: RevenueDetailModel)
}

class RevenueListVM: BaseVM {

    weak var delegate: RevenueListDelegate?
    
    func getMilestoneList(jobId: String, pullToRefresh: Bool = false) {
        ApiManager.request(methodName: EndPoint.revenueDetail.path + "?\(ApiKeys.jobId)=\(jobId)", parameters: nil, methodType: .get, showLoader: !pullToRefresh) { [weak self] result in
            switch result {
            case .success(let data):
                 let serverResponse: RevenueDetailModel = RevenueDetailModel(JSON(data))
                    if serverResponse.statusCode == StatusCode.success {
                        self?.delegate?.success(model: serverResponse)
                    } else {
                        CommonFunctions.showToastWithMessage("Parsing error")
                    }
            case .failure(let error):
                self?.delegate?.failure(message: error?.localizedDescription ?? "")
            default:
                Console.log("Do Nothing")
            }
        }
    }
}
