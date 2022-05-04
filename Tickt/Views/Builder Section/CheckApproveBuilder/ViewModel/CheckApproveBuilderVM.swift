//
//  CheckApproveBuilderVM.swift
//  Tickt
//
//  Created by S H U B H A M on 17/05/21.
//

import Foundation

protocol CheckApproveBuilderVMDelegate: class {
    func success(model: CheckApproveBuilderModel)
    func failure(error: String)
}

class CheckApproveBuilderVM: BaseVM {
    
    weak var delegate: CheckApproveBuilderVMDelegate? = nil
    
    func getMilestonesList(_ jobId: String, isPullToRefresh: Bool = false) {
        
        let endParams = "?jobId=\(jobId)"
        ApiManager.request(methodName: EndPoint.jobBuilderMilestoneList.path + endParams, parameters: nil, methodType: .get, showLoader: !isPullToRefresh) { [weak self] result in
            switch result {
            case .success(let data):
                if let serverResponse: CheckApproveBuilderModel = self?.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        self?.delegate?.success(model: serverResponse)
                    } else {
                        CommonFunctions.showToastWithMessage("Something went wrong.")
                    }
                }
            case .failure(let error):
                self?.delegate?.failure(error: error?.localizedDescription ?? "Unknown error")
            default:
                Console.log("Do Nothing")
            }
        }
    }
}
