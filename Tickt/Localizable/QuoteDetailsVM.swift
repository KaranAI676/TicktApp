//
//  QuoteDetailsVM.swift
//  Tickt
//
//  Created by Admin on 15/09/21.
//

import Foundation
import SwiftyJSON

protocol QuoteDetailsVMDelegate: AnyObject {
    func success(data: QuotesModel)
    func successAccpetDecline(status: AcceptDecline)
    func failure(error: String)
}

class QuoteDetailsVM: BaseVM {
    
    weak var delegate: QuoteDetailsVMDelegate?
    
    func getQuoteDetails(jobId:String,tradieID:String,sortBy:SortingType = .highestRated) {
           ApiManager.request(methodName: EndPoint.quoteListing.path+"?\(ApiKeys.jobId)=\(jobId)&\(ApiKeys.sortBy)=\(1)&\(ApiKeys.tradieId)=\(tradieID)", parameters: nil, methodType: .get) { [weak self] result in
                switch result {
                case .success(let data):
                     let serverResponse: QuotesModel = QuotesModel(JSON(data))
                        if serverResponse.statusCode == StatusCode.success {
                            self?.delegate?.success(data: serverResponse)
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
    
    func acceptDecline(jobId: String, tradieId: String, status: AcceptDecline) {
        
        let params: [String : Any] = [ApiKeys.jobId: jobId, "tradieId": tradieId, "status": status.tag]
        
        ApiManager.request(methodName: EndPoint.jobBuilderAcceptDeclineRequest.path, parameters: params, methodType: .put) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.delegate?.successAccpetDecline(status: status)
            case .failure(let error):
                self.delegate?.failure(error: error?.localizedDescription ?? "")
            default:
                Console.log("Do Nothing")
            }
        }
    }
}
