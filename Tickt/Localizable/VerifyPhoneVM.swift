//
//  VerifyPhoneVM.swift
//  Tickt
//
//  Created by Admin on 11/03/21.
//

import Foundation

protocol VerifyPhoneDelegate: AnyObject {
    func success()
    func resendEmailOTP()
    func successResendOTP()
    func emailVerifiedSuccess()
    func failure(error: String)
    func successEmailVerification()
}

class VerifyPhoneVM: BaseVM {
    
    weak var delegate: VerifyPhoneDelegate?
    
    func resendOTPOnEmailForCreateAccount() {
        ApiManager.request(methodName: EndPoint.checkEmailId.path + kAppDelegate.signupModel.email, parameters: nil, methodType: .get) { [weak self] result in
            switch result {
            case .success(let data):
                if let serverResponse: SocialModel = self?.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        CommonFunctions.showToastWithMessage("OTP sent sucessfully")
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
    
    func verifyOTPForReset(otpString: String, email: String) {
        ApiManager.request(methodName: EndPoint.verifyOTP.path , parameters: [ApiKeys.otp: otpString, ApiKeys.email: email], methodType: .post) { [weak self] result in
            switch result {
            case .success(let data):
                if let serverResponse: MobileVerifyModel = self?.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        self?.delegate?.success()
                    } else {
                        CommonFunctions.showToastWithMessage("Something went wrong.")
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

    func verifyOTPForEmailForCreateAccount(otpString: String) {
        ApiManager.request(methodName: EndPoint.verifyOTP.path , parameters: [ApiKeys.otp: otpString, ApiKeys.email: kAppDelegate.signupModel.email], methodType: .post) { [weak self] result in
            switch result {
            case .success(let data):
                if let serverResponse: MobileVerifyModel = self?.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        self?.delegate?.emailVerifiedSuccess()
                    } else {
                        CommonFunctions.showToastWithMessage("Something went wrong.")
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
    
    func verifyOTPForPhoneForCreateAccount(otpString: String) {
        ApiManager.request(methodName: EndPoint.verifyMobileOtp.path , parameters: [ApiKeys.otp: otpString, ApiKeys.mobileNumber: kAppDelegate.signupModel.phoneNumber], methodType: .post) { [weak self] result in
            switch result {
            case .success(let data):
                if let serverResponse: MobileVerifyModel = self?.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        self?.delegate?.success()
                    } else {
                        CommonFunctions.showToastWithMessage("Something went wrong.")
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
    
    /// Resend OTP while creating the account
    func verifyPhoneNumber(phoneNumber: String) {
        
        ApiManager.request(methodName: EndPoint.checkMobileNumber.path + phoneNumber, parameters: nil, methodType: .get) { [weak self] result in
            switch result {
            case .success(let data):
                if let serverResponse: MobileVerifyModel = self?.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        CommonFunctions.showToastWithMessage(serverResponse.message)
                        self?.delegate?.successResendOTP()
                    } else {
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
    
    /// Resend OTP while resetting the password
    func resendOTPForReset(phoneNumber: String) {

        let param: [String: Any] = [ApiKeys.email: phoneNumber]
        
        ApiManager.request(methodName: EndPoint.forgotPassword.path, parameters: param, methodType: .put) { [weak self] result in
            switch result {
            case .success(let data):
                if let serverResponse: MobileVerifyModel = self?.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        CommonFunctions.showToastWithMessage(serverResponse.message)
                        self?.delegate?.successResendOTP()
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
    
    /// Resent Email OTP
    func resendEmailOTP(model: ChangeEmailModel) {
        
        let params: [String: Any] = [ApiKeys.currentEmail: model.currentEmail,
                                     ApiKeys.newEmail: model.newEmail,
                                     ApiKeys.password: model.password,
                                     ApiKeys.userType: kUserDefaults.getUserType()]
        ///
        ApiManager.request(methodName: EndPoint.profileBuilderChangeEmail.path, parameters: params, methodType: .put) { [weak self] result in
            guard let self = self else { return }
            CommonFunctions.hideActivityLoader()
            switch result {
            case .success( _):
                self.delegate?.resendEmailOTP()
            case .failure(let error):
                self.delegate?.failure(error: error?.localizedDescription ?? "")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    /// Verify Email OTP
    func verifyEmail(newEmail: String, otp: String) {

        let param: [String: Any] = [ApiKeys.newEmail: newEmail,
                                    ApiKeys.otp: otp]
        var endpoint = EndPoint.profileBuilderVerifyEmail.path
        if kUserDefaults.isTradie() {
            endpoint = EndPoint.profileTradieVerifyEmail.path
        }
        ApiManager.request(methodName: endpoint, parameters: param, methodType: .put) { [weak self] result in
            switch result {
            case .success(let data):
                if let serverResponse: MobileVerifyModel = self?.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        self?.delegate?.successEmailVerification()
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
