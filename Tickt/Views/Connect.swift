////
////  Connect.swift
////  Tickt
////
////  Created by Admin on 27/01/22.
////
//
//import Foundation
//import Alamofire
//
//
//
//public protocol ErrorHandlerProtocol {
//
//    func handle(response: [String: Any]) -> Error?
//
//}
//
//
//
//open class ErrorHandler: ErrorHandlerProtocol {
//
//
//
//    public func handle(response: [String: Any]) -> Error? {
//
//        if let error = response["msg"] as? String {
//
//            return ConnectError.unknownError(message: error)
//
//        } else if let error = response["message"] as? String {
//
//            return ConnectError.unknownError(message: error)
//
//        } else if let error = response["error"] as? String {
//
//            return ConnectError.unknownError(message: error)
//
//        } else if let error = response["err"] as? String {
//
//            return ConnectError.unknownError(message: error)
//
//        }
//
//
//
//        return ConnectError.internalServerError
//
//    }
//
//
//
//    public init() {}
//
//}
//
//
//
//public final class Connect {
//
//
//
//    private var middleware: ConnectMiddlewareProtocol
//
//    private let errorHandler: ErrorHandlerProtocol
//
//
//
//    private lazy var session: Session = middleware.session
//
//
//
//    private var cancellables = [String: DataRequest]()
//
//
//
//    public static let `default`: Connect = Connect()
//
//
//
//    public var isLoggingEnabled: Bool
//
//
//
//    public init(tokenHandler: AccessTokenHandlerProtocol? = nil, errorHandler: ErrorHandlerProtocol = ErrorHandler(), isLoggingEnabled: Bool = true) {
//
//        self.errorHandler = errorHandler
//
//        self.middleware = ConnectMiddleware(errorHandler: errorHandler, tokenHandler: tokenHandler)
//
//        self.isLoggingEnabled = isLoggingEnabled
//
//        NotificationCenter.default.addObserver(self, selector: #selector(cancelRequest(_:)), name: .cancelRequest, object: nil)
//
//    }
//
//
//
//    private func parseResponse(response: AFDataResponse<Data>) -> Error? {
//
//
//
//        if case .some(AFError.explicitlyCancelled) = response.error {
//
//            return nil
//
//        }
//
//
//
//        if (200 ..< 300).contains(response.response?.statusCode ?? 0) == false {
//
//            guard let response = try? JSONSerialization.jsonObject(with: response.data ?? Data(), options: []) as? [String: AnyObject] else { return ConnectError.internalServerError }
//
//            let error = errorHandler.handle(response: response)
//
//            if let error = error as? ESimError,
//
//               error == .tokenNullOrNotMatchingFormatError ||
//
//                error == .invalidTokenError ||
//
//                error == .unavailableTokenError {
//
//                NotificationCenter.default.post(name: Notification.Name.navigateToLogin, object: nil, userInfo: ["error": error])
//
//                return nil
//
//            }
//
//
//
//            return error
//
//        }
//
//
//
//        return nil
//
//    }
//
//
//
//    public func request(_ request: Connector, debugResponse: Bool = false) -> Future<Response> {
//
//        let dataRequest = session.request(request).cURLDescription(calling: debugLog)
//
//        let promise = Promise<Response>(requestIdentifier: dataRequest.id.uuidString)
//
//
//
//        dataRequest.validate().responseData { [weak self] response in
//
//            guard let self = self else { return }
//
//
//
//            let elapsedTime = response.metrics?.taskInterval.duration ?? 0.0
//
//            if self.isLoggingEnabled && debugResponse {
//
//                let statusCode = response.response?.statusCode ?? 0
//
//                let url = response.request?.url?.absoluteString ?? ""
//
//                print("\(statusCode) '\(url)' [\(String(format: "%.04f", elapsedTime)) s]:")
//
//                print((response.data ?? Data()).prettyPrintedJSONString ?? "")
//
//            }
//
//
//
//            if let error = self.parseResponse(response: response) {
//
//                promise.reject(with: error)
//
//                return
//
//            }
//
//
//
//            switch response.result {
//
//            case .success(let data):
//
//
//
//                guard let request = response.request, let httpURLResponse = response.response else {
//
//                    promise.reject(with: ConnectError.internalServerError)
//
//                    return
//
//                }
//
//
//
//                let response = Response(request: request, response: httpURLResponse, data: data, duration: elapsedTime)
//
//                promise.resolve(with: response)
//
//
//
//            case .failure(let error):
//
//                promise.reject(with: error)
//
//            }
//
//        }
//
//
//
//        cancellables[dataRequest.id.uuidString] = dataRequest
//
//        return promise
//
//    }
//
//
//
//    public func upload(files: [File]?, to request: Connector, debugResponse: Bool = false, progressHandler: Alamofire.Request.ProgressHandler? = nil) -> Future<Response> {
//
//        let uploadRequest = session.upload(multipartFormData: { formData in
//
//
//
//            if let files = files {
//
//                files.forEach { file in
//
//                    formData.append(file.data, withName: file.key, fileName: file.name, mimeType: file.mimeType.rawValue)
//
//                }
//
//            }
//
//
//
//            request.parameters?.multipartParameters.forEach { parameter in
//
//                parameter.forEach { key, value in
//
//                    formData.append("\(value)".data(using: .utf8) ?? Data(), withName: key)
//
//                }
//
//            }
//
//
//
//        }, with: request)
//
//
//
//        if let progressHandler = progressHandler {
//
//            uploadRequest.uploadProgress(queue: .main, closure: progressHandler)
//
//        }
//
//
//
//        let promise = Promise<Response>(requestIdentifier: uploadRequest.id.uuidString)
//
//
//
//        uploadRequest.cURLDescription(calling: debugLog).validate().responseData { [weak self] response in
//
//            guard let self = self else { return }
//
//
//
//            let elapsedTime = response.metrics?.taskInterval.duration ?? 0.0
//
//            if self.isLoggingEnabled && debugResponse {
//
//                let statusCode = response.response?.statusCode ?? 0
//
//                let url = response.request?.url?.absoluteString ?? ""
//
//
//
//                print("\(statusCode) '\(url)' [\(String(format: "%.04f", elapsedTime)) s]:")
//
//                print((response.data ?? Data()).prettyPrintedJSONString ?? "")
//
//                print(response.response?.headers)
//
//            }
//
//
//
//            if let error = self.parseResponse(response: response) {
//
//                promise.reject(with: error)
//
//                return
//
//            }
//
//
//
//            switch response.result {
//
//            case .success(let data):
//
//
//
//                guard let request = response.request, let httpURLResponse = response.response else {
//
//                    promise.reject(with: ConnectError.internalServerError)
//
//                    return
//
//                }
//
//
//
//                let response = Response(request: request, response: httpURLResponse, data: data, duration: elapsedTime)
//
//                promise.resolve(with: response)
//
//
//
//            case .failure(let error):
//
//                promise.reject(with: error)
//
//            }
//
//        }
//
//        cancellables[uploadRequest.id.uuidString] = uploadRequest
//
//        return promise
//
//    }
//
//
//
//    public func cancelAllRequests() {
//
//        session.cancelAllRequests()
//
//    }
//
//
//
//    @objc private func cancelRequest(_ notification: NSNotification) {
//
//        guard let requestIdentifier = notification.userInfo?["requestIdentifier"] as? String else { return }
//
//        cancellables[requestIdentifier]?.cancel()
//
//        cancellables[requestIdentifier] = nil
//
//    }
//
//
//
//    private func debugLog(description: String) {
//
//        if isLoggingEnabled {
//
//            print("=======================================")
//
//            print(description)
//
//            print("=======================================")
//
//        }
//
//    }
//
//
//
//    deinit {
//
//        NotificationCenter.default.removeObserver(self)
//
//    }
//
//
//
//    func setAccessToken(token: String) {
//
//        middleware.accessToken = token
//
//    }
//
//}
//
