//
//  JobModel.swift
//  Tickt
//
//  Created by Admin on 30/03/21.
//

import UIKit
import Foundation

struct JobModel: Codable {
    let message: String
    let statusCode: Int
    let status: Bool
    let result: JobData?
    
    enum CodingKeys: String, CodingKey {
        case message, result, status
        case statusCode = "status_code"
    }
}

struct JobData: Codable {
    let resultData: [JobType]?
}

struct JobType: Codable {
    let status: Int
    let id: String
    let image: String
    let description: String
    let name: String
        
    enum CodingKeys: String, CodingKey {
        case name, description, image, status
        case id = "_id"
    }
}
