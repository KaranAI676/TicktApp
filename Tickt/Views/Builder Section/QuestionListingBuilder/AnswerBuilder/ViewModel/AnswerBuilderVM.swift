//
//  AnswerBuilderVM.swift
//  Tickt
//
//  Created by S H U B H A M on 12/06/21.
//

import Foundation
import SwiftyJSON

protocol AnswerBuilderVMDelegate: AnyObject {
    
    func didEditReplySuccess(reply: String)
    func didReplyOnReview(replyModel: ReviewBuilderReplyData)
    func didEditReviewSuccess(updatedReview: String, rating: Double)
    func didEditAnsawerSuccess(updatedAnswer: String)
    func didAnswerSucces(model: AnswerDatasModel)
    func failure(message: String)
}

class AnswerBuilderVM: BaseVM {
    
    weak var delegate: AnswerBuilderVMDelegate? = nil
    
    func answerOnQuestion(builderId: String,tradieId: String, questionId: String, answer: String) {
        
        //        let params: [String: Any] = [ApiKeys.jobId: jobId,
        //                                     ApiKeys.questionId: questionId,
        //                                     ApiKeys.answer: answer]
        ///
        
        
        let params: [String: Any] = [ApiKeys.builderId: builderId,
                                     ApiKeys.questionId: questionId,
                                     ApiKeys.tradieId: tradieId,
                                     ApiKeys.answer: answer]
        
        ApiManager.request(methodName: EndPoint.jobBuilderAnswerQuestion.path , parameters: params , methodType: .put) { [weak self] result in
            switch result {
            case .success(let data):
                let serverResponse: AnswerDatasModel = AnswerDatasModel(JSON(data))
                self?.delegate?.didAnswerSucces(model: serverResponse)
            case .failure(let error):
                self?.delegate?.failure(message: error?.localizedDescription ?? "Something went wrong!")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func replyOnAnswer(builderId: String,tradieId: String, questionId: String, answer: String) {
        
        //        let params: [String: Any] = [ApiKeys.jobId: jobId,
        //                                     ApiKeys.questionId: questionId,
        //                                     ApiKeys.answer: answer]
        ///
        let params: [String: Any] = [ApiKeys.builderId: builderId,
                                     ApiKeys.questionId: questionId,
                                     ApiKeys.tradieId: tradieId,
                                     ApiKeys.answer: answer]
        
        if kUserDefaults.isTradie() {
            ApiManager.request(methodName: EndPoint.job_tradie_answer.path, parameters: params , methodType: .post) { [weak self] result in
                switch result {
                case .success(let data):
                    let serverResponse: AnswerDatasModel = AnswerDatasModel(JSON(data))
                    self?.delegate?.didAnswerSucces(model: serverResponse)
                case .failure(let error):
                    self?.delegate?.failure(message: error?.localizedDescription ?? "Something went wrong!")
                default:
                    Console.log("Do Nothing")
                }
            }
        }else{
            ApiManager.request(methodName: EndPoint.job_builder_answer.path, parameters: params , methodType: .post) { [weak self] result in
                switch result {
                case .success(let data):
                    let serverResponse: AnswerDatasModel = AnswerDatasModel(JSON(data))
                    self?.delegate?.didAnswerSucces(model: serverResponse)
                case .failure(let error):
                    self?.delegate?.failure(message: error?.localizedDescription ?? "Something went wrong!")
                default:
                    Console.log("Do Nothing")
                }
            }
        }
        
        
    }
    
    func editAnswer(answerId: String, questionId: String, answer: String, jobId: String) {
        
        let params: [String: Any] = [ApiKeys.answerId: answerId,
                                     ApiKeys.questionId: questionId,
                                     ApiKeys.answer: answer,
                                     ApiKeys.jobId: jobId]
        ///
        ApiManager.request(methodName: EndPoint.jobBuilderUpdateAnswer.path, parameters: params , methodType: .put) { [weak self] result in
            switch result {
            case .success( _):
                self?.delegate?.didEditAnsawerSuccess(updatedAnswer: answer)
            case .failure(let error):
                self?.delegate?.failure(message: error?.localizedDescription ?? "Something went wrong!")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func editReview(reviewId: String, review: String, rating: Double) {
        
        let params: [String: Any] = [ApiKeys.reviewId: reviewId,
                                     ApiKeys.rating: rating,
                                     ApiKeys.review: review]
        ///
        ApiManager.request(methodName: EndPoint.jobBuilderUpdateReviewTradie.path, parameters: params , methodType: .put) { [weak self] result in
            switch result {
            case .success( _):
                self?.delegate?.didEditReviewSuccess(updatedReview: review, rating: rating)
            case .failure(let error):
                self?.delegate?.failure(message: error?.localizedDescription ?? "Something went wrong!")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func replyReview(reviewId: String, reply: String) {
        
        let params: [String: Any] = [ApiKeys.reviewId: reviewId,
                                     ApiKeys.reply: reply]
        ///
        ApiManager.request(methodName: EndPoint.jobBuilderReviewReply.path, parameters: params , methodType: .post) { [weak self] result in
            switch result {
            case .success(let data):
                 let serverResponse: ReplyDataModel = ReplyDataModel(JSON(data))
                    self?.delegate?.didReplyOnReview(replyModel: serverResponse.result)
            case .failure(let error):
                self?.delegate?.failure(message: error?.localizedDescription ?? "Something went wrong!")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func editReply(reviewId: String, reply: String, replyId: String) {
        
        let params: [String: Any] = [ApiKeys.reviewId: reviewId,
                                     "replyId": replyId,
                                     ApiKeys.reply: reply]
        ///
        ApiManager.request(methodName: EndPoint.jobBuilderUpdateReviewReply.path, parameters: params , methodType: .put) { [weak self] result in
            switch result {
            case .success( _):
                self?.delegate?.didEditReplySuccess(reply: reply)
            case .failure(let error):
                self?.delegate?.failure(message: error?.localizedDescription ?? "Something went wrong!")
            default:
                Console.log("Do Nothing")
            }
        }
    }
}
