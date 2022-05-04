//
//  TradeVM.swift
//  Tickt
//
//  Created by Admin on 11/03/21.
//

import SwiftyJSON


protocol TradeDelegate: AnyObject {
    func success(data: TradeModel)
    func failure(error: String)
}

class TradeVM: BaseVM {
    
    weak var delegate: TradeDelegate?
    
    func getTradeList() {
        if let model = kAppDelegate.tradeModel, model.result?.trade?.count ?? 0 > 0 {
            delegate?.success(data: model)
        } else {
            ApiManager.request(methodName: EndPoint.tradeList.path, parameters: nil, methodType: .get) { [weak self] result in
                switch result {
                case .success(let data):
                     let serverResponse: TradeModel = TradeModel(JSON(data))
                        if serverResponse.statusCode == StatusCode.success {
                            kAppDelegate.tradeModel = serverResponse
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
    }    
}
