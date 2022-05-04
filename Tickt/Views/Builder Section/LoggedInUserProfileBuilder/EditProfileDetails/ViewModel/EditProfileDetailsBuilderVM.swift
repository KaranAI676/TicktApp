//
//  EditProfileDetailsBuilderVM.swift
//  Tickt
//
//  Created by S H U B H A M on 27/06/21.
//

import Foundation
import SwiftyJSON

protocol EditProfileDetailsVMDelegate: AnyObject {
    
    func successEdit()
    func didGetTradeList()
    func success(model: EditProfileDetailsModel)
    func failure(message: String)
}

class EditProfileDetailsVM: BaseVM {
    
    weak var delegate: EditProfileDetailsVMDelegate? = nil
    
    func editBasicDetails(model: EditProfileDetailsModel) {
        var endPoint = EndPoint.profileBuilderEditBasicDetails.path
        if kUserDefaults.isTradie() {
            endPoint = EndPoint.editTradieBasicDetails.path
        }
        ApiManager.request(methodName: endPoint, parameters: getParams(model), methodType: .put) { [weak self] result in
            guard let self = self else { return }
            CommonFunctions.hideActivityLoader()
            switch result {
            case .success( _):
                ChatHelper.updateUserDetails()
                kUserDefaults.setValue(model.fullName, forKey: UserDefaultKeys.kUsername)
                kUserDefaults.setValue(model.fullName, forKey: UserDefaultKeys.kFirstName)
                self.delegate?.successEdit()
            case .failure(let error):
                self.delegate?.failure(message: error?.localizedDescription ?? "")
            default:
                Console.log("Do Nothing")
            }
        }
    }        
    
    func getBasicDetails() {
        let endPoint = kUserDefaults.isTradie() ? EndPoint.tradieBasicDetails.path : EndPoint.profileBuilderGetBasicDetails.path
        ApiManager.request(methodName: endPoint, parameters: nil, methodType: .get) { [weak self] result in
            guard let self = self else { return }
            CommonFunctions.hideActivityLoader()
            switch result {
            case .success(let data):
                if let serverResponse: EditProfileDetailsBuildeModel = self.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        self.delegate?.success(model: serverResponse.result)
                    } else {
                        self.delegate?.failure(message: "")
                        CommonFunctions.showToastWithMessage("Something went wrong.")
                    }
                } else {
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
    
    func getTradeList() {
        if kAppDelegate.tradeModel == nil {
            ApiManager.request(methodName: EndPoint.tradeList.path, parameters: nil, methodType: .get) { [weak self] result in
                switch result {
                case .success(let data):
                    let serverResponse: TradeModel = TradeModel(JSON(data))
                        if serverResponse.statusCode == StatusCode.success {
                            kAppDelegate.tradeModel = serverResponse
                            self?.delegate?.didGetTradeList()
                        } else {
                            CommonFunctions.showToastWithMessage("Something went wrong.")
                        }
                case .failure(let error):
                    self?.handleFailure(error: error)
                default:
                    Console.log("Do Nothing")
                }
            }
        } else {
            delegate?.didGetTradeList()
        }
    }
}

extension EditProfileDetailsVM {
    
    private func getParams(_ model: EditProfileDetailsModel) -> [String: Any] {
        
        var params = [String: Any]()
       
        params[ApiKeys.fullName] = model.fullName
        params[ApiKeys.mobileNumber] = model.mobileNumber
        params[ApiKeys.email] = model.email
        params[ApiKeys.abn] = model.abn
        params[ApiKeys.businessName] = model.businessName
        
        if kUserDefaults.isTradie() {
            var qualificationArray: [[String: String]] = []
            for qualification in model.qualificationDoc ?? [] {
                let object = [ApiKeys.qualificationId: qualification.qualificationId, ApiKeys.url: qualification.url]
                qualificationArray.append(object)
            }
            params[ApiKeys.qualificationDoc] = qualificationArray
        } else {
            params[ApiKeys.companyNameWithUnderscore] = model.companyName
            params[ApiKeys.position] = model.position
        }
        return params
    }
}
