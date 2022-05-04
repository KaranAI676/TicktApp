//
//  ReviewReplyVM.swift
//  Tickt
//
//  Created by Vijay's Macbook on 09/07/21.
//

import Foundation

protocol ReviewReplyDelegate: AnyObject {
    func didReviewUpdated()
    func failure(error: String)
    func didReviewAdded(reply: ReplyResult)
}

class ReviewReplyVM: BaseVM {
    
    weak var delegate: ReviewReplyDelegate?
    
    func reviewReply(reviewId: String, isEdit: Bool, reply: String, replyId: String) {
        var endpoint = EndPoint.tradieReviewReply.path
        var param = [ApiKeys.reviewId: reviewId, ApiKeys.reply: reply]
        if isEdit {
            param[ApiKeys.replyId] = replyId
            endpoint = EndPoint.updateReviewReply.path
        }
        ApiManager.request(methodName: endpoint, parameters: param , methodType: isEdit ? .put : .post) { [weak self] result in
            switch result {
            case .success(let data):
                if let serverResponse: ReplyModel = self?.handleSuccess(data: data) {
                    if !isEdit {
                        TicketMoengage.shared.postEvent(eventType: .addedReview(timestamp: ""))
                    }
                    guard let result = serverResponse.result else {
                        return
                    }
                    self?.delegate?.didReviewAdded(reply: result)
                }
            case .failure(let error):
                self?.delegate?.failure(error: error?.localizedDescription ?? "Something went wrong!")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func reviewBuilder(builderId: String, jobId: String, review: String, rating: String) {
        let param = [ApiKeys.jobId: jobId,
                     ApiKeys.review: review,
                     ApiKeys.rating: rating,
                     ApiKeys.builderId: builderId]
        
        ApiManager.request(methodName: EndPoint.reviewBuilder.path, parameters: param , methodType: .post) { [weak self] result in
            switch result {
            case .success(let data):
                if let _: ReviewModel = self?.handleSuccess(data: data) {
                    self?.delegate?.didReviewUpdated()
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            default:
                Console.log("Do Nothing")
            }
        }
    }
}
