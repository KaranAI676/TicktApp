//
//  ReviewBuilderVM.swift
//  Tickt
//
//  Created by Vijay's Macbook on 18/06/21.
//

import Foundation

protocol ReviewBuilderDelegate: AnyObject {
    func didReviewBuilder()
}

class ReviewBuilderVM: BaseVM {
    
    weak var delegate: ReviewBuilderDelegate?
    
    func reviewBuilder(jobData: RecommmendedJob?, review: String, rating: String) {
        let param = [ApiKeys.review: review,
                     ApiKeys.rating: rating,
                     ApiKeys.jobId: jobData?.jobId ?? "",
                     ApiKeys.builderId: jobData?.builderData?.builderId ?? ""]    
        ApiManager.request(methodName: EndPoint.reviewBuilder.path, parameters: param , methodType: .post) { [weak self] result in
            switch result {
            case .success(let data):
                if let _: ReviewModel = self?.handleSuccess(data: data) {                    
                    self?.delegate?.didReviewBuilder()
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            default:
                Console.log("Do Nothing")
            }
        }
    }
}
