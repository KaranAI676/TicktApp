//
//  LeaveVoucheBuilderVM.swift
//  Tickt
//
//  Created by S H U B H A M on 20/06/21.
//

import Foundation
import SwiftyJSON

protocol LeaveVoucheBuilderVMDelegate: class {
    
    func didGetJobsSuccess(model: JobListingBuilderModel)
    func success(model: VouchAddedModel)
    func failure(message: String)
}

class LeaveVoucheBuilderVM: BaseVM {
    
    weak var delegate: LeaveVoucheBuilderVMDelegate? = nil
    
    func addVouch(model: LeaveVouchBuilderModel) {
        
        if let recommendedModel = model.recommendation, let url = URL(string: recommendedModel.finalUrl) {
            do {
                let data = try (Data(contentsOf:  url), recommendedModel.mimeType)
                let params = [ApiKeys.file: [data]]
                uploadImages(params: params, completion: { recommendationUrl in
                    self.addVouchHit(params: self.getParams(model, recommendationUrl: recommendationUrl))
                })
            } catch  {
                printDebug("Document uploading error...")
            }
        }else {
            addVouchHit(params: self.getParams(model))
        }
    }
    
    func getJobList(tradieId: String, page: Int = 1) {
        
        var endPoints = "?" + ApiKeys.page + "=" + "\(page)"
        endPoints += "&" + ApiKeys.tradieId + "=" + tradieId
        
        ApiManager.request(methodName: EndPoint.jobBuilderVouchesJob.path + endPoints, parameters: nil, methodType: .get) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                if let serverResponse: JobListingBuilderModel = self.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        self.delegate?.didGetJobsSuccess(model: serverResponse)
                    } else {
                        self.delegate?.failure(message: "")
                        CommonFunctions.showToastWithMessage("Something went wrong.")
                    }
                }else {
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
}

extension LeaveVoucheBuilderVM {
    
    func addVouchHit(params: [String: Any]) {
        
        ApiManager.request(methodName: EndPoint.jobBuilderAddVoucher.path, parameters: params, methodType: .post) { [weak self] result in
            guard let self = self else { return }
            CommonFunctions.hideActivityLoader()
            switch result {
            case .success(let data):
                 let serverResponse: VouchAddedModel = VouchAddedModel(JSON(data))
                    if serverResponse.statusCode == StatusCode.success {
                        self.delegate?.success(model: serverResponse)
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
    
    private func uploadImages(params: [String: Any], completion: @escaping (String)->() ) {
        
        ApiManager.uploadRequest(methodName: EndPoint.uploadDocument.path, parameters: params, methodType: .post, showLoader: true, result: { [weak self] result in
            guard let self = self else { return }
            ///
            switch result {
            case .success(let data):
                 let serverResponse: DocumentModel = DocumentModel(JSON(data))
                    if serverResponse.statusCode == StatusCode.success {
                        if let url = serverResponse.result?.url?.first {
                            completion(url)
                        }
                    } else {
                        CommonFunctions.showToastWithMessage("Failed to upload images")
                        CommonFunctions.hideActivityLoader()
                    }
            
            case .failure(let error):
                self.delegate?.failure(message: error?.localizedDescription ?? "Unknown error")
            default:
                Console.log("Do Nothing")
                CommonFunctions.hideActivityLoader()
            }
        }, onProgress: { (progress) in
            print(progress)
        })
    }
}

//MARK:- Get formatted Params
//===========================
extension LeaveVoucheBuilderVM {
    
    private func getParams(_ model: LeaveVouchBuilderModel, recommendationUrl: String = "") -> [String: Any] {
        var params = [String: Any]()
        ///
        params = [ApiKeys.jobId: model.jobId,
                  ApiKeys.jobName: model.jobName,
                  ApiKeys.tradieId: model.tradieId,
                  ApiKeys.vouchDescription: model.vouchText,
                  ApiKeys.recommendation: "This is recommendation url"]
        
        
        if !recommendationUrl.isEmpty {
            params[ApiKeys.recommendation] = recommendationUrl
        }
        
        return params
    }
}
