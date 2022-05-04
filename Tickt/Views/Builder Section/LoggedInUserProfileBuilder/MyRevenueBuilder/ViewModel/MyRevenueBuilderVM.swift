//
//  MyRevenueBuilderVM.swift
//  Tickt
//
//  Created by S H U B H A M on 21/07/21.
//

import Foundation
import SwiftyJSON

protocol MyRevenueBuilderVMDelegate: AnyObject {
    func success(model: MyRevenueBuilderResultModel)
    func failure(message: String)
}

class MyRevenueBuilderVM: BaseVM {
    
    weak var delegate: MyRevenueBuilderVMDelegate? = nil
    
    func getRevenueDetail(jobId: String, pullToRefresh: Bool = false) {
        
        let endpoint = "?" + ApiKeys.jobId + "=" + jobId
        
        ApiManager.request(methodName: EndPoint.profileBuilderRevenueDetail.path + endpoint, parameters: nil, methodType: .get, showLoader: !pullToRefresh) { [weak self] result in
            guard let self = self else { return }
            CommonFunctions.hideActivityLoader()
            switch result {
            case .success(let data):
                 let serverResponse: MyRevenueBuilderModel = MyRevenueBuilderModel(JSON(data))
                    if serverResponse.statusCode == StatusCode.success {
                        self.delegate?.success(model: serverResponse.result)
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
}
