//
//  CompanyDetailVM.swift
//  Tickt
//
//  Created by Admin on 12/03/21.
//

import UIKit
import Foundation

protocol AddBuilderDelegate: AnyObject {
    func success()
    func failure(error: String)
}

class CompanyDetailVM: BaseVM {
    
    weak var delegate: AddBuilderDelegate?
    
    func registerUser() {
                        
        var param: [String: Any] = [:]
        param[ApiKeys.userType] = kUserDefaults.getUserType()
        param[ApiKeys.email] = kAppDelegate.signupModel.email
        param[ApiKeys.abn] = kAppDelegate.signupModel.abnNumber
        param[ApiKeys.firstName] =  kAppDelegate.signupModel.name
        param[ApiKeys.deviceToken] = kUserDefaults.getDeviceToken()
        param[ApiKeys.position] = kAppDelegate.signupModel.position
        param[ApiKeys.companyName] = kAppDelegate.signupModel.companyName
        param[ApiKeys.mobileNumber] = kAppDelegate.signupModel.phoneNumber
        param[ApiKeys.location] = [ApiKeys.type: "Point", ApiKeys.coordinates: kAppDelegate.signupModel.location]
        if !kAppDelegate.signupModel.password.isEmpty {
            param[ApiKeys.password] = kAppDelegate.signupModel.password
        }        
        if kUserDefaults.isSocialLogin() {
            param[ApiKeys.authType] = "signup"
            param[ApiKeys.socialId] = kUserDefaults.getSocialId()
            param[ApiKeys.accountType] = kUserDefaults.getSocialLoginType()
        }
        if !kUserDefaults.getUserProfileImage().isEmpty {
            param[ApiKeys.userImage] = kUserDefaults.getUserProfileImage()
        }
        let methodName = kUserDefaults.isSocialLogin() ? EndPoint.socialLogin.path : EndPoint.signup.path
        ApiManager.request(methodName: methodName , parameters: param, methodType: .post) { [weak self] result in
            switch result {
            case .success(let data):
                if let serverResponse: LoginModel = self?.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        kAppDelegate.signupModel = SignupModel()
                        CommonFunctions.setUserDefaults(model: serverResponse.result)
                        self?.delegate?.success()
                    } else {
                        CommonFunctions.showToastWithMessage("Parsing data error")
                    }
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
