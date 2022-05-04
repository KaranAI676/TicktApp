//
//  PaymentViewMode.swift
//  Tickt
//
//  Created by Vijay's Macbook on 19/05/21.
//


import SwiftyJSON

protocol AddBankAccountDelegates: AnyObject {
    func failure(error: String)
    func didDeletedBankAccount()
    func didGetBankAccount(model: BankModel)
    func didMilestoneCompleted(jobCount: Int)
    func didAddedBankAccount(model: BankModel)
}

class PaymentDetailVM: BaseVM {
    
    weak var delegate: AddBankAccountDelegates?
    
    func getBankDetails() {
        ApiManager.request(methodName: EndPoint.getBankDetails.path , parameters: nil, methodType: .get) { [weak self] result in
            switch result {
            case .success(let data):
                if let serverResponse: BankModel = self?.handleSuccess(data: data) {
                    self?.delegate?.didGetBankAccount(model: serverResponse)
                }
            case .failure(let error):
                self?.delegate?.failure(error: error?.localizedDescription ?? "Unknown error")
                self?.handleFailure(error: error)
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func addBankAccount(param: JSONDictionary, isEdit: Bool) {
        let endPoint = isEdit ? EndPoint.updateBankDetails.path : EndPoint.addBankDetails.path
        ApiManager.request(methodName: endPoint, parameters: param, methodType: isEdit ? .put : .post) { [weak self] result in
            switch result {
            case .success(let data):
                if let serverResponse: BankModel = self?.handleSuccess(data: data) {
                    CommonFunctions.showToastWithMessage(serverResponse.message)
                    self?.delegate?.didAddedBankAccount(model: serverResponse)
                }
            case .failure(let error):
                self?.delegate?.failure(error: error?.localizedDescription ?? "Unknown error")
                self?.handleFailure(error: error)
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func deleteBankAccount() {
        ApiManager.request(methodName: EndPoint.deleteBankDetails.path , parameters: nil, methodType: .delete) { [weak self] result in
            switch result {
            case .success(let data):
                if let _: GenericResponse = self?.handleSuccess(data: data) {
                    self?.delegate?.didDeletedBankAccount()
                }
            case .failure(let error):
                self?.delegate?.failure(error: error?.localizedDescription ?? "Unknown error")
                self?.handleFailure(error: error)
            default:
                Console.log("Do Nothing")
            }
        }
    }

    func uploadImages() {
        
        if MilestoneVC.milestoneData.isPhotoEvidence {
            let imageArray = MilestoneVC.milestoneData.photo.map { eachModel -> (Data, MimeTypes) in
                return(eachModel.jpegData(compressionQuality: 0.5) ?? Data(), .imageJpeg)
            }
            ApiManager.uploadRequest(methodName: EndPoint.uploadDocument.path, parameters: [ApiKeys.file: imageArray], methodType: .post, showLoader: true, result: { [weak self] result in
                switch result {
                case .success(let data):
                     let serverResponse: DocumentModel = DocumentModel(JSON(data))
                        if serverResponse.statusCode == StatusCode.success {
                            self?.completeMilestone(fileUrls: serverResponse.result?.url ?? [])
                        } else {
                            CommonFunctions.showToastWithMessage("Failed to upload images")
                        }
                case .failure(let error):
                    self?.delegate?.failure(error: error?.localizedDescription ?? "Unknown error")
                    self?.handleFailure(error: error)
                default:
                    Console.log("Do Nothing")
                }
            }, onProgress: { (progress) in
                print(progress)
            })
        } else {
            completeMilestone()
        }
    }
    
    func completeMilestone(fileUrls: [String] = []) {
        var param: [String: Any] = [:]
        param[ApiKeys.jobId] = MilestoneVC.milestoneData.jobId
        param[ApiKeys.milestoneId] = MilestoneVC.milestoneData.milestoneId
        param[ApiKeys.actualHours] = MilestoneVC.milestoneData.actualHours
        param[ApiKeys.totalAmount] = String.getString(MilestoneVC.milestoneData.totalAmount)
        
        if !fileUrls.isEmpty {
            var evidenceArray: [JSONDictionary] = []
            for url in fileUrls {
                let object: [String: Any] = [ApiKeys.mediaType: MediaTypes.image.rawValue,
                              ApiKeys.link: url]
                evidenceArray.append(object)
            }
            param[ApiKeys.evidence] = evidenceArray
            param[ApiKeys.description] = MilestoneVC.milestoneData.description
        }
        ApiManager.request(methodName: EndPoint.completeMilestone.path , parameters: param, methodType: .post) { [weak self] result in
            switch result {
            case .success(let data):
                if let serverResponse: CompleteMilestone = self?.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        TicketMoengage.shared.postEvent(eventType: .milestoneCompleted(category: MilestoneVC.recommmendedJob.tradeName ?? "", timestamp: "", milestoneNumber: MilestoneVC.recommmendedJob.milestoneNumber ?? 0))
                        self?.delegate?.didMilestoneCompleted(jobCount: serverResponse.result.jobCompletedCount)
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
