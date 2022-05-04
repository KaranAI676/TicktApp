//
//  TradieProfilefromBuilderVM.swift
//  Tickt
//
//  Created by S H U B H A M on 25/05/21.
//

import Foundation
import SwiftyJSON

protocol TradieProfilefromBuilderVMDelegate: AnyObject {
    
    func successSavedTradie()
    func successCancelInvite()
    func getlogginBuilder(model: BuilderProfileModel)
    func successAccpetDecline(status: AcceptDecline)
    func success(model: TradieProfilefromBuilderModel)
    func failure(message: String)
    func success(model: RepublishJobResult, jobId: String, status: String)
}

class TradieProfilefromBuilderVM: BaseVM {
    
    weak var delegate: TradieProfilefromBuilderVMDelegate? = nil
    
    func getProfileHomeTradieData(tradieId: String, jobId: String, isPullToRefresh: Bool = false) {
        var endPoint = EndPoint.jobBuilderTradieProfile.path
        if kUserDefaults.isTradie() {
            endPoint = EndPoint.tradiePublicProfile.path
        } else {
            
            endPoint = jobId.isEmpty ? EndPoint.homeTradieProfile.path : EndPoint.jobBuilderTradieProfile.path
            endPoint += "?tradieId=\(tradieId)"
            if !jobId.isEmpty {
                endPoint += "&jobId=\(jobId)"
            }
        }
        ApiManager.request(methodName: endPoint, parameters: nil, methodType: .get, showLoader: !isPullToRefresh) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                let serverResponse: TradieProfilefromBuilderModel = TradieProfilefromBuilderModel(JSON(data))
                if serverResponse.statusCode == StatusCode.success {
                    if !kUserDefaults.isTradie() {
                        TicketMoengage.shared.postEvent(eventType: .viewedTradieProfile(name:serverResponse.result.tradieName , category: serverResponse.result.tradeName, location: 78))
                    }
                    self.delegate?.success(model: serverResponse)
                } else {
                    CommonFunctions.showToastWithMessage("Something went wrong.")
                }
            case .failure(let error):
                self.delegate?.failure(message: error?.localizedDescription ?? "")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func acceptDecline(jobId: String, tradieId: String, status: AcceptDecline) {
        let params: [String : Any] = [ApiKeys.jobId: jobId, "tradieId": tradieId, "status": status.tag]
        ApiManager.request(methodName: EndPoint.jobBuilderAcceptDeclineRequest.path, parameters: params, methodType: .put) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.delegate?.successAccpetDecline(status: status)
            case .failure(let error):
                self.delegate?.failure(message: error?.localizedDescription ?? "")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func saveUnsaveTradie(tradieId: String, bool: Bool) {
        var endPoint: String = "?" + ApiKeys.tradieId + "=" + tradieId + "&"
        endPoint += ApiKeys.isSave + "=" + (bool ? "true" : "false")
        ApiManager.request(methodName: EndPoint.jobBuilderSaveTradie.path + endPoint, parameters: nil, methodType: .get) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.delegate?.successSavedTradie()
            case .failure(let error):
                self.delegate?.failure(message: error?.localizedDescription ?? "")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func cancelInvite(tradieId: String, jobId: String, invitationId: String) {
        var endPoint: String = "?" + ApiKeys.tradieId + "=" + tradieId
        endPoint += "&" + ApiKeys.jobId + "=" + jobId
        endPoint += "&" + ApiKeys.invitationId + "=" + invitationId
        ApiManager.request(methodName: EndPoint.jobBuilderCancelInviteForJob.path + endPoint, parameters: nil, methodType: .put) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.delegate?.successCancelInvite()
            case .failure(let error):
                self.delegate?.failure(message: error?.localizedDescription ?? "")
            case .noDataFound(let message):
                self.delegate?.failure(message: message)
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func getProfileInfo(isPullToRefresh: Bool = false) {
        ApiManager.request(methodName: EndPoint.profileBuilderView.path, parameters: nil, methodType: .get, showLoader: !isPullToRefresh) { [weak self] result in
            switch result {
            case .success(let data):
                 let serverResponse: BuilderProfileModel = BuilderProfileModel(JSON(data))
                    if serverResponse.statusCode == StatusCode.success {
                        self?.delegate?.getlogginBuilder(model: serverResponse)
                    } else {
                        CommonFunctions.showToastWithMessage("Something went wrong.")
                    }
                
            case .failure(let error):
                self?.delegate?.failure(message: error?.localizedDescription ?? "Unknown error")
                self?.handleFailure(error: error)
            case .noDataFound(let message):
                self?.delegate?.failure(message: message)
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func getRepublishJobDetails(jobId: String, status: String) {
        let endPoint: String = "?jobId=\(jobId)"
        ApiManager.request(methodName: EndPoint.jobRepublishJob.path + endPoint, parameters: nil, methodType: .get) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                let serverResponse: RepublishJobModel = RepublishJobModel(JSON(data))
                if serverResponse.statusCode == StatusCode.success {
                    self.delegate?.success(model: serverResponse.result, jobId: jobId, status: status)
                } else {
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
