//
//  QuestionVM.swift
//  Tickt
//
//  Created by Admin on 06/05/21.
//

import UIKit
import SwiftyJSON

protocol GetQuestionDelegate: AnyObject {
    func failure()
    func didQuestionDeleted(index: Int)
    func didGetQuestions(model: QuestionModel)
    func successDeleteAnswer()
}

class QuestionVM: BaseVM {
    
    weak var delegate: GetQuestionDelegate?
    
    func getQuestions(page: Int, jobId: String) {
        ApiManager.request(methodName: EndPoint.getQuestion.path + "?\(ApiKeys.jobId)=\(jobId)" + "&page=\(page)", parameters: nil, methodType: .get) { [weak self] result in
            switch result {
            case .success(let data):
                if let dataObject = (data as? [String : Any]) {
                    let serverResponse: QuestionModel = QuestionModel(JSON(dataObject))
                    if serverResponse.statusCode == StatusCode.success {
                        self?.delegate?.didGetQuestions(model: serverResponse)
                    }
                }
            case .failure(let error):
                self?.delegate?.failure()
                self?.handleFailure(error: error)
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func deleteQuestions(questionId: String, jobId: String, index: Int) {
        ApiManager.request(methodName: EndPoint.deleteQuestion.path , parameters: [ApiKeys.questionId: questionId, ApiKeys.jobId: jobId], methodType: .delete) { [weak self] result in
            switch result {
            case .success(let data):
                if let serverResponse: GenericResponse = self?.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        self?.delegate?.didQuestionDeleted(index: index)
                    }
                }
            case .failure(let error):
                self?.delegate?.failure()
                self?.handleFailure(error: error)
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func deleteAnswer(questionId: String, answerId: String) {
        
        var endPoint: String = "?questionId=\(questionId)&"
        endPoint += "answerId=\(answerId)"
        
        ///
        ApiManager.request(methodName: EndPoint.jobBuilderDeleteAnswer.path + endPoint, parameters: nil, methodType: .delete) { [weak self] result in
            switch result {
            case .success( _):
                self?.delegate?.successDeleteAnswer()
            case .failure(let error):
                self?.delegate?.failure()
                self?.handleFailure(error: error)
            default:
                Console.log("Do Nothing")
            }
        }
    }
}
