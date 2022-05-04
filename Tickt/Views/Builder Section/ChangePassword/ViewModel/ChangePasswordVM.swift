//
//  ChangePasswordVM.swift
//  Tickt
//
//  Created by S H U B H A M on 24/06/21.
//

import Foundation

protocol ChangePasswordVMDelegate: AnyObject {
    func success()
    func failure(message: String)
}

class ChangePasswordVM: BaseVM {
    
    weak var delegate: ChangePasswordVMDelegate? = nil
    
    func changePassword(model: PasswordModel) {
        
        var endPoint = EndPoint.profileBuilderChangePassword.path
        if kUserDefaults.isTradie() {
            endPoint = EndPoint.tradieChangePassword.path
        }
        ApiManager.request(methodName: endPoint, parameters: getParams(model), methodType: .put) { [weak self] result in
            guard let self = self else { return }
            CommonFunctions.hideActivityLoader()
            switch result {
            case .success( _):
                self.delegate?.success()
            case .failure(let error):
                self.delegate?.failure(message: error?.localizedDescription ?? "")
            default:
                Console.log("Do Nothing")
            }
        }
    }
}

extension ChangePasswordVM {
    
    func getParams(_ model: PasswordModel) -> [String: Any] {
        let params: [String: Any] = [ApiKeys.oldpassword: model.oldPassword,
                                     ApiKeys.newPassword: model.newPassword,
                                     ApiKeys.userType: kUserDefaults.getUserType()]
        return params
    }
}
