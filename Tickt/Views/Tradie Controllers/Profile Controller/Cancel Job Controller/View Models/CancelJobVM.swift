//
//  CancelJobVM.swift
//  Tickt
//
//  Created by Vijay's Macbook on 22/06/21.
//

import Foundation

protocol CancelJobDelegate: AnyObject {
    func success()
    func failure(message: String)
}

class CancelJobVM: BaseVM {
    weak var delegate: CancelJobDelegate?
    
    func cancelJobService(param: [String: Any]) {
        ApiManager.request(methodName: EndPoint.cancelJob.path, parameters: param, methodType: .put) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success( _):
                self.delegate?.success()
            case .failure(let error):
                self.delegate?.failure(message: error?.localizedDescription ?? "Unknown")
            default:
                Console.log("Do Nothing")
            }
        }
    }
}
