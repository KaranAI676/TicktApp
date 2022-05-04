//
//  AddPaymentVC.swift
//  Tickt
//
//  Created by Vijay's Macbook on 19/05/21.
//

protocol BankAccountDelegates: AnyObject {
    func failure(error: String)
    func didGetBankAccount(model: BankModel)
}

class AddPaymentVM: BaseVM {
    weak var delegate: BankAccountDelegates?
    
    func getBankDetails() {        
        ApiManager.request(methodName: EndPoint.getBankDetails.path , parameters: nil, methodType: .get) { [weak self] result in
            switch result {
            case .success(let data):
                if let serverResponse: BankModel = self?.handleSuccess(data: data) {
                    self?.delegate?.didGetBankAccount(model: serverResponse)
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
