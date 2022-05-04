//
//  AddBankVM.swift
//  Tickt
//
//  Created by Appinventiv on 03/01/22.
//

import Foundation
struct ClientSecret : Codable {
    var clientSecret:String?
}

protocol AddBankVMDelegate: AnyObject {
    func success(key: String)
    func failure(error: String)
}


class AddBankVM {
    
    weak var delegate:AddBankVMDelegate?
    
    func getPaymentCreateClientSecretKey(data:ApproveDeclineMilestoneModel) {
        ApiManager.request(methodName: EndPoint.payment_createClientSecretKey.path, parameters: [ApiKeys.amount: data.milestoneData.milestoneAmount.replace(string: "$", withString: ""),ApiKeys.tradieId: data.tradieId,ApiKeys.builderId: kUserDefaults.getUserId(),ApiKeys.jobId: data.jobId,ApiKeys.milestoneId: data.milestoneData.milestoneId], methodType: .post, showLoader: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                if let dict = data as? [String:Any] {
                    if let result = dict["result"] as? [String:Any] {
                        self.delegate?.success(key: result["clientSecret"] as? String ?? "")
                    }
                }
               break
            case .failure(let error):
                Console.log(error?.localizedDescription)
            default:
                Console.log("Do Nothing")
            }
        }
    }
}
