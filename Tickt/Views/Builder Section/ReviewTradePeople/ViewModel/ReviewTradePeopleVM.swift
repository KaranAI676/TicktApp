//
//  ReviewTradePeopleVM.swift
//  Tickt
//
//  Created by S H U B H A M on 25/05/21.
//

import Foundation

protocol ReviewTradePeopleVMDelegate: class {
    func success(id: String)
    func failure(message: String)
}

class ReviewTradePeopleVM: BaseVM {
    
    weak var delegate: ReviewTradePeopleVMDelegate? = nil
    
    func reviewTradie(model: ReviewTradePeopleModel) {
        
        ApiManager.request(methodName: EndPoint.jobBuilderReviewTradie.path, parameters: getParams(model), methodType: .post) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                if let serverResponse: ReviewPostedModel = self.handleSuccess(data: data) {
                    self.delegate?.success(id: serverResponse.result.jobId)
                }
            case .failure(let error):
                self.delegate?.failure(message: error?.localizedDescription ?? "Unknown")
            default:
                Console.log("Do Nothing")
            }
        }
    }
}

extension ReviewTradePeopleVM {
    
    private func getParams(_ model: ReviewTradePeopleModel) -> [String: Any] {
        
        var params: [String: Any] = [ApiKeys.jobId: model.jobData.jobId ?? "",
                                     ApiKeys.tradieId: model.tradieData.tradieId ?? "",
                                     ApiKeys.rating: model.rating]
        if !model.review.isEmpty {
            params[ApiKeys.review] = model.review
        }
        return params
    }
}
