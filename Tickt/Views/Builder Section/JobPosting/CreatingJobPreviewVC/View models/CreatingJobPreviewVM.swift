//
//  CreatingJobPreviewVM.swift
//  Tickt
//
//  Created by S H U B H A M on 31/03/21.
//

import Foundation
import SwiftyJSON

protocol CreatingJobPreviewVMDelegate: AnyObject {
    func success()
    func didJobApplied()
    func failure(error: String)
    func didJobSaved(status: Bool)
    func didAcceptRejectChangeRequest()
    func didJobAcceptedRejected(isReject: Bool)
    func openJobDetails(model: JobDetailsModel)
    func didGetJobDetail(model: JobDetailsModel)
    func didAcceptCancelChangeRequest(status: AcceptDecline)
}

class CreatingJobPreviewVM: BaseVM {
    
    weak var delegate: CreatingJobPreviewVMDelegate?
  
    func getJobDetails(jobId: String, tradeId: String, specializationId: String, screenType: ScreenType) {
        var endPoint = screenType == .activeJobDetail ? EndPoint.activeJobDetails.path : EndPoint.jobDetails.path         
        endPoint += "?\(ApiKeys.jobId)=\(jobId)"
        ApiManager.request(methodName: endPoint, parameters: nil, methodType: .get) { [weak self] result in
            switch result {
            case .success(let data):
                 let serverResponse: JobDetailsModel = JobDetailsModel(JSON(data))
                    if serverResponse.statusCode == StatusCode.success {
                        self?.delegate?.didGetJobDetail(model: serverResponse)
                    } else {
                        self?.delegate?.failure(error: "Something went wrong")
                    }
            case .failure(let error):
                self?.delegate?.failure(error: error?.localizedDescription ?? "Unknown")
            default:
                Console.log("Do Nothing")
            }
        }
    }

    func saveJob(status: Bool, jobId: String, tradeId: String, specializationId: String) {
        var endPoint = EndPoint.saveJob.path
        endPoint += "?\(ApiKeys.jobId)=\(jobId)"
        endPoint += "&\(ApiKeys.isSave)=\((!status).description)"
        ApiManager.request(methodName: endPoint, parameters: nil, methodType: .get) { [weak self] result in
            switch result {
            case .success(_):
                self?.delegate?.didJobSaved(status: status)
            case .failure(let error):
                self?.delegate?.failure(error: error?.localizedDescription ?? "Something went wrong!")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func applyJob(builderId: String, jobId: String, tradeId: String, specializationId: String) {
        let param = [ApiKeys.jobId: jobId,
                     ApiKeys.tradeId: tradeId,
                     ApiKeys.builderId: builderId,
                     ApiKeys.specializationId: builderId]
        ApiManager.request(methodName: EndPoint.applyJob.path, parameters: param, methodType: .post) { [weak self] result in
            switch result {
            case .success(_):
                NotificationCenter.default.post(name: NotificationName.refreshAppliedList, object: nil, userInfo: nil)
                self?.delegate?.didJobApplied()
            case .failure(let error):
                self?.delegate?.failure(error: error?.localizedDescription ?? "Something went wrong!")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func acceptDeclineCancelRequest(jobId: String, status: AcceptDecline, note: String) {
        let param: [String: Any] = [ApiKeys.note: note,
                                    ApiKeys.jobId: jobId,
                                    ApiKeys.status: status.tag]
        ApiManager.request(methodName: EndPoint.replyCancelRequest.path, parameters: param, methodType: .post) { [weak self] result in
            switch result {
            case .success(let data):
                if let serverResponse: GenericResponse = self?.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        self?.delegate?.didAcceptCancelChangeRequest(status: status)
                    } else {
                        self?.delegate?.failure(error: "Something went wrong")
                    }
                }
            case .failure(let error):
                self?.delegate?.failure(error: error?.localizedDescription ?? "Something went wrong!")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func acceptDeclineChangeRequest(jobId: String, isAccept: Int, note: String) {
        let param: [String: Any] = [ApiKeys.note: note,
                                    ApiKeys.jobId: jobId,
                                    ApiKeys.status: isAccept]
        ApiManager.request(methodName: EndPoint.replyChangeRequest.path, parameters: param, methodType: .post) { [weak self] result in
            switch result {
            case .success(let data):
                if let serverResponse: GenericResponse = self?.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        self?.delegate?.didAcceptRejectChangeRequest()
                    } else {
                        self?.delegate?.failure(error: "Something went wrong")
                    }
                }
            case .failure(let error):
                self?.delegate?.failure(error: error?.localizedDescription ?? "Something went wrong!")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func acceptDeclineJob(builderId: String, jobId: String, isAccept: Bool) {
        let param: [String: Any] = [ApiKeys.jobId: jobId,
                                    ApiKeys.isAccept: isAccept,
                                    ApiKeys.builderId: builderId]
        ApiManager.request(methodName: EndPoint.acceptRejectInvitaion.path, parameters: param, methodType: .put) { [weak self] result in
            switch result {
            case .success(let data):
                if let serverResponse: GenericResponse = self?.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        self?.delegate?.didJobAcceptedRejected(isReject: isAccept)
                    } else {
                        self?.delegate?.failure(error: "Something went wrong")
                    }
                }                
            case .failure(let error):
                self?.delegate?.failure(error: error?.localizedDescription ?? "Something went wrong!")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func postJobApi() {
        
        guard let model = kAppDelegate.postJobModel else {
            CommonFunctions.showToastWithMessage("Something went wrong!")
            return
        }
        
        let methodName = (kAppDelegate.postJobModel?.jobId ?? "").isEmpty ? EndPoint.jobCreate.path : EndPoint.jobBuilderPublishJobAgain.path
        
        ApiManager.request(methodName: methodName, parameters: self.getParams(model: model), methodType: .post) { [weak self] result in
            switch result {
            case .success(_):
                TicketMoengage.shared.postEvent(eventType: .postedaJob(timestamp: "", category:model.categories?.tradeName ?? "", location: model.jobLocation.locationName , numberOfMilestones: model.milestones.count , startDate: model.fromDate.date ?? Date(), endDate: model.toDate.date ?? Date()))
                self?.delegate?.success()
            case .failure(let error):
                self?.delegate?.failure(error: error?.localizedDescription ?? "Something went wrong!")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func updateJobApi() {
        
        guard let model = kAppDelegate.postJobModel else {
            CommonFunctions.showToastWithMessage("Something went wrong!")
            return
        }
        
        let methodName = EndPoint.jobUpdate.path
        
        ApiManager.request(methodName: methodName, parameters: self.getParams(model: model), methodType: .put) { [weak self] result in
            switch result {
            case .success(_):
                self?.delegate?.success()
            case .failure(let error):
                self?.delegate?.failure(error: error?.localizedDescription ?? "Something went wrong!")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func republishJob() {
        
        guard let model = kAppDelegate.postJobModel else {
            CommonFunctions.showToastWithMessage("Something went wrong!")
            return
        }
        
        ApiManager.request(methodName: EndPoint.jobCreate.path, parameters: self.getParams(model: model), methodType: .post) { [weak self] result in
            switch result {
            case .success(_):
                self?.delegate?.success()
            case .failure(let error):
                self?.delegate?.failure(error: error?.localizedDescription ?? "Something went wrong!")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func getOpenJobDetails(jobId: String, tradieId: String, specialisationId: String) {
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
}

extension CreatingJobPreviewVM {
    
    private func getParams(model: CreateJobModel) -> [String:Any] {
        var parameters = [String:Any]()
        
        parameters["jobName"] = model.jobName.capitalized
        parameters["categories"] = [model.categories?.id]
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
