//
//  ConfirmAndPayDetailsBuilderVM.swift
//  Tickt
//
//  Created by S H U B H A M on 14/07/21.
//

import Foundation

protocol ConfirmAndPayDetailsBuilderVMDelegate: AnyObject {
    
    func didSuccessRecentCard(model: CardListResultModel)
    func failure(message: String)
}

class ConfirmAndPayDetailsBuilderVM: BaseVM {
    
    weak var delegate: ConfirmAndPayDetailsBuilderVMDelegate? = nil
    
    func getRecentCard() {
        
        ApiManager.request(methodName: EndPoint.paymentBuilderLastUsedCard.path, parameters: nil, methodType: .get) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                if let serverResponse: RecentCardModel = self.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        self.delegate?.didSuccessRecentCard(model: serverResponse.result)
                    } else {
                        self.delegate?.failure(message: "")
                        CommonFunctions.showToastWithMessage("Something went wrong.")
                    }
                }else {
                    self.delegate?.failure(message: "")
                    CommonFunctions.showToastWithMessage("Something went wrong.")
                }
            case .failure(let error):
                self.delegate?.failure(message: error?.localizedDescription ?? "")
            default:
                Console.log("Do Nothing")
            }
        }
    }
}
