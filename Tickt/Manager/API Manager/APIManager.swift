//
//  APIManager.swift
//  Tickt
//
//  Created by Vijay on 07/08/20.
//  Copyright © 2019 Vijay. All rights reserved.
//

import Alamofire

public typealias HTTPHeaders = [String:String]
public typealias JSONDictionary = [String:Any]
public typealias JSONDictionaryArray = [JSONDictionary]

struct Console {
    static func log(_ message: Any?) {
        print(message ?? "Either Value is nil or in invalid format.")
    }
}

protocol APIResultDelegate: AnyObject {
    func didReceiveSuccess(message: String)
    func didReceiveError(message: String)
}

extension APIResultDelegate {
    func didReceiveSuccess(message: String) {}
    func didReceiveError(message: String) {}
}

enum Result<T> {
    case success(T)
    case failure(Error?)
    case noNetwork(Error)
    case progress(Float)
    case noDataFound(String)
    case pageNotFound
}

enum ApiError: Error {
    case unauthenticated

    var localizedDescription: String {
        switch self {
        case .unauthenticated: return "User unauthenticcated"
        }
    }
}

class ApiManager {

    class func authTokenString(ofUsername username: String, password: String) -> String {
        let loginString = "\(username):\(password)"
        let loginData = loginString.data(using: String.Encoding.utf8)!
        return "Basic \(loginData.base64EncodedString())"
    }
        
    class func request(methodName:String, parameters: [String:Any]?, authToken: String = "", methodType: HTTPMethod, showLoader: Bool = true, loadingText: String = "", result: @escaping (Result<Any>) -> ()) {
        
        if showLoader {
            CommonFunctions.showActivityLoader()
        }
        
        var headers: [String: String] = [:]
        headers = ["Accept": "application/json",
                   "Content-Type": "application/json"]
        headers["timezone"] = kTimeZone
        headers["Authorization"] = kUserDefaults.getAccessToken().isEmpty ? ApiManager.authTokenString(ofUsername: "tickt_app", password: "tickt_app_123sadefss") : kUserDefaults.getAccessToken()
        
        Alamofire.request(methodName, method: methodType, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            if showLoader {
                CommonFunctions.hideActivityLoader()
            }
            logRequest(response: response, parameter: parameters)
            switch(response.result) {
            case .success(_):
                if let data = response.result.value, let code = response.response?.statusCode {
                    prettyPrint(json: data, statusCode: code)
                    ApiManager.handleSuccess(data: data, statusCode: code, result: { (res) in
                        switch(res) {
                        case .success(let data):
                            result(Result.success(data))
                        case .failure(let error):
                            result(Result.failure(error))
                        case .noDataFound(let message):
                            result(Result.noDataFound(message))
                        default:
                            Console.log("")
                        }
                    })
                } else {
                    Console.log("Error while handling the success result")
                }
            case .failure(_):
                if let error = response.result.error  {
                    result(Result.failure(error))
                    Console.log("failure: \(error)")
                } else {
                    result(Result.failure(nil))
                    Console.log("Error while handling the failure result")
                }
                if let data = response.data {
                    Console.log("Error in API: \(String(data: data, encoding: .utf8) ?? "N.A")")
                }
            }
        }
    }
    
    class func uploadRequest(methodName: String,
                                         parameters: [String: Any] = [:],
                                         methodType: HTTPMethod, showLoader: Bool = true,
                                         result: ((Result<Any>) -> ())? = nil,
                                         onProgress: ((Double)-> ())? = nil) {
        if showLoader {
            CommonFunctions.showActivityLoader()
        }
        
        var headers = [String: String]()
        headers = ["Accept": "application/json"]
        headers["timezone"] = kTimeZone
        
        headers["Authorization"] = kUserDefaults.getAccessToken().isEmpty ? ApiManager.authTokenString(ofUsername: "tickt_app", password: "tickt_app_123sadefss") : kUserDefaults.getAccessToken()
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    
                    if key == ApiKeys.qualifyDoc {
                        if let dataArray = value as? [(Data, String)] {
                            for (index, data) in dataArray.enumerated() {
                                if let mimeType = MimeTypes(rawValue: data.1) {
                                    multipartFormData.append(data.0, withName: "\(ApiKeys.file)", fileName: "\(ApiKeys.file)\(index)\(mimeType._extension)", mimeType: data.1)
                                } else {
                                    multipartFormData.append(data.0, withName: "\(ApiKeys.file)", fileName: "\(ApiKeys.file)\(index)", mimeType: data.1)
                                }
                            }
                        }
                        continue
                    }
                    
                    if key == ApiKeys.file {
                        if let dataArray = value as? [(data: Data, mimetype: MimeTypes)] {
                            for (index, data) in dataArray.enumerated() {
                                multipartFormData.append(data.data, withName: "\(key)", fileName: "\(key)\(index)\(data.mimetype._extension)", mimeType: data.mimetype.rawValue)
                            }
                        }
                        if let data = value as? Data {
                            multipartFormData.append(data, withName: key, fileName: "\(key).jpg", mimeType: "image/jpg")
                        }
                        continue
                    }
                    
                    if let data = value as? Data {
                        multipartFormData.append(data, withName: key, fileName: "\(key).jpg", mimeType: "image/jpg")
                        continue
                    }
                    if let stringArray = value as? [String] {
                        for string in stringArray {
                            multipartFormData.append(string.data(using: .utf8)!, withName: "\(key)[]")
                        }
                        continue
                    }
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                }
            },
            usingThreshold: UInt64(),
            to: methodName,
            method: methodType,
            headers: headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { progress in
                        onProgress?(progress.fractionCompleted)
                        Console.log(progress.fractionCompleted)
                    })
                    upload.responseJSON { response in
                        logRequest(response: response, parameter: parameters)
                        if showLoader {
                            CommonFunctions.hideActivityLoader()
                        }
                        switch(response.result) {
                        case .success(_):
                            if let data = response.result.value, let code = response.response?.statusCode {
                                prettyPrint(json: data, statusCode: code)
                                ApiManager.handleSuccess(data: data, statusCode: code, result: { (res) in
                                    switch(res) {
                                    case .success(let data):
                                        result?(Result.success(data))
                                    case .failure(let error):
                                        result?(Result.failure(error))
                                    case .noDataFound(let message):
                                        result?(Result.noDataFound(message))
                                    default:
                                        Console.log("")
                                    }
                                })
                            } else {
                                Console.log("Error while handling the success result")
                            }
                        case .failure(_):
                            if let error = response.result.error {
                                result?(Result.failure(error))
                                Console.log("failure: \(error)")
                            } else {
                                result?(Result.failure(nil))
                                Console.log("Error while handling the failure result")
                            }
                        }
                    }
                case .failure(let encodingError):
                    Console.log(encodingError.localizedDescription)
                    result?(Result.failure(encodingError))
                }
            })
    }
    
    private class func handleSuccess(data: Any, statusCode: Int, result:(Result<Any>) -> ()) {
                
        if statusCode == StatusCode.success || statusCode == StatusCode.resourceCreated {
            result(Result.success(data))
        } else {
            if let data = data as? [String : Any] {
                let errorModel = ErrorModel(response: data)
                if let message = errorModel.message {
                    if statusCode == StatusCode.noDataFound {
                        result(Result.noDataFound(message))
                    } else if statusCode == StatusCode.unauthenticated {
                        CommonFunctions.removeUserDefaults()
                        AppRouter.launchApp()
                    } else {
                        result(Result.failure(NSError(code: statusCode, localizedDescription: message)))
                    }
                } else {
                    result(Result.failure(nil))
                }
            } else {
                result(Result.failure(nil))
            }
        }
    }
    
    class func prettyPrint(json: Any, statusCode: Int) {
        Console.log("Status code is == \(statusCode)")
        if let json = json as? [String: Any] {
            print(prettyPrintDict(with: json))
        } else if let json = json as? [Any] {
            print(prettyPrintArray(with: json))
        }
    }
    
    private class func prettyPrintArray(with json: [Any]) -> String {
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let string = String(data: data, encoding: String.Encoding.utf8)
            if let string  = string {
                return string
            }
        } catch {
            Console.log(error.localizedDescription)
        }
        return ""
    }
    
    private class func prettyPrintDict(with json: [String : Any]) -> String {
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let string = String(data: data, encoding: String.Encoding.utf8)
            if let string  = string {
                return string
            }
        } catch {
            Console.log(error.localizedDescription)
        }
        return ""
    }
    
    private class func logRequest(response: DataResponse<Any>, parameter: [String:Any]?) {
        if let url = response.request?.url {
            Console.log("URL: \(url)")
        }
        
        if let headerFields = response.request?.allHTTPHeaderFields {
            Console.log("HeaderFields:  \(headerFields)")
        }
        
        if let requestType = response.request?.httpMethod {
            Console.log("requestType:  \(requestType)")
        }
        
        if var parameter = parameter {
            parameter.removeValue(forKey: ApiKeys.file)            
            parameter.removeValue(forKey: ApiKeys.videoFile)
            parameter.removeValue(forKey: ApiKeys.qualifyDoc)
            parameter.removeValue(forKey: ApiKeys.frontPhotoIDUpload)
            parameter.removeValue(forKey: ApiKeys.backPhotoIDUpload)
            prettyPrint(json: parameter, statusCode: 100)
        }
    }
    
    func fetchData<T: Decodable>(apiQueue: DispatchQueue, urlString: String, authToken: String, completion: @escaping (T?) -> ()) {
        let url = URL(string: urlString)
        apiQueue.async {
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(nil)
                    return
                }
                guard let dataObject = data else {
                    completion(nil)
                    return
                }
                do {
                    let object = try JSONDecoder().decode(T.self, from: dataObject)
                    completion(object)
                } catch let parsingError {
                    print(parsingError.localizedDescription)
                }
            }).resume()
        }
    }
}

enum StatusCode {
    static var success: Int { return 200 }
    static var emptyData: Int { return 204 }
    static var pageNotFound: Int { return 404 }
    static var unauthenticated: Int { return 401 }
    static var noDataFound: Int { return 400 }
    static var alreadyReported: Int { return 208 }
    static var resourceCreated: Int { return 201 }
}
