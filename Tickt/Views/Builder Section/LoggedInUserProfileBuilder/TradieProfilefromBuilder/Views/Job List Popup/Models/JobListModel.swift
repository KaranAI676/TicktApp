//
//  JobListModel.swift
//  Tickt
//
//  Created by Vijay's Macbook on 16/08/21.
//

import Foundation

struct JobListModel: Codable {
    
    var status: Bool
    var message: String
    var statusCode: Int
    var result: JobListResult
    
    enum CodingKeys: String, CodingKey {
        case status, message, result
        case statusCode = "status_code"
    }
}

struct JobListResult: Codable {
    var data: [JobListData]
    let totalCount: Int
}

struct JobListData: Codable {
    let id: ID?
    let jobData: JobListDetail?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case jobData
    }
}

struct JobListDetail: Codable {
    let jobName: String
    let tradeImg: String
    let tradeName: String
}

struct ID: Codable {
    let jobId: String?
    let builderId: String?
    let tradieId: String?
}

