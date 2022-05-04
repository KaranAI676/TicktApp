//
//  QuestionListingBuilderVM.swift
//  Tickt
//
//  Created by S H U B H A M on 13/05/21.
//

import Foundation
import SwiftyJSON

protocol QuestionListingBuilderVMDelegate: class {
    
    func successDeleteAnswer()
    func successDeleteReview()
    func successDeleteReply()
    func successGettingReviews()
    func successGettingQuestions()
    func failure(message: String)
    func didGetQuestions(model: QuestionModel)
}


class QuestionListingBuilderVM: BaseVM {
    
    //MARK:- Variables
    var questionmodel: QuestionModel? = nil
    var hitPagination: (()-> Void)? = nil
    var reviewModel: ReviewListBuilderModel? = nil
    weak var delegate: QuestionListingBuilderVMDelegate? = nil
    ///
    var pageNo = 1
    var isHittingApi: Bool = false
    var nextHit: Bool = false
    var tableViewOutlet = UITableView()
    
    //MARK:- Methods
    func getQuestions(jobId: String, showLoader: Bool = true, pullToRefresh: Bool = false) {
        
        self.setup(type: .willHit, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh)
        let endParams = "?\(ApiKeys.jobId)=\(jobId)&\(ApiKeys.page)=\(pageNo)"
        ApiManager.request(methodName: EndPoint.getQuestionsBuilder.path + endParams, parameters: nil, methodType: .get, showLoader: showLoader) { [weak self] result in
            guard let self = self else { return }
            CommonFunctions.hideActivityLoader()
            self.isHittingApi = false
            switch result {
            case .success(let data):
                if let dataObject = (data as? [String : Any]) {
                    let serverResponse: QuestionModel = QuestionModel(JSON(dataObject))
                    if serverResponse.statusCode == StatusCode.success {
                        self.delegate?.didGetQuestions(model: serverResponse)
                    }else {
                        self.setup(type: .failure, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh, error: "Something went wrong.")
                    }
                }
            case .failure(let error):
                self.setup(type: .failure, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh, error: error?.localizedDescription ?? "")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func getReviews(tradieId: String, showLoader: Bool = true, pullToRefresh: Bool = false) {
        
        self.setup(type: .willHit, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh)
        let endParams = "?\(ApiKeys.tradieId)=\(tradieId)&\(ApiKeys.page)=\(pageNo)"
        ApiManager.request(methodName: EndPoint.jobBuilderReviewList.path + endParams, parameters: nil, methodType: .get, showLoader: showLoader) { [weak self] result in
            guard let self = self else { return }
            CommonFunctions.hideActivityLoader()
            self.isHittingApi = false
            switch result {
            case .success(let data):
                let serverResponse: ReviewListBuilderModel = ReviewListBuilderModel(JSON(data))
                if serverResponse.statusCode == StatusCode.success {
                    self.parseData(showLoader: showLoader, pullToRefresh: pullToRefresh, model: serverResponse)
                } else {
                    self.setup(type: .failure, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh, error: "Something went wrong.")
                }
            case .failure(let error):
                self.setup(type: .failure, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh, error: error?.localizedDescription ?? "Unknown error")
            default:
                Console.log("Do Nothing")
            }
        }
    }
}

extension QuestionListingBuilderVM {
    
    func deleteAnswer(questionId: String, answerId: String) {
        
        var endPoint: String = "?questionId=\(questionId)&"
        endPoint += "answerId=\(answerId)"
        
        ///
        ApiManager.request(methodName: EndPoint.jobBuilderDeleteAnswer.path + endPoint, parameters: nil, methodType: .delete) { [weak self] result in
            switch result {
            case .success( _):
                self?.delegate?.successDeleteAnswer()
            case .failure(let error):
                self?.delegate?.failure(message: error?.localizedDescription ?? "Something went wrong!")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func deleteReview(reviewId: String) {
        
        let endPoint: String = "?" + ApiKeys.reviewId + "=" + reviewId
        ///
        ApiManager.request(methodName: EndPoint.jobBuilderRemoveReviewTradie.path + endPoint, parameters: nil, methodType: .delete) { [weak self] result in
            switch result {
            case .success( _):
                self?.delegate?.successDeleteReview()
            case .failure(let error):
                self?.delegate?.failure(message: error?.localizedDescription ?? "Something went wrong!")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func deleteReply(reviewId: String, replyId: String) {
        
        var endPoint: String = "?" + ApiKeys.reviewId + "=" + reviewId
        endPoint += "&" + "replyId" + "=" + replyId
        
        ApiManager.request(methodName: EndPoint.jobBuilderRemoveReviewReply.path + endPoint, parameters: nil, methodType: .delete) { [weak self] result in
            switch result {
            case .success( _):
                self?.delegate?.successDeleteReply()
            case .failure(let error):
                self?.delegate?.failure(message: error?.localizedDescription ?? "Something went wrong!")
            default:
                Console.log("Do Nothing")
            }
        }
    }
}

extension QuestionListingBuilderVM {
    
    private func parseData(showLoader: Bool, pullToRefresh: Bool, model: Any) {
        if pullToRefresh || self.pageNo == 1 {
            self.reviewModel = nil
            self.questionmodel = nil
        }
        
        if let model = model as? ReviewListBuilderModel {
            if self.reviewModel == nil {
                self.reviewModel = model
            }else {
                self.reviewModel?.result.reviewCount = model.result.reviewCount
                self.reviewModel?.result.list.append(contentsOf: model.result.list)
            }
            nextHit = !(model.result.list.isEmpty)
            pageNo += 1
            setup(type: .success, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh)
            delegate?.successGettingReviews()
        }
        
        if let model = model as? QuestionModel {
            if self.questionmodel == nil {
                self.questionmodel = model
            }else {
                self.questionmodel?.result.questionCount = model.result.questionCount
                self.questionmodel?.result.list.append(contentsOf: model.result.list)
            }
            nextHit = !(model.result.list.isEmpty)
            pageNo += 1
            setup(type: .success, shouldShowLoader: !(showLoader || pullToRefresh), pullToRefresh: pullToRefresh)
            delegate?.successGettingQuestions()
        }
    }
    
    
    private func setup(type: ResponseType, shouldShowLoader: Bool, pullToRefresh: Bool, error: String? = nil) {
        switch type {
        case .willHit:
            isHittingApi = true
            if pullToRefresh {
                self.pageNo = 1
            }
        
            if shouldShowLoader {
                tableViewOutlet.showBottomLoader(delegate: self)
            }
        case .success:
            tableViewOutlet.hideBottomLoader()
        case .failure:
            if shouldShowLoader {
                tableViewOutlet.showBottomLoader(delegate: self, isNetworkConnected: false)
            }else {
                tableViewOutlet.hideBottomLoader()
            }
            self.delegate?.failure(message: error ?? "")
        }
    }
    
    func hitPagination(index: Int, screenType: QuestionListingBuilderVC.ScreenType) {
        switch screenType {
        case .questionAnswer:
            if nextHit && index == (questionmodel?.result.list.count ?? 0) - 1 && !isHittingApi {
                if CommonFunctions.isConnectedToNetwork() {
                    self.hitPagination?()
                }else {
                    setup(type: .willHit, shouldShowLoader: true, pullToRefresh: false)
                }
            }
        default:
            if nextHit && index == (reviewModel?.result.list.count ?? 0) - 1 && !isHittingApi {
                if CommonFunctions.isConnectedToNetwork() {
                    self.hitPagination?()
                }else {
                    setup(type: .willHit, shouldShowLoader: true, pullToRefresh: false)
                }
            }
        }
    }
}

//MARK:- RetryButtonDelegate
//==========================
extension QuestionListingBuilderVM: RetryButtonDelegate {
    
    func didPressRetryButton() {
        if CommonFunctions.isConnectedToNetwork(isShowToast: true) {
            tableViewOutlet.hideBottomLoader()
            self.hitPagination?()
        }
    }
}
