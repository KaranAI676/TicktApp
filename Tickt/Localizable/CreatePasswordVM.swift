//
//  CreatePasswordVM.swift
//  Tickt
//
//  Created by S H U B H A M on 12/03/21.
//

import Foundation

//https://ticktdevapi.appskeeper.in/v1/auth/createPassword

protocol CreatePasswordDelegate: AnyObject {
    func success()
    func failure(error: String)
}

class CreatePasswordVM: BaseVM {
    
    weak var delegate: CreatePasswordDelegate? = nil
    
    func createNewPassword(password: String, number: String) {
        
        let param: [String: Any] = [ApiKeys.password: password, ApiKeys.email: number]
        
        ApiManager.request(methodName: EndPoint.createPassword.path, parameters: param, methodType: .put) { [weak self] result in
            switch result {
            case .success(let data):
                if let serverResponse: MobileVerifyModel = self?.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        self?.delegate?.success()
                    } else {
                        self?.delegate?.failure(error: "Something went wrong")
                        CommonFunctions.showToastWithMessage("Something went wrong")
                    }
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            default:
                Console.log("Do Nothing")
            }
        }
    }
}
