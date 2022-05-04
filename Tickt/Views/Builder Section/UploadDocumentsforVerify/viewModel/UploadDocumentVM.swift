//
//  UploadDocumentVM.swift
//  Tickt
//
//  Created by Admin on 22/09/21.
//

import Foundation
import SwiftyJSON

protocol UploadDocumenDelegate: AnyObject {
    func failure(error: String)
    func sucess(msg:String)
}

class UploadDocumentVM: BaseVM {
    
    weak var delegate: UploadDocumenDelegate?
    
    private func getImagesData(images: [UIImage]) -> [(Data, MimeTypes)] {
        let images = images.compactMap({ eachImage -> (Data, MimeTypes) in
            return (eachImage.jpegData(compressionQuality: 0.5) ?? Data(), .imageJpeg)
        })
        return images
    }
        
    func uploadDocumentsImages(stripeID:String,front:UIImage,backImage:UIImage) {
        var parms = JSONDictionary()
        parms["stripeAccountId"] = stripeID
        parms[ApiKeys.frontPhotoIDUpload] = front.jpegData(compressionQuality: 0.5)
        parms[ApiKeys.backPhotoIDUpload] = backImage.jpegData(compressionQuality: 0.5)
        ApiManager.uploadRequest(methodName: EndPoint.idUpload.path, parameters: parms, methodType: .put, showLoader: true, result: { [weak self] result in
            switch result {
            case .success(let data):
                 let serverResponse: DocumentModel = DocumentModel(JSON(data))
                    if serverResponse.statusCode == StatusCode.success {
                        self?.delegate?.sucess(msg: serverResponse.message)
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
    }
}

extension UIImage {
    // MARK: - UIImage+Resize
    func compressTo(_ expectedSizeInMb:Int) -> Data? {
        let sizeInBytes = expectedSizeInMb * 1024 * 1024
        var needCompress:Bool = true
        var imgData:Data?
        var compressingValue:CGFloat = 1.0
        while (needCompress && compressingValue > 0.0) {
            if let data:Data = jpegData(compressionQuality: compressingValue) {
                if data.count < sizeInBytes {
                    needCompress = false
                    imgData = data
                } else {
                    compressingValue -= 0.1
                }
            }
        }

        if let data = imgData {
            if (data.count < sizeInBytes) {
                return data
            }
        }
        return nil
    }
}
