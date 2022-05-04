//
//  SupportChatBuilderVM.swift
//  Tickt
//
//  Created by S H U B H A M on 14/07/21.
//

import Foundation

protocol SupportChatBuilderVMDelegate: AnyObject {
    
    func success()
    func failure(message: String)
}

class SupportChatBuilderVM: BaseVM {
    
    weak var delegate: SupportChatBuilderVMDelegate? = nil
    
    func supportChat(model: SupportChatBuilderModel) {

        ApiManager.request(methodName: EndPoint.profileBuilderSupport.path, parameters: getParams(model), methodType: .post) { [weak self] result in
            guard let self = self else { return }
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

extension SupportChatBuilderVM {
    
    private func getParams(_ model: SupportChatBuilderModel) -> [String: Any] {
        var params: [String: Any] = [ApiKeys.message: model.message]
        if let optionValue =  model.option?.rawValue {
            params[ApiKeys.supportType] = optionValue
        }
        return params
    }
}
