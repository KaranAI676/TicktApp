//
//  LoggedInUserProfileBuilderVM.swift
//  Tickt
//
//  Created by S H U B H A M on 27/06/21.
//

import Foundation
import SwiftyJSON

protocol LoggedInUserProfileBuilderVMDelegate: AnyObject {
    func profileUploadedSuccess(image: String)
    func successLogout()
    func failure(message: String)
    func didImageUploaded(imageUrl: String)
    func successGetBuilder(model: LoggedInUserProfileBuilderModel)
    func didGetTradieProfile(model: LoggedInUserProfileBuilderModel)
}

class LoggedInUserProfileBuilderVM: BaseVM {
    
    weak var delegate: LoggedInUserProfileBuilderVMDelegate? = nil
    
    func logout() {        
        let endPoint = "?" + ApiKeys.deviceId + "=" + DeviceDetail.deviceId
        ApiManager.request(methodName: EndPoint.logout.path + endPoint, parameters: nil, methodType: .get) { result in
            switch result {
            case .success(_):
                CommonFunctions.removeUserDefaults()
//                kUserDefaults.set(true, forKey: UserDefaultKeys.kTutorialPlayed)
                self.delegate?.successLogout()
            case .failure(let error):
                CommonFunctions.showToastWithMessage(error?.localizedDescription ?? "")
                break
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func getBuilderProfile(isPullToRefresh: Bool = false) {
        ApiManager.request(methodName: EndPoint.profileBuilder.path, parameters: nil, methodType: .get, showLoader: !isPullToRefresh) { result in
            switch result {
            case .success(let data):
                if let serverResponse: LoggedInUserProfileBuilderModel = self.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        self.delegate?.successGetBuilder(model: serverResponse)
                    } else {
                        CommonFunctions.showToastWithMessage("Something went wrong.")
                    }
                }
            case .failure(_):
                CommonFunctions.showToastWithMessage("Something went wrong.")
                break
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func getTradieProfile(isPullToRefresh: Bool = false) {
        ApiManager.request(methodName: EndPoint.tradieProfile.path, parameters: nil, methodType: .get, showLoader: !isPullToRefresh) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                if let serverResponse: LoggedInUserProfileBuilderModel = self.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        self.delegate?.didGetTradieProfile(model: serverResponse)
                    } else {
                        CommonFunctions.showToastWithMessage("Something went wrong.")
                    }
                }
            case .failure(let error):
                self.delegate?.failure(message: error?.localizedDescription ?? "")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func uploadUserImage(imageUrl: String) {
        ApiManager.request(methodName: EndPoint.uploadUserImage.path, parameters: ["userImage": imageUrl], methodType: .put) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                if let serverResponse: GenericResponse = self.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        self.delegate?.didImageUploaded(imageUrl: imageUrl)
                    } else {
                        CommonFunctions.showToastWithMessage("Something went wrong.")
                    }
                }
            case .failure(let error):
                self.delegate?.failure(message: error?.localizedDescription ?? "")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func uploadImages(image: UIImage) {
        ApiManager.uploadRequest(methodName: EndPoint.uploadDocument.path, parameters: [ApiKeys.file: image.jpegData(compressionQuality: 0.6) ?? Data()], methodType: .post, showLoader: true, result: { [weak self] result in
            switch result {
            case .success(let data):
                 let serverResponse: DocumentModel = DocumentModel(JSON(data))
                    if serverResponse.statusCode == StatusCode.success {
                        self?.uploadUserImage(imageUrl: serverResponse.result?.url?.first ?? "")
                    } else {
                        CommonFunctions.showToastWithMessage("Failed to upload images")
                    }
            
            case .failure(let error):
                self?.delegate?.failure(message: error?.localizedDescription ?? "Unknown error")
                self?.handleFailure(error: error)
            default:
                Console.log("Do Nothing")
            }
        })
    }
        
    func changeProfilePicture(image: UIImage) {
        
        self.hitAPI(image, completion: { imageUrl in
            let params: [String: Any] = ["userImage": imageUrl]
            ApiManager.request(methodName: EndPoint.profileBuilderUserImage.path, parameters: params, methodType: .put) { result in
                switch result {
                case .success( _):
                    self.delegate?.profileUploadedSuccess(image: imageUrl)
                case .failure(_):
                    CommonFunctions.showToastWithMessage("Something went wrong.")
                    break
                default:
                    Console.log("Do Nothing")
                }
            }
        })
    }
}

extension LoggedInUserProfileBuilderVM {
    
    func hitAPI(_ image: UIImage, completion: @escaping (String)-> ()) {
        
        let data = (image.jpegData(compressionQuality: 0.5) ?? Data(), MimeTypes.imageJpeg)
        
        let params: [String: Any] = [ApiKeys.file: [data]]
        ApiManager.uploadRequest(methodName: EndPoint.uploadDocument.path, parameters: params, methodType: .post, showLoader: true, result: { [weak self] result in
            guard let self = self else { return }
            ///
            switch result {
            case .success(let data):
                 let serverResponse: DocumentModel = DocumentModel(JSON(data))
                    if serverResponse.statusCode == StatusCode.success {
                        if let url = serverResponse.result?.url?.first {
                            completion(url)
                        }
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
