//
//  DeclineMIlestoneBuilderVM.swift
//  Tickt
//
//  Created by S H U B H A M on 18/06/21.
//

import Foundation
import SwiftyJSON

protocol DeclineMIlestoneBuilderVMDelegate: AnyObject {
    
    func success()
    func failure(message: String)
}

class DeclineMIlestoneBuilderVM: BaseVM {
    
    //MARK:- Variables
    weak var delegate: DeclineMIlestoneBuilderVMDelegate? = nil
    private var imageUrls = [String]()
    
    func decliningMilestone(model: DeclineMilestoneBuilderModel) {
        if !model.images.isEmpty {
            uploadImages(images: model.images, completion: {
                self.hitDeclineMilestone(params: self.getParams(model))
            })
        }else {
            hitDeclineMilestone(params: getParams(model))
        }
    }
}

//MARK:- Hit APIs
//===============
extension DeclineMIlestoneBuilderVM {
    
    private func hitDeclineMilestone(params: [String: Any]) {
        ApiManager.request(methodName: EndPoint.jobBuilderMilestoneApproveDecline.path, parameters: params, methodType: .put) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success( _):
                self.delegate?.success()
            case .failure(let error):
                self.delegate?.failure(message: error?.localizedDescription ?? "Unknown")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    
    private func uploadImages(images: [UIImage], completion: @escaping ()->() ) {
        let params: [String: Any] = [ApiKeys.file: getImagesData(images: images)]
        ApiManager.uploadRequest(methodName: EndPoint.uploadDocument.path, parameters: params, methodType: .post, showLoader: true, result: { [weak self] result in
            guard let self = self else { return }
            ///
            switch result {
            case .success(let data):
                 let serverResponse: DocumentModel = DocumentModel(JSON(data))
                    if serverResponse.statusCode == StatusCode.success {
                        if let urls = serverResponse.result?.url {
                            self.imageUrls = urls
                        }
                        completion()
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
extension DeclineMIlestoneBuilderVM {
    
    private func getParams(_ model: DeclineMilestoneBuilderModel) -> [String: Any] {
        var params = [String: Any]()
        ///
        params = [ApiKeys.jobId: model.jobId,
                  ApiKeys.milestoneId: model.milestoneId,
                  ApiKeys.reason: model.reasonText,
                  ApiKeys.status: AcceptDecline.decline.tag]
        
        if !imageUrls.isEmpty {
            params["url"] = imageUrls
//            params["url"] = imageUrls.map { eachModel -> [String: Any] in
//                return [ApiKeys.mediaType: MediaTypes.image.rawValue, ApiKeys.link: eachModel]
//            }
        }
        
        return params
    }
    
    private func getImagesData(images: [UIImage]) -> [(Data, MimeTypes)] {
        let images = images.compactMap({ eachImage -> (Data, MimeTypes) in
            return (eachImage.jpegData(compressionQuality: 0.5) ?? Data(), .imageJpeg)
        })
        return images
    }
}
