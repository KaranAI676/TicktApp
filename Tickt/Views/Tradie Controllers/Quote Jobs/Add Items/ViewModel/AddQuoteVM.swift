//
//  AddQuoteVM.swift
//  Tickt
//
//  Created by Vijay's Macbook on 23/09/21.
//

import Foundation

protocol AddQuoteDelegate: AnyObject {
    func deleteItem()
    func quoteSubmitted()
    func addItem(item: ItemDetails)
    func updateItem(item: ItemDetails)
    func didGetQuoteDetail(items: [ItemDetails])
}

class AddQuoteVM: BaseVM {
    
    weak var delegate: AddQuoteDelegate?
    
    func submitQuote(jobId: String, items: [ItemDetails], builderId: String, tradeId: String, specializationId: String, isInvited: Bool,jobDetail:JobDetailsData?) {
        let total = items.map {$0.totalAmount}.reduce(0, +)
        let itemArray = items.compactMap { item -> JSONDictionary in
            return [ApiKeys.price: item.price,
                    ApiKeys.quantity: item.quantity,
                    ApiKeys.itemNumber: item.itemNumber,
                    ApiKeys.totalAmount: item.totalAmount,
                    ApiKeys.description: item.description]
        }
        let param: JSONDictionary = [ApiKeys.jobId: jobId,
                                     ApiKeys.userId: kUserDefaults.getUserId(),
                                     ApiKeys.amount: total,
                                     ApiKeys.quoteItem: itemArray]
        ApiManager.request(methodName: EndPoint.addQuote.path, parameters: param, methodType: .post) { [weak self] result in
            switch result {
            case .success(let data):
                if let serverResponse: GenericResponse = self?.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        TicketMoengage.shared.postEvent(eventType: .quotedAJob(timestamp: "", category: jobDetail?.tradeName ?? "", location: jobDetail?.locationName ?? "", numberOfMilestones: jobDetail?.milestoneNumber ?? 0, amount: total))
                        if isInvited {
                            self?.delegate?.quoteSubmitted()
//                            self?.acceptDeclineJob(builderId: builderId, jobId: jobId, isAccept: true)
                        } else {
                            self?.applyJob(builderId: builderId, jobId: jobId, tradeId: tradeId, specializationId: specializationId)
                        }
                    } else {
                        CommonFunctions.showToastWithMessage("Something went wrong.")
                    }
                }
            case .failure(let error):
                self?.handleFailure(error: error)
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
                        self?.delegate?.quoteSubmitted()
                    } else {
                        self?.handleFailure(error: NSError(localizedDescription: serverResponse.message))
                    }
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func applyJob(builderId: String, jobId: String, tradeId: String, specializationId: String) {
        let param = [ApiKeys.jobId: jobId,
                     ApiKeys.tradeId: tradeId,
                     ApiKeys.builderId: builderId,
                     ApiKeys.specializationId: specializationId]
        ApiManager.request(methodName: EndPoint.applyJob.path, parameters: param, methodType: .post) { [weak self] result in
            switch result {
            case .success(_):
                NotificationCenter.default.post(name: NotificationName.refreshAppliedList, object: nil, userInfo: nil)
                self?.delegate?.quoteSubmitted()
            case .failure(let error):
                self?.handleFailure(error: error)
            default:
                Console.log("Do Nothing")
            }
        }
    }

    func deleteItem(itemId: String) {
        ApiManager.request(methodName: EndPoint.deleteItem.path, parameters: [ApiKeys.itemId: itemId], methodType: .put) { [weak self] result in
            switch result {
            case .success(let data):
                if let serverResponse: GenericResponse = self?.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        self?.delegate?.deleteItem()
                    } else {
                        CommonFunctions.showToastWithMessage("Something went wrong.")
                    }
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func updateItem(item: ItemDetails) {
        let param: JSONDictionary = [ApiKeys.itemId: item.id,
                                     ApiKeys.price: item.price,
                                     ApiKeys.quantity: item.quantity,
                                     ApiKeys.itemNumber: item.itemNumber,
                                     ApiKeys.totalAmount: item.totalAmount,
                                     ApiKeys.description: item.description]
        ApiManager.request(methodName: EndPoint.updateItem.path, parameters: param, methodType: .put) { [weak self] result in
            switch result {
            case .success(let data):
                if let serverResponse: GenericResponse = self?.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        self?.delegate?.updateItem(item: item)
                    } else {
                        CommonFunctions.showToastWithMessage("Something went wrong.")
                    }
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func addItem(item: ItemDetails, quoteId: String) {
        let param: JSONDictionary = [ApiKeys.itemId: item.id,
                                     ApiKeys.quoteId: quoteId,
                                     ApiKeys.price: item.price,
                                     ApiKeys.quantity: item.quantity,
                                     ApiKeys.itemNumber: item.itemNumber,
                                     ApiKeys.totalAmount: item.totalAmount,
                                     ApiKeys.description: item.description]
        ApiManager.request(methodName: EndPoint.addItem.path, parameters: param, methodType: .post) { [weak self] result in
            switch result {
            case .success(let data):
                if let serverResponse: AddItemModel = self?.handleSuccess(data: data) {
                    self?.delegate?.addItem(item: serverResponse.result.resultData)
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            default:
                Console.log("Do Nothing")
            }
        }
    }

    func getQuoteDetail(jobId: String) {
        let queryParam = "?\(ApiKeys.jobId)=\(jobId)&\(ApiKeys.tradeId)=\(kUserDefaults.getUserId())"
        ApiManager.request(methodName: EndPoint.quoteListing.path + queryParam, parameters: nil, methodType: .get) { [weak self] result in
            switch result {
            case .success(let data):
                if let serverResponse: MyQuoteModel = self?.handleSuccess(data: data) {
                    self?.delegate?.didGetQuoteDetail(items: serverResponse.result.resultData.first?.quoteItem ?? [])
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            default:
                Console.log("Do Nothing")
            }
        }
    }
}
