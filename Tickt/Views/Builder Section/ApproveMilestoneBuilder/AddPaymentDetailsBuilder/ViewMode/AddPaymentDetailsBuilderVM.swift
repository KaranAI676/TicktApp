//
//  AddPaymentDetailsBuilderVM.swift
//  Tickt
//
//  Created by S H U B H A M on 09/07/21.
//

import Foundation

protocol AddPaymentDetailsBuilderVMDelegate: AnyObject {
    
    func successAddedCard(model: CardAddedResultModel)
    func successEditCard(model: CardAddedResultModel)
    func failure(message: String)
}

class AddPaymentDetailsBuilderVM: BaseVM {
    
    weak var delegate: AddPaymentDetailsBuilderVMDelegate? = nil
    
    func addCardDetail(model: AddPaymentDetailBuilderModel) {
        
        ApiManager.request(methodName: EndPoint.paymentBuilderAddNewCard.path, parameters: getParams(model), methodType: .post) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                if let serverResponse: CardAddedModel = self.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        TicketMoengage.shared.postEvent(eventType: .addedPaymentDetails(timestamp: ""))
                        self.delegate?.successAddedCard(model: serverResponse.result)
                    } else {
                        CommonFunctions.showToastWithMessage("Something went wrong.")
                    }
                }
            case .failure(let error):
                self.delegate?.failure(message: error?.localizedDescription ?? "Unknown")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func editCardDetail(model: AddPaymentDetailBuilderModel) {
        
        ApiManager.request(methodName: EndPoint.paymentBuilderUpdateCard.path, parameters: getParams(model, isEdit: true), methodType: .put) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                if let serverResponse: CardAddedModel = self.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        self.delegate?.successEditCard(model: serverResponse.result)
                    } else {
                        CommonFunctions.showToastWithMessage("Something went wrong.")
                    }
                }
            case .failure(let error):
                self.delegate?.failure(message: error?.localizedDescription ?? "Unknown")
            default:
                Console.log("Do Nothing")
            }
        }
    }
}

extension AddPaymentDetailsBuilderVM {
    
    private func getParams(_ model: AddPaymentDetailBuilderModel, isEdit: Bool = false) -> [String: Any] {
        
        
        var params: [String: Any] = [ApiKeys.expMonth: model.expirationMonth,
                                     ApiKeys.expYear: model.expirationYear,
                                     ApiKeys.name: model.holderName]
        
        if isEdit {
            params[ApiKeys.cardId] = model.cardId
        } else {
            params[ApiKeys.number] = model.cardNumber
            params[ApiKeys.cvc] = model.cvv
        }
        return params
    }
}
