//
//  ChangeEmailVM.swift
//  Tickt
//
//  Created by S H U B H A M on 06/07/21.
//

import Foundation

protocol ChangeEmailVMDelegate: AnyObject {
    func success()
    func failure(message: String)
}

class ChangeEmailVM: BaseVM {
    
    weak var delegate: ChangeEmailVMDelegate? = nil
    
    func changeEmail(model: ChangeEmailModel) {
        var endpoint = EndPoint.profileBuilderChangeEmail.path
        if kUserDefaults.isTradie() {
            endpoint = EndPoint.profileTradieChangeEmail.path
        }
        ApiManager.request(methodName: endpoint, parameters: getParama(model), methodType: .put) { [weak self] result in
            guard let self = self else { return }
            CommonFunctions.hideActivityLoader()
            switch result {
            case .success( _):
                self.delegate?.success()
            case .failure(let error):
                self.delegate?.failure(message: error?.localizedDescription ?? "")
            case .noDataFound(let message):
                self.delegate?.failure(message: message)
            default:
                Console.log("Do Nothing")
            }
        }
    }
}

extension ChangeEmailVM {
    
    private func getParama(_ model: ChangeEmailModel) -> [String: Any] {
        let params: [String: Any] = [ApiKeys.currentEmail: model.currentEmail,
                                     ApiKeys.newEmail: model.newEmail.lowercased(),
                                     ApiKeys.password: model.password,
                                     ApiKeys.userType: kUserDefaults.getUserType()]
        return params
    }
}
