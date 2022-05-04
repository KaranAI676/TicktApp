//
//  AddPhoneNumberVM.swift
//  Tickt
//
//  Created by Admin on 09/03/21.
//

import UIKit

protocol AddPhoneNumberDelegate: AnyObject {
    func success()
    func failure(error: String)
}

class AddPhoneNumberVM: BaseVM  {
    
    weak var delegate: AddPhoneNumberDelegate?
    
    func verifyPhoneNumber(phoneNumber: String) {
        ApiManager.request(methodName: EndPoint.checkMobileNumber.path + phoneNumber, parameters: nil, methodType: .get) { [weak self] result in
            switch result {
            case .success(let data):
                if let serverResponse: SocialModel = self?.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        let status = serverResponse.result?.isProfileCompleted ?? false
                        if !status {
                            self?.delegate?.success()
                        } else {
                            CommonFunctions.showToastWithMessage(serverResponse.message)
                        }
                    } else {
                        CommonFunctions.showToastWithMessage("Something went wrong.")
                    }
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func verifyEmailForReset(email: String) {
        let param: [String: Any] = [ApiKeys.email: email, ApiKeys.userType: kUserDefaults.getUserType()]
        ApiManager.request(methodName: EndPoint.forgotPassword.path, parameters: param, methodType: .put) { [weak self] result in
            switch result {
            case .success(let data):
                if let serverResponse: MobileVerifyModel = self?.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        self?.delegate?.success()
                    } else {
                        self?.delegate?.failure(error: "Something went wrong")
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
