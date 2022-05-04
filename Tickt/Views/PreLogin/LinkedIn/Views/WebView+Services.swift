//
//  WebView+Services.swift
//  Tickt
//
//  Created by Admin on 09/04/21.
//

import Foundation
import SwiftyJSON

extension WebViewController {
    func requestForAccessToken(authorizationCode: String) {
        let grantType = "authorization_code"
        let redirectURL = "https://www.shift-freight.com/".addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        var postParams = "grant_type=\(grantType)&"
        postParams += "code=\(authorizationCode)&"
        postParams += "redirect_uri=\(redirectURL)&"
        postParams += "client_id=\(linkedInKey)&"
        postParams += "client_secret=\(linkedInSecret)"
        
        let postData = postParams.data(using: String.Encoding.utf8)
        let request = NSMutableURLRequest(url: NSURL(string: accessTokenEndPoint)! as URL)
        request.httpMethod = "POST"
        request.httpBody = postData
        request.addValue("application/x-www-form-urlencoded;", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) {[weak self] (data, response, error) -> Void in
            let statusCode = (response as! HTTPURLResponse).statusCode
            if statusCode == 200 {
                do {
                    let dataDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
                    let accessToken = dataDictionary?[UserDefaultKeys.kAccessTokenLinkedIn] as! String
                    kUserDefaults.set(accessToken, forKey: UserDefaultKeys.kAccessTokenLinkedIn)
                    self?.delegate?.linkedInSuccess(accessToken: accessToken)
                    DispatchQueue.main.async(execute: { () -> Void in
                        self?.dismiss(animated: true, completion: nil)
                    })
                }
                catch {
                    DispatchQueue.main.async {
                        CommonFunctions.hideActivityLoader()
                    }
                    print("Could not convert JSON data into a dictionary.")
                }
            }
        }
        task.resume()
    }
    
    func getPrivacyPolicy() {
        var endPoint = EndPoint.privacyPolicy.path
        if kUserDefaults.isUserLogin() {
            if kUserDefaults.isTradie() {
                endPoint = EndPoint.tradiePrivacyPolicy.path + "?\(ApiKeys.type)=mobile"
            } else {
                endPoint = EndPoint.builderPrivacyPolicy.path + "?\(ApiKeys.type)=mobile"
            }
        }
        ApiManager.request(methodName: endPoint, parameters: nil, methodType: .get, showLoader: true) { [weak self] result in
            switch result {
            case .success(let data):
                if let dataObject = (data as? [String : Any]) {
                    let serverResponse: PrivacyModel = PrivacyModel(JSON(dataObject))
                    self?.loadWebView(urlString: serverResponse.result.privacyUrl)
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func getTermsAndCondition() {
        var endPoint = EndPoint.termsAndCondition.path
        if kUserDefaults.isUserLogin() {
            if kUserDefaults.isTradie() {
                endPoint = EndPoint.tradieTermsAndCondition.path + "?\(ApiKeys.type)=mobile"
            } else {
                endPoint = EndPoint.builderTermsAndCondition.path + "?\(ApiKeys.type)=mobile"
            }            
        }
        ApiManager.request(methodName: endPoint, parameters: nil, methodType: .get, showLoader: true) { [weak self] result in
            switch result {
            case .success(let data):
                if let dataObject = (data as? [String : Any]) {
                    let serverResponse: TermsModel = TermsModel(JSON(dataObject))
                    self?.loadWebView(urlString: serverResponse.result.termsUrl)
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            default:
                Console.log("Do Nothing")
            }
        }
    }
    
    func loadWebView(urlString: String) {
        if let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
            mainQueue { [weak self] in
                self?.activityIndicator.startAnimating()
            }
        }
    }
}
