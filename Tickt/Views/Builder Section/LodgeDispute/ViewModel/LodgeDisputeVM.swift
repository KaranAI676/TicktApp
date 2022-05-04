//
//  LodgeDisputeVM.swift
//  Tickt
//
//  Created by S H U B H A M on 12/06/21.
//

import Foundation
import SwiftyJSON

protocol LodgeDisputeVMDelegate: AnyObject {
    func success()
    func failure(message: String)
}

class LodgeDisputeVM: BaseVM {
    
    weak var delegate: LodgeDisputeVMDelegate? = nil
    private var imageUrls = [String]()
    
    func lodgeDispute(model: LodgeDisputeModel) {
        if !model.images.isEmpty {
            uploadImages(images: model.images, completion: {
                self.hitLodgeDispute(params: self.getParams(model))
            })
        } else {
            hitLodgeDispute(params: getParams(model))
        }
    }
}

extension LodgeDisputeVM {
    
    private func hitLodgeDispute(params: [String: Any]) {
        let endpoint = kUserDefaults.isTradie() ? EndPoint.lodgeDisputeTradie.path : EndPoint.lodgeDisputeBuilder.path
        ApiManager.request(methodName: endpoint, parameters: params, methodType: .post) { [weak self] result in
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

extension LodgeDisputeVM {
    
    private func getParams(_ model: LodgeDisputeModel) -> [String: Any] {
        var params = [String: Any]()
        ///
        params = [ApiKeys.jobId: model.jobId]
        
        if !model.detail.isEmpty {
            params[ApiKeys.details] = model.detail
        }
        
        if let type = model.disputeReasonType {
            params[ApiKeys.reason] = type.rawValue
        }
        
        if !imageUrls.isEmpty {
            params[ApiKeys.photos] = imageUrls.map { eachModel -> [String: Any] in
                return [ApiKeys.mediaType: MediaTypes.image.rawValue, ApiKeys.link: eachModel]
            }
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
