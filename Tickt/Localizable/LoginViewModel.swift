//
//  LoginViewModel.swift
//  Tickt
//
//  Created by S H U B H A M on 09/03/21.
//

import Foundation

protocol LoginViewModelDelegate: AnyObject {
    func willHitApi()
    func didGetSuccess()
    func socialIdExist(status: Bool)
    func linkedinSuccess(model: LinkedInModel)
    func didReceiveError(message: String)
}

class LoginViewModel: BaseVM {
    
    weak var delegate: LoginViewModelDelegate? = nil
    
    func login(param: [String: Any], methodName: String) {
        ApiManager.request(methodName: methodName, parameters: param, methodType: .post) { [weak self] result in
            switch result {
            case .success(let data):
                if let serverResponse: LoginModel = self?.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {                        
                        CommonFunctions.setUserDefaults(model: serverResponse.result)                        
                        self?.delegate?.didGetSuccess()                        
                    } else {
                        CommonFunctions.showToastWithMessage("Something went wrong.")
                    }
                }                
            case .failure(let error):
                self?.handleFailure(error: error)
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func checkSocialId(socialId: String) {
        var endPoint = EndPoint.checkSocialId.path + socialId + "&\(ApiKeys.userType)=\(kUserDefaults.getUserType())"
        if !kUserDefaults.getUserEmail().isEmpty {
            endPoint += "&\(ApiKeys.email)=\(kUserDefaults.getUserEmail())"
        }
        ApiManager.request(methodName: endPoint, parameters: nil, methodType: .get) { [weak self] result in
            switch result {
            case .success(let data):
                if let serverResponse: SocialModel = self?.handleSuccess(data: data) {
                    if serverResponse.statusCode == StatusCode.success {
                        self?.delegate?.socialIdExist(status: serverResponse.result?.isProfileCompleted ?? false)
                    } else {
                        CommonFunctions.showToastWithMessage("Something went wrong.")
                    }
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            default:
                Console.log("Do Nothing")
            }
        }
    }

    
    func getLinkedInProfile(accessToken: String) {
        DispatchQueue.main.async {
            CommonFunctions.showActivityLoader()
        }
        let targetURLString = "https://api.linkedin.com/v2/me?projection=(id,firstName,lastName,email-address,profilePicture(displayImage~:playableStreams))"
        let request = NSMutableURLRequest(url: NSURL(string: targetURLString)! as URL)
        request.httpMethod = "GET"
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { [weak self] (data, response, error) -> Void in
            let statusCode = (response as! HTTPURLResponse).statusCode
            if statusCode == 200 {
                do {
                    let jsonDecode = JSONDecoder()
                    if let dataDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)  as? [String: Any] {
                        ApiManager.prettyPrint(json: dataDictionary, statusCode: 200)
                    }
                    
                    let linkedObject = try jsonDecode.decode(LinkedInModel.self, from: data ?? Data())
                    self?.getEmailAddress(accessToken: accessToken, model: linkedObject)
                } catch let error {
                    DispatchQueue.main.async {
                        CommonFunctions.hideActivityLoader()
                    }
                    CommonFunctions.showToastWithMessage(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    func getEmailAddress(accessToken: String, model: LinkedInModel) {
        let targetURLString = "https://api.linkedin.com/v2/emailAddress?q=members&projection=(elements*(handle~))&oauth2_access_token=\(accessToken)"
        let request = NSMutableURLRequest(url: NSURL(string: targetURLString)! as URL)
        request.httpMethod = "GET"
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { [weak self] (data, response, error) -> Void in
            DispatchQueue.main.async {
                CommonFunctions.hideActivityLoader()
            }
            defer {
                self?.delegate?.linkedinSuccess(model: model)
            }
            let statusCode = (response as! HTTPURLResponse).statusCode
            if statusCode == 200 {
                do {
                    if let dataDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)  as? [String: Any] {
                        ApiManager.prettyPrint(json: dataDictionary, statusCode: 200)
                    }

                    let jsonDecode = JSONDecoder()
                    let linkedObject = try jsonDecode.decode(LinkedInEmailModel.self, from: data ?? Data())
                    kUserDefaults.set(linkedObject.elements.first?.elementHandle.emailAddress ?? "", forKey: UserDefaultKeys.kLoggedInEmail)
                } catch let error {
                    CommonFunctions.showToastWithMessage(error.localizedDescription)
                }
            }
        }
        task.resume()
    }

}
