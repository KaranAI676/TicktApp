//
//  SearchedResultModel.swift
//  Tickt
//
//  Created by Admin on 31/03/21.
//

import UIKit
import Foundation

struct RecentSearchModel: Codable {
    let message: String
    let statusCode: Int
    let status: Bool
    var result: RecentSearchData?
    
    enum CodingKeys: String, CodingKey {
        case message, result, status
        case statusCode = "status_code"
    }
}

struct RecentSearchData: Codable {
    var resultData: [SearchedResultData]?
    
    enum CodingKeys: String, CodingKey {
        case resultData
    }
}

struct SearchedResultModel: Codable {
    let message: String
    let statusCode: Int
    let status: Bool
    let result: [SearchedResultData]?
    
    enum CodingKeys: String, CodingKey {
        case message, result, status
        case statusCode = "status_code"
    }
}

struct SearchedResultData: Codable {
    var id: String?
    var name: String?
    var image: String?
    var tradeName: String?
    var recentSearchId: String?
    var specializationsId: String?
        
    enum CodingKeys: String, CodingKey {
        case specializationsId, name, image, recentSearchId
        case id = "_id"
        case tradeName = "trade_name"
    }
    
    init() {
        self.id = ""
        self.name = ""
        self.image = ""
        self.tradeName = ""
        self.recentSearchId = ""
        self.specializationsId = ""
    }
}
    

//struct SearchedResultModel: Codable {
//    let message: String
//    let statusCode: Int
//    let status: Bool
//    let result: [SearchedResultData]?
//
//    enum CodingKeys: String, CodingKey {
//        case message, result, status
//        case statusCode = "status_code"
//    }
//}
//
//struct SearchedResultData: Codable {
//    let id: String
//    let payType: String
//    let jobName: String?
//    let jobDescription: String?
//    let amount: Int
//    let fromDate: String
//    let toDate: String?
//    let createdBy: String?
//    let locationName: String
//    let status: Int
//    let location: Double
//    let categories: [String]
//    let specialization: [String]
//    let jobType: [String]
//    let urls: [String]
//    let milestones: [Milestone]
//
//    enum CodingKeys: String, CodingKey {
//        case amount, createdBy, jobName, status, location, categories, urls, specialization, milestones
//        case id = "_id"
//        case jobDescription = "job_description"
//        case jobType = "job_type"
//        case payType = "pay_type"
//        case fromDate = "from_date"
//        case toDate = "to_date"
//        case locationName = "location_name"
//
//    }
//}
//
//struct Milestone: Codable {
//    let isPhotoevidence: Bool
//    let urls: [String]
//    let id: String
//    let milestoneName: String
//    let fromDate: String
//    let toDate: String
//    let recommendedHours: String
//
//    enum CodingKeys: String, CodingKey {
//        case isPhotoevidence, urls
//        case id = "_id"
//        case milestoneName = "milestone_name"
//        case fromDate = "from_date"
//        case toDate = "to_date"
//        case recommendedHours = "recommended_hours"
//    }
//}
//
