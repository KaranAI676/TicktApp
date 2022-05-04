//
//  CreateJobUploadMediaVM.swift
//  Tickt
//
//  Created by S H U B H A M on 31/03/21.
//

import UIKit
import Foundation
import SwiftyJSON

protocol CreateJobUploadMediaDelegate: class {
    
    func success(urls: [MediaUploadableObject])
    func failure(error: String)
}

class CreateJobUploadMediaVM: BaseVM {
    
    weak var delegate: CreateJobUploadMediaDelegate?

    func uploadImages(imagesArray: [UploadMediaObject]) {
        
        
        let willUploadArray = getRequiredArray(imagesArray: imagesArray)
        
        let preUploadedArray = getRequiredArray(imagesArray: imagesArray, true)
        
        
        let preUploadedUrls: [MediaUploadableObject] = preUploadedArray.compactMap({ eachModel -> MediaUploadableObject? in
            guard let url = eachModel.genericUrl else { return nil }
            return (thumbnail: eachModel.genericThumbnail, mediaLink: url, mediaType: eachModel.type)
        })
        
        if willUploadArray.isEmpty {
            delegate?.success(urls: preUploadedUrls)
            return
        }
        
        /// Images Data
        let images = willUploadArray.compactMap({ eachModel -> (Data, MimeTypes)? in
            if eachModel.type == .image {
                return ((eachModel.image.jpegData(compressionQuality: 0.5) ?? Data()), eachModel.mimeType)
            }
            return nil
        })
        /// Videos Data with thumbnail Data
        let videoArray = willUploadArray.compactMap({ eachModel -> (Data, Data, MimeTypes)? in
            if eachModel.type == .video, let videoUrl = URL(string: eachModel.finalUrl) {
                do {
                    return try (eachModel.image.jpegData(compressionQuality: 0.5) ?? Data(), Data(contentsOf:  videoUrl), eachModel.mimeType)
                } catch  {
                    printDebug("Video doesn't covert")
                }
            }
            return nil
        })
        /// Pdf Data
        let pdfArray = willUploadArray.compactMap({ eachModel -> (Data, MimeTypes)? in
            if eachModel.type == .pdf, let pdfUrl = URL(string: eachModel.finalUrl) {
                do {
                    return try (Data(contentsOf:  pdfUrl), eachModel.mimeType)
                } catch  {
                    printDebug("Pdf doesn't covert")
                }
            }
            return nil
        })
        /// Doc Data
        let docArray = willUploadArray.compactMap({ eachModel -> (Data, MimeTypes)? in
            if eachModel.type == .doc, let docUrl = URL(string: eachModel.finalUrl) {
                do {
                    return try (Data(contentsOf:  docUrl), eachModel.mimeType)
                } catch  {
                    printDebug("Doc doesn't covert")
                }
            }
            return nil
        })
        ///
        var imagesUploaded = images.isEmpty
        var videosUploaded = videoArray.isEmpty
        var pdfUploaded = pdfArray.isEmpty
        var docUploaded = docArray.isEmpty
        var willUploadUrls = [(String?, String, MediaTypes)]()
        ///
        CommonFunctions.showActivityLoader()
        /// Upload Images
        self.hitAPI(params: [ApiKeys.file: images], type: .image, completionClosure: { [weak self] model in
            guard let self = self else { return }
            willUploadUrls.append(contentsOf: (self.getformattedArray(urls: model.result?.url ?? [], mediaType: .image)).map({$0}))
            imagesUploaded = true
            if imagesUploaded && videosUploaded && pdfUploaded && docUploaded {
                self.delegate?.success(urls: willUploadUrls + preUploadedUrls)
            }
        })
        /// Upload Videos with thumbnails
        self.getVideoUrls(videoArray: videoArray, completion: { [weak self] urlArray in
            guard let self = self else { return }
            let _ = urlArray.map({ eachModel in
                willUploadUrls.append(eachModel)
            })
            videosUploaded = true
            if imagesUploaded && videosUploaded && pdfUploaded && docUploaded {
                self.delegate?.success(urls: willUploadUrls + preUploadedUrls)
            }
        })
        /// Upload Pdfs
        self.hitAPI(params: [ApiKeys.file: pdfArray], type: .pdf, completionClosure: { [weak self] model in
            guard let self = self else { return }
            willUploadUrls.append(contentsOf: (self.getformattedArray(urls: model.result?.url ?? [], mediaType: .pdf)).map({$0}))
            pdfUploaded = true
            if imagesUploaded && videosUploaded && pdfUploaded && docUploaded {
                self.delegate?.success(urls: willUploadUrls + preUploadedUrls)
            }
        })
        /// Upload Docs
        self.hitAPI(params: [ApiKeys.file: docArray], type: .doc, completionClosure: { [weak self] model in
            guard let self = self else { return }
            willUploadUrls.append(contentsOf: (self.getformattedArray(urls: model.result?.url ?? [], mediaType: .doc)).map({$0}))
            docUploaded = true
            if imagesUploaded && videosUploaded && pdfUploaded && docUploaded {
                self.delegate?.success(urls: willUploadUrls + preUploadedUrls)
            }
        })
    }
}

//MARK:- Grouping the Thumbnail image with the video
extension CreateJobUploadMediaVM {
    
    private func getVideoUrls(videoArray: [(Data, Data, MimeTypes)], completion: @escaping ([(String?, String, MediaTypes)])->()) {
        
        var urlArray = [(String?, String, MediaTypes)]()
        ///
        let _ = videoArray.map({ eachModel in
            ///
            var thumbnail: String = ""
            var mediaLink: String = ""
            ///
            self.hitAPI(params: [ApiKeys.file: [(eachModel.0, MimeTypes.imageJpeg)]], type: .image, completionClosure: { thumbnailUrl in
                thumbnail = thumbnailUrl.result?.url?.first ?? ""
                self.hitAPI(params: [ApiKeys.file: [(eachModel.1, eachModel.2)]], type: .video, completionClosure: { videoUrl in
                    mediaLink = videoUrl.result?.url?.first ?? ""
                    urlArray.append(contentsOf: (self.getformattedArray(urls: [thumbnail, mediaLink], mediaType: .video)).map({$0}))
                    if urlArray.count == videoArray.count {
                        completion(urlArray)
                    }
                })
            })
        })
    }
}

extension CreateJobUploadMediaVM {
    
    private func getformattedArray(urls: [String], mediaType: MediaTypes) -> [MediaUploadableObject] {
        if mediaType == .video {
            if let thumbnail = urls.first, urls.count > 1, let link = urls.last, urls.count > 1 {
                return [(thumbnail, link, mediaType)]
            }
        }
        ///
        let formattedArray = urls.map({ eachModel -> (MediaUploadableObject) in
            return (nil, eachModel, mediaType)
        })
        return formattedArray
    }
    
    private func getRequiredArray(imagesArray: [UploadMediaObject], _ preUploadedArray: Bool = false) -> [UploadMediaObject] {
        if preUploadedArray {
            return imagesArray.filter({ eachModel in
                return eachModel.genericUrl.isNotNil
            })
        }else {
            return imagesArray.filter({ eachModel in
                return eachModel.genericUrl.isNil
            })
        }
    }
}

//MARK:- API Hit
//==============
extension CreateJobUploadMediaVM {
    
    private func hitAPI(params: [String: Any], type: MediaTypes, completionClosure: @escaping (DocumentModel)-> Void) {
        
        if let dataArray = params[ApiKeys.file] as? [(Data, MimeTypes)], dataArray.isEmpty {
            return
        }
        
        ApiManager.uploadRequest(methodName: EndPoint.uploadDocument.path, parameters: params, methodType: .post, showLoader: false, result: { [weak self] result in
            ///
            switch result {
            case .success(let data):
                 let serverResponse: DocumentModel = DocumentModel(JSON(data))
                    if serverResponse.statusCode == StatusCode.success {
                        completionClosure(serverResponse)
                    } else {
                        CommonFunctions.showToastWithMessage("Failed to upload images")
                        CommonFunctions.hideActivityLoader()
                    }
            case .failure(let error):
                self?.delegate?.failure(error: error?.localizedDescription ?? "Unknown error")
            default:
                Console.log("Do Nothing")
                CommonFunctions.hideActivityLoader()
            }
        }, onProgress: { (progress) in
            print(progress)
        })
    }
}
