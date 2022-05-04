//
//  MilestoneVM.swift
//  Tickt
//
//  Created by Vijay's Macbook on 15/05/21.
//

import SwiftyJSON

protocol MilestoneDelegate: AnyObject {
    func didGetMilestone(model: JobMilestoneModel)
    func failure(error: String)
}

class MilestoneVM: BaseVM {
    
    weak var delegate: MilestoneDelegate?
    
    func getMilestones(isPullToRefresh: Bool, jobId: String) {
        ApiManager.request(methodName: EndPoint.milestoneList.path + "?jobId=\(jobId)", parameters: nil, methodType: .get, showLoader: !isPullToRefresh) { [weak self] result in
            switch result {
            case .success(let data):
                 let serverResponse: JobMilestoneModel = JobMilestoneModel(JSON(data))
                    if serverResponse.statusCode == StatusCode.success {
                        self?.delegate?.didGetMilestone(model: serverResponse)
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


