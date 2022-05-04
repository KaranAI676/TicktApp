//
//  BaseViewModel.swift
//  Tickt
//
//  Created by Admin on 10/03/21.
//

import UIKit
import Foundation

class BaseVM {
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
                DispatchQueue.mainQueueAsync {
                    CommonFunctions.showToastWithMessage(error.localizedDescription)
                }
            }
        } else {
            DispatchQueue.mainQueueAsync {
                CommonFunctions.showToastWithMessage("Something went wrong")
            }
        }
        return nil
    }
    
    func handleFailure(error: Error?) {
        if let error = error {
            DispatchQueue.mainQueueAsync {
                CommonFunctions.showToastWithMessage(error.localizedDescription)
            }
        }
    }
}
