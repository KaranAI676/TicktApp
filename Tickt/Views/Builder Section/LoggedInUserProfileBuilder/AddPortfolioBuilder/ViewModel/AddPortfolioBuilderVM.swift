//
//  AddPortfolioBuilderVM.swift
//  Tickt
//
//  Created by S H U B H A M on 29/06/21.
//

import Foundation
import SwiftyJSON

protocol AddPortfolioBuilderVMDelegate: AnyObject {
    func success(urls: [String])
    func failure(error: String)
    func tradiePortFolioAdded(urls: [String], portfolioId: String)
}

class AddPortfolioBuilderVM: BaseVM {
    
    weak var delegate: AddPortfolioBuilderVMDelegate? = nil
    var urlsArray = [String]()
    
    func uploadImages(array: [(String?, UIImage?)]) {
        
        let uploadedImages = array.compactMap({ eachModel -> String? in
            return eachModel.0.isNil ? nil : eachModel.0
        })
        
        let imagesToUpload = array.compactMap({ eachModel -> UIImage? in
            return eachModel.1.isNil ? nil : eachModel.1
        })
        
        if imagesToUpload.isEmpty {
            self.delegate?.success(urls: uploadedImages)
            return
        } else {
            hitAPI(imagesToUpload, uploadedImages)
        }
    }
    
    private func getImagesData(images: [UIImage]) -> [(Data, MimeTypes)] {
        let images = images.compactMap({ eachImage -> (Data, MimeTypes) in
            return (eachImage.jpegData(compressionQuality: 0.5) ?? Data(), .imageJpeg)
        })
        return images
    }
    
    func addPorfolio(model: AddPortfolioBuilderModel, urls: [String]) {
        var params: [String: Any] = [ApiKeys.jobName: model.jobName,
                                     ApiKeys.jobDescription: (model.jobDescription == "") ? " " : model.jobDescription]
        var endpoint = EndPoint.addPortfolio.path
        if !model.id.isEmpty {
            params[ApiKeys.portfolioId] = model.id
            endpoint = EndPoint.editPortfolio.path
        }
        params[ApiKeys.url] = urls
        
        ApiManager.request(methodName: endpoint , parameters: params, methodType: model.id.isEmpty ? .post : .put) { [weak self] result in
            switch result {
            case .success(let data):
                if let serverResponse: AddTradiePortfolioModel = self?.handleSuccess(data: data) {
                    self?.delegate?.tradiePortFolioAdded(urls: urls, portfolioId: serverResponse.result.portfolioId ?? "")
                }
            case .failure(let error):
                self?.delegate?.failure(error: error?.localizedDescription ?? "Unknown error")
            default:
                break
            }
        }
    }
}

extension AddPortfolioBuilderVM {
    
    func hitAPI(_ imagesToUpload: [UIImage], _ uploadedImages: [String] ) {
        let params: [String: Any] = [ApiKeys.file: getImagesData(images: imagesToUpload)]
        ApiManager.uploadRequest(methodName: EndPoint.uploadDocument.path, parameters: params, methodType: .post, showLoader: true, result: { [weak self] result in
            guard let self = self else { return }
            ///
            switch result {
            case .success(let data):
                 let serverResponse: DocumentModel = DocumentModel(JSON(data))
                    if serverResponse.statusCode == StatusCode.success {
                        if let urls = serverResponse.result?.url {
                            self.delegate?.success(urls: urls + uploadedImages)
                        }
                    } else {
                        CommonFunctions.showToastWithMessage("Failed to upload images")
                        CommonFunctions.hideActivityLoader()
                    }
            case .failure(let error):
                self.delegate?.failure(error: error?.localizedDescription ?? "Unknown error")
            default:
                Console.log("Do Nothing")
                CommonFunctions.hideActivityLoader()
            }
        }, onProgress: { (progress) in
            print(progress)
        })
    }
}
