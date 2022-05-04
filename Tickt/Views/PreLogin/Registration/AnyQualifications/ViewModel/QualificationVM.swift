//
//  QualificationVM.swift
//  Tickt
//
//  Created by Vijay's Macbook on 07/07/21.
//

import Foundation
import SwiftyJSON

protocol EditQualificationDelegate: AnyObject {
    func didDocUploaded(docArray: [QualificationDoc])
}

class QualificationVM: BaseVM {
    
    weak var delegate: EditQualificationDelegate?
    
    func uploadImages() {
        if kAppDelegate.signupModel.docImages.count > 0 {
            let imageArray = kAppDelegate.signupModel.docImages.map ({ object in
                return (object.0, object.4)
            })
            ApiManager.uploadRequest(methodName: EndPoint.uploadDocument.path, parameters: [ApiKeys.qualifyDoc: imageArray], methodType: .post, showLoader: true, result: { [weak self] result in
                switch result {
                case .success(let data):
                     let serverResponse: DocumentModel = DocumentModel(JSON(data))
                        var docArray: [QualificationDoc] = []
                        if kAppDelegate.signupModel.qualifications.count > 0 {
                            if kAppDelegate.signupModel.qualifications.count == (serverResponse.result?.url ?? []).count, let fileUrls = serverResponse.result?.url {
                                for (index, qualification) in kAppDelegate.signupModel.qualifications.enumerated() {
                                    let object = QualificationDoc(url: fileUrls[index], docName: qualification.name, qualificationId: qualification.id)
                                    docArray.append(object)
                                }
                                self?.delegate?.didDocUploaded(docArray: docArray)
                            }
                        }
                case .failure(let error):
                    self?.handleFailure(error: error)
                default:
                    Console.log("Do Nothing")
                }
            }, onProgress: { (progress) in
                print(progress)
            })
        }
    }
}


