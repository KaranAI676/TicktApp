//
//  SaveTemplateVM.swift
//  Tickt
//
//  Created by S H U B H A M on 24/03/21.
//

import Foundation

protocol SaveTemplateVMDelegate: class {
    func success()
    func failure(error: String)
}

class SaveTemplateVM: BaseVM {
    
    weak var delegate: SaveTemplateVMDelegate? = nil
    
    func saveTemplate(templateName: String, milestoneArray: [MilestoneModel]) {
        
        var milestoneArrayOfDict = [[String: Any]]()
        let _ = milestoneArray.map({ eachObject in
            var dict = [String: Any]()
            dict["milestone_name"] = eachObject.milestoneName
            dict["isPhotoevidence"] = eachObject.isPhotoevidence
            dict["from_date"] = eachObject.fromDate.backendFormat
            if !eachObject.toDate.backendFormat.isEmpty {
                dict["to_date"] = eachObject.toDate.backendFormat
            }
            dict["recommended_hours"] = eachObject.recommendedHours
            dict["order"] = eachObject.order
            milestoneArrayOfDict.append(dict)
        })
        
        let params: [String: Any] = ["template_name": templateName, "milestones": milestoneArrayOfDict]
        
        ApiManager.request(methodName: EndPoint.saveTemplate.path, parameters: params, methodType: .post) { [weak self] result in
            switch result {
            case .success( _):
                self?.delegate?.success()
            case .failure(let error):
                self?.delegate?.failure(error: error?.localizedDescription ?? "Something went wrong!")
            default:
                Console.log("Do Nothing")
            }
        }
    }
}
