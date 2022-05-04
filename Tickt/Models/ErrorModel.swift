//
//  ResponseModel.swift
//  Shift Vendor
//
//  Created by Vijay on 10/07/19.
//  Copyright © 2019 Vijay. All rights reserved.
//

import UIKit

struct ErrorModel {
    var message: String?
    init(response: [String: Any]) {
        if let data = response["data"] as? [String: Any] {
            message = response["message"] as? String
            var messageArray  = [String]()
            let keys = data.keys
            for key in keys {
                if let errorObject = data[key] as? [String: Any], let errorKey = errorObject.keys.first {
                    if let errorMessage = errorObject[errorKey] as? String {
                        messageArray.append(errorMessage)
                    }
                }
            }
            if messageArray.count > 0 {
                message = messageArray.joined(separator: "\n")
            }
        } else {
            message = response["message"] as? String
        }
    }
}

