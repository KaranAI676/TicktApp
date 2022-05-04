//
//  EditableOptionBuilderVM.swift
//  Tickt
//
//  Created by S H U B H A M on 29/06/21.
//

import Foundation
import SwiftyJSON

protocol EditableOptionBuilderVMDelegate: AnyObject {
    
    func didGetTradeList()
    func successEditProfile()
    func failure(message: String)
    func successChangeProfile(image: String)
    func didGetTradieProfile(model: TradieProfilefromBuilderModel)
}

class EditableOptionBuilderVM: BaseVM {
    
    weak var delegate: EditableOptionBuilderVMDelegate? = nil
    
    func getTradeList() {
        if kAppDelegate.tradeModel == nil {
            ApiManager.request(methodName: EndPoint.tradeList.path, parameters: nil, methodType: .get) { [weak self] result in
                switch result {
                case .success(let data):
                     let serverResponse: TradeModel = TradeModel(JSON(data))
                        if serverResponse.statusCode == StatusCode.success {
                            kAppDelegate.tradeModel = serverResponse
                            self?.delegate?.didGetTradeList()
                        } else {
                            CommonFunctions.showToastWithMessage("Something went wrong.")
                        }
                case .failure(let error):
                    self?.handleFailure(error: error)
                default:
                    Console.log("Do Nothing")
                }
            }
        } else {
            delegate?.didGetTradeList()
        }
    }
    
    func editProfile(model: BuilderProfileResult) {
        
        ApiManager.request(methodName: EndPoint.profileBuilderEditProfile.path, parameters: getParams(model), methodType: .put) { [weak self] result in
            guard let self = self else { return }
            CommonFunctions.hideActivityLoader()
            switch result {
            case .success( _):
                self.delegate?.successEditProfile()
            case .failure(let error):
                self.delegate?.failure(message: error?.localizedDescription ?? "")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func editTradieProfile(model: TradieProfileResult) {
        
        let trades = model.areasOfSpecialization.tradeData.map {$0.tradeId}
        let specializations = model.areasOfSpecialization.specializationData.map {$0.specializationId}
        let param: [String: Any] = [ApiKeys.trade: trades,
                                    ApiKeys.about: model.about,
                                    ApiKeys.fullName: model.tradieName,
                                    "userImage": model.tradieImage ?? "",
                                    ApiKeys.specialization: specializations]
        ApiManager.request(methodName: EndPoint.editTradieProfile.path, parameters: param, methodType: .put) { [weak self] result in
            guard let self = self else { return }
            CommonFunctions.hideActivityLoader()
            switch result {
            case .success( _):
                self.delegate?.successEditProfile()
            case .failure(let error):
                self.delegate?.failure(message: error?.localizedDescription ?? "")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func getTradieProfile() {
        ApiManager.request(methodName: EndPoint.tradiePublicProfile.path, parameters: nil, methodType: .get) { [weak self] result in
            guard let self = self else { return }
            CommonFunctions.hideActivityLoader()
            switch result {
            case .success(let data):
                let serverResponse: TradieProfilefromBuilderModel = TradieProfilefromBuilderModel(JSON(data))
                if serverResponse.statusCode == StatusCode.success {
                    self.delegate?.didGetTradieProfile(model: serverResponse)
                } else {
                    CommonFunctions.showToastWithMessage("Something went wrong.")
                }
            case .failure(let error):
                self.delegate?.failure(message: error?.localizedDescription ?? "")
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func changeProfilePicture(image: UIImage) {
        self.hitAPI(image, completion: { imageUrl in
            self.delegate?.successChangeProfile(image: imageUrl)
        })
    }
}

extension EditableOptionBuilderVM {
    
    private func getParams(_ model: BuilderProfileResult) -> [String: Any] {
        
        var params = [String: Any]()
        
        params["fullName"] = model.builderName
        params["userImage"] = model.builderImage
        params["position"] = model.position
        params["companyName"] = model.companyName
        params["aboutCompany"] = model.aboutCompany
        ///
        params["portfolio"] = model.portfolio.map({ eachModel -> [String: Any] in
            var object: [String: Any] = ["jobName": eachModel.jobName,
                                         "jobDescription": (eachModel.jobDescription == "") ? " " : eachModel.jobDescription]
            object["url"] = eachModel.portfolioImage?.map({ eachUrl -> String in
                return eachUrl
            })
            return object
        })
        
        return params
    }
}

extension EditableOptionBuilderVM {
    
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
