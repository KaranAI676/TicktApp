//
//  MilestoneListingVM.swift
//  Tickt
//
//  Created by S H U B H A M on 15/06/21.
//

import Foundation

protocol MilestoneListingVMDelegate: AnyObject {
    
    func successEditTemplate()
    func successEditMilestone()
    func failure(message: String)
}

class MilestoneListingVM: BaseVM {
    
    weak var delegate: MilestoneListingVMDelegate? = nil
    
    func editMilestone(jobId: String, tradieId: String, model: [MilestoneModel], deletedModel: [MilestoneModel], isRearranged: Bool = false, addedNewMilestone: Bool = false) {
        let params = getParams(jobId: jobId, tradieId: tradieId, model: model, deletedModel: deletedModel, isRearranged: isRearranged, addedNewMilestone: addedNewMilestone)
        ///
        ApiManager.request(methodName: EndPoint.jobBuilderChangeRequest.path, parameters: params, methodType: .post) { [weak self] result in
            switch result {
            case .success( _):
                self?.delegate?.successEditMilestone()
            case .failure(let error):
                self?.delegate?.failure(message: error?.localizedDescription ?? "Something went wrong!")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func editTemplates(templateId: String, templateName:String, model: [MilestoneModel]) {
        
        var params: [String: Any] = [ApiKeys.templateId: templateId,
                                     ApiKeys.templateName: templateName]
        
        params[ApiKeys.milestones] = model.map({ eachModel -> [String: Any] in
            getMilestoneParamObject(eachModel)
        })
        
        ApiManager.request(methodName: EndPoint.jobEditTemplate.path, parameters: params, methodType: .put) { [weak self] result in
            switch result {
            case .success( _):
                self?.delegate?.successEditTemplate()
            case .failure(let error):
                self?.delegate?.failure(message: error?.localizedDescription ?? "Something went wrong!")
            default:
                Console.log("Do Nothing")
            }
        }
    }
}

extension MilestoneListingVM {
    
    private func getParams(jobId: String, tradieId: String, model: [MilestoneModel], deletedModel: [MilestoneModel], isRearranged: Bool, addedNewMilestone: Bool) -> [String: Any] {
        var params: [String: Any] = [ApiKeys.jobId: jobId,
                                     ApiKeys.tradieId: tradieId]
        /// Changed the order
        var orderedModel = model
        for i in 0..<orderedModel.count {
            orderedModel[i].order = i+1
        }
        ///
        let milestoneEditObjects = orderedModel.compactMap({ eachModel -> [String: Any]? in
            if let milestoneStatus = eachModel.status, let status = MilestoneStatus.init(rawValue: milestoneStatus), (status == .changeRequest || status == .notComplete) {
                if isRearranged {
                    return getMilestoneParamObject(eachModel)
                } else if !isRearranged, (eachModel.isEdit ?? false) {
                    return getMilestoneParamObject(eachModel)
                } else {
                    return nil
                }
            } else if eachModel.status.isNil {
                return getMilestoneParamObject(eachModel)
            } else {
                return nil
            }
        })
        let milestoneDeletedObjects = deletedModel.map({ eachModel -> [String: Any]? in
            return getMilestoneParamObject(eachModel, forDelete: true)
        })
        ///
        params[ApiKeys.milestones] = milestoneEditObjects + milestoneDeletedObjects
        params[ApiKeys.description] = getMilestoneDescription(deletedModel: deletedModel,
                                                              addedMilestoneModel: orderedModel.filter({$0.status.isNil}),
                                                              updatedMilestoneModel: orderedModel.filter({$0.status.isNotNil && ($0.isEdit ?? false)}),
                                                              isRearranged: isRearranged)
        return params
    }
    
    private func getMilestoneParamObject(_ eachModel: MilestoneModel, forDelete: Bool = false) -> [String: Any] {
        var temp: [String: Any] = [ApiKeys.MilestoneUnderScoreName: eachModel.milestoneName,
                                   ApiKeys.isPhotoevidence: eachModel.isPhotoevidence,
                                   ApiKeys.fromDate: eachModel.fromDate.backendFormat,
                                   ApiKeys.recommendedUnderScoreHours: eachModel.recommendedHours,
                                   ApiKeys.order: eachModel.order]
        
        if forDelete {
            temp[ApiKeys.isDeleteRequest] = true
        }
        if !eachModel.toDate.backendFormat.isEmpty {
            temp[ApiKeys.toDate] = eachModel.toDate.backendFormat
        }
        if !((eachModel.milestoneId ?? "").isEmpty) {
            temp[ApiKeys.milestoneId] = eachModel.milestoneId ?? ""
        }
        return temp
    }
    
    private func getMilestoneDescription(deletedModel: [MilestoneModel], addedMilestoneModel: [MilestoneModel], updatedMilestoneModel: [MilestoneModel], isRearranged: Bool) -> [String] {
        
        var descriptionString = [String]()
        
        let _ = deletedModel.map({ eachModel in
            descriptionString.append("\(eachModel.milestoneName) milestone is deleted.")
        })
        
        let _ = addedMilestoneModel.map({ eachModel in
            descriptionString.append("\(eachModel.milestoneName) milestone is added.")
        })
        
        let _ = updatedMilestoneModel.map({ eachModel in
            descriptionString.append("\(eachModel.milestoneName) milestone details are updated.")
        })
        
        if isRearranged {
            descriptionString.append(CRMessages.rearranged.rawValue)
        }
        
        return descriptionString
    }
}
