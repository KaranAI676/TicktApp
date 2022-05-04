//
//  CommonJobDetailsVM.swift
//  Tickt
//
//  Created by S H U B H A M on 21/05/21.
//

import Foundation
import SwiftyJSON


protocol CommonJobDetailsVMDelegate: AnyObject {
    
    func republishSuccess(model: RepublishJobResult)
    func cancelRequestSuccess(status: AcceptDecline)
    func failure(error: String)
    func openJobDetails(model: JobDetailsModel)
    func deleteJob(status:Bool,index:IndexPath)
    func closeJob(msg:String)
    func openJobSucess()
}


extension CommonJobDetailsVMDelegate{
    func deleteJob(status:Bool,index:Int){}
    func closeJob(msg:String){}
    func openJobSucess(){}
}


class CommonJobDetailsVM: BaseVM {
    
    weak var delegate: CommonJobDetailsVMDelegate?
    
    func getOpenJobDetails(jobId: String) {
        let endParams: String = "?jobId=\(jobId)"
        ApiManager.request(methodName: EndPoint.openJobDetails.path + endParams, parameters: nil, methodType: .get) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                let serverResponse: JobDetailsModel = JobDetailsModel(JSON(data))
                if serverResponse.statusCode == StatusCode.success {
                    self.delegate?.openJobDetails(model: serverResponse)
                } else {
                    self.delegate?.failure(error: "Something went wrong")
                }
            case .failure(let error):
                self.delegate?.failure(error: error?.localizedDescription ?? "Unknown")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func getRepublishJobDetails(jobId: String) {
        let endPoint: String = "?jobId=\(jobId)"
        ApiManager.request(methodName: EndPoint.jobRepublishJob.path + endPoint, parameters: nil, methodType: .get) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                 let serverResponse: RepublishJobModel = RepublishJobModel(JSON(data))
                    if serverResponse.statusCode == StatusCode.success {
                        self.delegate?.republishSuccess(model: serverResponse.result)
                    } else {
                        CommonFunctions.showToastWithMessage("Something went wrong.")
                    }
            case .failure(let error):
                self.delegate?.failure(error: error?.localizedDescription ?? "")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    
    func acceptRejectCancelRequest(jobId: String, status: AcceptDecline, note: String? = nil) {
        
        let params: [String: Any] = [ApiKeys.jobId: jobId,
                                     ApiKeys.status: status.tag,
                                     ApiKeys.note: note ?? status.statusDesc]
        
        ApiManager.request(methodName: EndPoint.jobBuilderReplyCancellation.path, parameters: params, methodType: .post) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                let serverResponse: JobDetailsModel = JobDetailsModel(JSON(data))
                if serverResponse.statusCode == StatusCode.success {
                    self.delegate?.cancelRequestSuccess(status: status)
                } else {
                    self.delegate?.failure(error: "Something went wrong")
                }
            case .failure(let error):
                self.delegate?.failure(error: error?.localizedDescription ?? "Unknown")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    //MARK:- DELETING THE QUOTE
    //=========================
    func deleteQuote(jobId: String,index:IndexPath) {
        var param = JSONDictionary()
        param[ApiKeys.jobId] = jobId
        ApiManager.request(methodName: EndPoint.removeQuoteJob.path+"?\(ApiKeys.jobId)=\(jobId)" , parameters: nil, methodType: .delete) { [weak self] result in
            //       ApiManager.request(methodName: EndPoint.cancelOpenJob.path , parameters: param, methodType: .put) { [weak self] result in
            switch result {
            case .success(let data):
                if let serverResponse: GenericResponse = self?.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        self?.delegate?.deleteJob(status: serverResponse.status, index: index)
                    }
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func getOpenQuoteJobDetails(jobId: String) {
        let endParams: String = "?jobId=\(jobId)"
        ApiManager.request(methodName: EndPoint.openQuoteJobDetails.path + endParams, parameters: nil, methodType: .get) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                 let serverResponse: RepublishQuoteJobModel = RepublishQuoteJobModel(JSON(data))
                    if serverResponse.statusCode == StatusCode.success {
                        self.delegate?.republishSuccess(model: serverResponse.result.resultData)
                    } else {
                        self.delegate?.failure(error: "Something went wrong")
                    }
            case .failure(let error):
                self.delegate?.failure(error: error?.localizedDescription ?? "Unknown")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func closeThejob(jobId: String, tradieID:String) {
        var params = JSONDictionary()
        params[ApiKeys.jobId] = jobId
        params[ApiKeys.tradieId] = tradieID
        //+"?\(ApiKeys.jobId)=\(jobId)&\(ApiKeys.tradieId)=\(tradieID)
        ApiManager.request(methodName: EndPoint.closeTheJob.path , parameters: params, methodType: .put) { [weak self] result in
            switch result {
            case .success(let data):
                if let serverResponse: GenericResponse = self?.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        self?.delegate?.closeJob(msg: serverResponse.message)
                    }
                }
            case .failure(let error):
                self?.delegate?.failure(error: error?.localizedDescription ?? "Something went wrong!")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func republishCloseJob(dataModel:RepublishJobResult,jobID:String) {
        let createJobModel = CreateJobModel(model: dataModel)
        kAppDelegate.postJobModel = createJobModel
        guard let model = kAppDelegate.postJobModel else {
            CommonFunctions.showToastWithMessage("Something went wrong!")
            return
        }
        
        ApiManager.request(methodName: EndPoint.jobBuilderPublishJobAgain.path, parameters: self.getParams(model: model,jobID:jobID), methodType: .post) { [weak self] result in
            switch result {
            case .success(_):
                self?.delegate?.openJobSucess()
            case .failure(let error):
                self?.delegate?.failure(error: error?.localizedDescription ?? "Something went wrong!")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    private func getParams(model: CreateJobModel,jobID:String) -> [String:Any] {
        var parameters = [String:Any]()
        parameters[ApiKeys.jobId] = jobID
        parameters["jobName"] = model.jobName.capitalized
        parameters["categories"] = [model.republishCategories?.categoryId]
        parameters["job_type"] = model.jobType.map({ eachModel -> String in
            return eachModel.id
        })
        parameters["specialization"] = model.specialisation?.map({ eachModel -> String in
            return eachModel.id
        })
        parameters["location_name"] = model.jobLocation.locationName
        parameters["job_description"] = model.jobDescription
        parameters["from_date"] = model.fromDate.backendFormat
        if !model.toDate.backendFormat.isEmpty {
            parameters["to_date"] = model.toDate.backendFormat
        }
        if !model.mediaUrls.isEmpty {
            let urlsParmas = model.mediaUrls.map({ eachModel -> [String: Any] in
                if eachModel.mediaType == .video {
                    return ["mediaType": eachModel.mediaType.rawValue, "link": eachModel.mediaLink, "thumbnail": eachModel.thumbnail ?? ""]
                }else {
                    return ["mediaType": eachModel.mediaType.rawValue, "link": eachModel.mediaLink]
                }
            })
            parameters["urls"] = urlsParmas
        }
        /// Milestones
        let milestones = model.milestones.map({ eachModel -> [String: Any] in
            var object: [String: Any] = ["milestone_name": eachModel.milestoneName,
                                         "isPhotoevidence": eachModel.isPhotoevidence,
                                         "recommended_hours": eachModel.recommendedHours,
                                         "order": eachModel.order]
            if !eachModel.fromDate.backendFormat.isEmpty {
                object["from_date"] = eachModel.fromDate.backendFormat
            }
            if !eachModel.toDate.backendFormat.isEmpty {
                object["to_date"] = eachModel.toDate.backendFormat
            }
            return object
        })
        parameters["milestones"] = milestones
        
        /// Location
        parameters["location"] = ["type": "Point", "coordinates": [model.jobLocation.locationLong, model.jobLocation.locationLat]]
        
        if !model.jobId.isEmpty {
            parameters[ApiKeys.jobId] = model.jobId
        }
        
        if model.isQuoteJob {
            parameters["quoteJob"] = "1"
            parameters["pay_type"] = ""
            parameters["amount"] = "0"
        } else {
            parameters["quoteJob"] = "0"
            parameters["pay_type"] = model.paymentType.rawValue
            parameters["amount"] = model.paymentAmount
        }
        return parameters
    }
}
