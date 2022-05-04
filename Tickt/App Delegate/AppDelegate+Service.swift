//
//  AppDelegate+Service.swift
//  Tickt
//
//  Created by Admin on 11/03/21.
//

import Foundation
import UIKit
import SwiftyJSON

extension AppDelegate {    
    func getTradeList(callAPI: Bool = false) {
        if callAPI || !kUserDefaults.isUserLogin() {
            ApiManager.request(methodName: EndPoint.tradeList.path, parameters: nil, methodType: .get, showLoader: false) { [weak self] result in
                switch result {
                case .success(let data):
                    let serverResponse: TradeModel = TradeModel(JSON(data))
                    if serverResponse.statusCode == StatusCode.success {
                        self?.tradeModel = serverResponse
                    }
                case .failure(let error):
                    self?.handleFailure(error: error)
                default:
                    Console.log("Do Nothing")
                }
            }
        }
    }
    
    func updateDeviceToken() {
        
        if kUserDefaults.isUserLogin() {
            if kUserDefaults.getDeviceToken().isEmpty { return }            
            let params: [String: Any] = [ApiKeys.deviceId: DeviceDetail.deviceId,
                                         ApiKeys.deviceToken: kUserDefaults.getDeviceToken(),
                                         ApiKeys.deviceType: DeviceDetail.deviceType]
            ApiManager.request(methodName: EndPoint.authAddDeviceToken.path, parameters: params, methodType: .put, showLoader: false) { [weak self] result in
                switch result {
                case .success( _):
                    break
                case .failure(let error):
                    self?.handleFailure(error: error)
                default:
                    Console.log("Do Nothing")
                }
            }
        }
    }
    
    func handleSuccess<T: Decodable> (data: Any) -> T? {
        if let dataObject = data as? [String : Any] {
            do {
                let data = try JSONSerialization.data(withJSONObject: dataObject, options: .prettyPrinted)
                let decoder = JSONDecoder()                
                do {
                    let data = try decoder.decode(T.self, from: data)
                    return data
                } catch let DecodingError.typeMismatch(type, context) {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.keyNotFound(key, context){
                    print("mismatch:", context.debugDescription)
                    print("key:", key)
                } catch let DecodingError.dataCorrupted(context) {
                    print(context)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    Console.log("Parsing Error \(error)")
                }
            } catch {
                Console.log(error.localizedDescription)                
            }
        } else {
            
        }
        return nil
    }
    
    func handleFailure(error: Error?){
        if let error = error {
            printDebug(error.localizedDescription)
        }
    }
}
