//
//  CancelJobBuilderVM.swift
//  Tickt
//
//  Created by S H U B H A M on 02/06/21.
//

import Foundation
protocol CancelJobBuilderVMDelegate: class {
    func success()
    func failure(message: String)
}

class CancelJobBuilderVM: BaseVM {
    
    weak var delegate: CancelJobBuilderVMDelegate? = nil
    
    func cancelJob(model: CancelJobBuilderModel) {
        ApiManager.request(methodName: EndPoint.jobBuilderCancelJob.path, parameters: getParams(model), methodType: .put) { [weak self] result in
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

extension CancelJobBuilderVM {
    
    private func getParams(_ model: CancelJobBuilderModel) -> [String: Any] {
        var params = [String: Any]()
        ///
        params = [ApiKeys.jobId: model.jobId]
        if !model.note.isEmpty {
            params[ApiKeys.note] = model.note
        }
        if let type = model.reasonType {
            params[ApiKeys.reason] = type.rawValue
        }
        
        return params
    }
}
