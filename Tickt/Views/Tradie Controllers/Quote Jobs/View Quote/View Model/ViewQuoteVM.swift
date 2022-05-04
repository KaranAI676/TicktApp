//
//  ViewQuoteVM.swift
//  Tickt
//
//  Created by Vijay's Macbook on 24/09/21.
//

import Foundation

protocol ViewQuoteDelegate: AnyObject {
    func didGetQuotes(model: [ItemDetails])
}

class ViewQuoteVM: BaseVM {
    
    weak var delegate: ViewQuoteDelegate?
    
    func getQuoteDetail(jobId: String, tradieId: String) {
        let queryParam = "?\(ApiKeys.jobId)=\(jobId)&\(ApiKeys.tradeId)=\(tradieId)"
        ApiManager.request(methodName: EndPoint.quoteListing.path + queryParam, parameters: nil, methodType: .get) { [weak self] result in
            switch result {
            case .success(let data):
                TicketMoengage.shared.postEvent(eventType: .viewQuote(timestamp: ""))
                if let serverResponse: MyQuoteModel = self?.handleSuccess(data: data) {
                    self?.delegate?.didGetQuotes(model: serverResponse.result.resultData.first?.quoteItem ?? [])
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            default:
                Console.log("Do Nothing")
            }
        }
    }

}
