//
//  AskQuestionVM.swift
//  Tickt
//
//  Created by Admin on 05/05/21.
//

import UIKit
import SwiftyJSON

protocol AskQuestionDelegate: AnyObject {
    func failure(error: String)
    func didQuestionPosted(question: QuestionData)
}

protocol UpdateQuestionDelegate: AnyObject {
    func didEditedQuestion(question: QuestionData)
    func didQuestionAdded(question: QuestionData)
}

class AskQuestionVM: BaseVM {
    
    weak var delegate: AskQuestionDelegate?
    
    func askQuestion(jobId: String, question: String, builderId: String, tradeId: String, specializationId: String) {
        let param = [ApiKeys.jobId: jobId,
                     ApiKeys.question: question,
                     ApiKeys.builderId: builderId]
        ApiManager.request(methodName: EndPoint.askQuestion.path, parameters: param , methodType: .post) { [weak self] result in
            switch result {
            case .success(let data):
                let serverResponse: AskQuestion = AskQuestion(JSON(data))
                TicketMoengage.shared.postEvent(eventType: .askedAQuestion(timestamp: ""))
                self?.delegate?.didQuestionPosted(question: serverResponse.result!)
            case .failure(let error):
                self?.delegate?.failure(error: error?.localizedDescription ?? "Something went wrong!")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func editQuestion(questionId: String, question: String) {
        ApiManager.request(methodName: EndPoint.editQuestion.path, parameters: [ApiKeys.questionId: questionId, ApiKeys.question: question], methodType: .put) { [weak self] result in
            switch result {
            case .success(let data):
                 let serverResponse: AskQuestion = AskQuestion(JSON(data))
                    self?.delegate?.didQuestionPosted(question: serverResponse.result!)
            case .failure(let error):
                self?.delegate?.failure(error: error?.localizedDescription ?? "Something went wrong!")
            default:
                Console.log("Do Nothing")
            }
        }
    }
}
