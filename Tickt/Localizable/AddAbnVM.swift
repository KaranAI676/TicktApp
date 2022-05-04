//
//  AddAbnVM.swift
//  Tickt
//
//  Created by Admin on 12/03/21.
//

import Foundation
import SwiftyJSON

protocol AddAbnDelegate: AnyObject {
    func success()
    func failure(error: String)
}

class AddAbnVM: BaseVM {
    
    weak var delegate: AddAbnDelegate?
    
    func uploadImages() {
        if kAppDelegate.signupModel.docImages.count > 0 {
            
            let imageArray = kAppDelegate.signupModel.docImages.map ({ object in
                return (object.0, object.4)
            })
            
            ApiManager.uploadRequest(methodName: EndPoint.uploadDocument.path, parameters: [ApiKeys.qualifyDoc: imageArray], methodType: .post, showLoader: true, result: { [weak self] result in
                
                switch result {
                case .success(let data):
                    let serverResponse: DocumentModel = DocumentModel(JSON(data))
                    if serverResponse.statusCode == StatusCode.success {
                        self?.registerUser(fileUrls: serverResponse.result?.url ?? [])
                    } else {
                        CommonFunctions.showToastWithMessage("Failed to upload images")
                    }
                case .failure(let error):
                    self?.delegate?.failure(error: error?.localizedDescription ?? "Unknown error")
                    self?.handleFailure(error: error)
                default:
                    Console.log("Do Nothing")
                }
            }, onProgress: { (progress) in
                print(progress)
            })
        } else {
            registerUser()
        }
    }
    
    func registerUser(fileUrls: [String] = []) {
        
        var param: [String: Any] = [:]
        param[ApiKeys.email] = kAppDelegate.signupModel.email
        param[ApiKeys.userType] = kUserDefaults.getUserType()
        param[ApiKeys.abn] = kAppDelegate.signupModel.abnNumber
        param[ApiKeys.firstName] =  kAppDelegate.signupModel.name
        param[ApiKeys.deviceToken] = kUserDefaults.getDeviceToken()
        param[ApiKeys.mobileNumber] = kAppDelegate.signupModel.phoneNumber
        param[ApiKeys.businessName] = kAppDelegate.signupModel.businessName
        param[ApiKeys.trade] = kAppDelegate.signupModel.tradeList.map {$0.id}
        param[ApiKeys.specialization] = kAppDelegate.signupModel.specializations.map {$0.id}
        param[ApiKeys.location] = [ApiKeys.type: "Point", ApiKeys.coordinates: kAppDelegate.signupModel.location]
        
        if kAppDelegate.signupModel.qualifications.count > 0 {
            if kAppDelegate.signupModel.qualifications.count == fileUrls.count {
                var qualificationArray: [[String: String]] = []
                for (index, qualification) in kAppDelegate.signupModel.qualifications.enumerated() {
                    let object = [ApiKeys.qualificationId: qualification.id, ApiKeys.url: fileUrls[index]]
                    qualificationArray.append(object)
                }
                param[ApiKeys.qualification] = qualificationArray
            }
        }
        
        if !kAppDelegate.signupModel.password.isEmpty {
            param[ApiKeys.password] = kAppDelegate.signupModel.password
        }
        if kUserDefaults.isSocialLogin() {            
            param[ApiKeys.authType] = "signup"
            param[ApiKeys.accountType] = kUserDefaults.getSocialLoginType()
            param[ApiKeys.socialId] = kUserDefaults.getSocialId()
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
}
