//
//  ApproveDeclineBuilderVM.swift
//  Tickt
//
//  Created by S H U B H A M on 20/05/21.
//

import Foundation
import SwiftyJSON

protocol ApproveDeclineBuilderVMDelegate: AnyObject {
    
    func success(model: ApproveDeclineDetailBuilderModel)
    func failure(message: String)
}

class ApproveDeclineBuilderVM: BaseVM {
    
    var delegate: ApproveDeclineBuilderVMDelegate? = nil
    
    func getJobDetails(jobId: String, milestoneId: String, isPullToRefresh: Bool = false) {
        
        var endPoints = ""
        endPoints += "?jobId=\(jobId)&"
        endPoints += "milestoneId=\(milestoneId)"
        ApiManager.request(methodName: EndPoint.jobBuilderMilestoneDetails.path + endPoints, parameters: nil, methodType: .get, showLoader: !isPullToRefresh) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                 let serverResponse: ApproveDeclineDetailBuilderModel = ApproveDeclineDetailBuilderModel(JSON(data))
                    if serverResponse.statusCode == StatusCode.success {
                        self.delegate?.success(model: serverResponse)
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
