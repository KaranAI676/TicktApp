//
//  BuilderProfileVM.swift
//  Tickt
//
//  Created by Vijay's Macbook on 24/05/21.
//

import SwiftyJSON
protocol BuilderProfileDelegate: AnyObject {
    func didGetProfile(model: ProfileModel)
    func failure(error: String)
}

class BuilderProfileVM: BaseVM {
    
    weak var delegate: BuilderProfileDelegate?
    
    func getBuilderProfile(isPullToRefresh: Bool, builderId: String) {
        ApiManager.request(methodName: EndPoint.viewBuilderProfile.path + "?\(ApiKeys.builderId)=\(builderId)", parameters: nil, methodType: .get) { [weak self] result in
            switch result {
            case .success(let data):
                let serverResponse: ProfileModel = ProfileModel(JSON(data))
                TicketMoengage.shared.postEvent(eventType: .viewedBuilderProfile(name: serverResponse.result?.builderName ?? "", category: serverResponse.result?.builderName ?? "", location: serverResponse.result?.builderName ?? ""))
                if serverResponse.statusCode == StatusCode.success {
                    self?.delegate?.didGetProfile(model: serverResponse)
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
