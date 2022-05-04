//
//  CreateJobVM.swift
//  Tickt
//
//  Created by Admin on 27/03/21.
//

import Foundation
import SwiftyJSON

protocol CreateJobVMDelegate: AnyObject {
    func success(data: TradeModel)
    func success(data: JobTypeModel)
    func failure(error: String)
}

class CreateJobVM: BaseVM {
    
    weak var delegate: CreateJobVMDelegate?
    
    func getTradeList() {
        if let model = kAppDelegate.tradeModel {
            self.delegate?.success(data: model)
        } else {
            ApiManager.request(methodName: EndPoint.tradeList.path, parameters: nil, methodType: .get) { [weak self] result in
                switch result {
                case .success(let data):
                     let serverResponse: TradeModel = TradeModel(JSON(data))
                        if serverResponse.statusCode == StatusCode.success {
                            kAppDelegate.tradeModel = serverResponse
                            self?.delegate?.success(data: serverResponse)
                        } else {
                            CommonFunctions.showToastWithMessage("Something went wrong.")
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
    
    func getJobTypeList() {
        ApiManager.request(methodName: EndPoint.jobTypeList.path, parameters: nil, methodType: .get) { [weak self] result in
            switch result {
            case .success(let data):
                if let serverResponse: JobTypeModel = self?.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        self?.delegate?.success(data: serverResponse)
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
