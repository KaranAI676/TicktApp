//
//  ReviewTradePeopleModel.swift
//  Tickt
//
//  Created by S H U B H A M on 25/05/21.
//

import Foundation

struct ReviewTradePeopleModel {

    var rating: Double
    var review: String
    var jobData: PastJobData
    var tradieData: PastJobTradieData
    
    init() {
        rating = 0.0
        review = ""
        jobData = PastJobData()
        tradieData = PastJobTradieData()
    }
    
    init(jobName: String, jobData: PastJobData, tradieData: PastJobTradieData) {
        self.rating = 0
        self.review = ""
        self.jobData = PastJobData(jobName: jobName, data: jobData)
        self.tradieData = tradieData
    }
}


struct ReviewPostedModel: Codable {
    
    var status: Bool
    var message: String
    var statusCode: Int
    var result: ReviewPostedResultModel
    
    enum CodingKeys: String, CodingKey {
        case status, message, result
        case statusCode = "status_code"
    }
}

struct ReviewPostedResultModel: Codable {
    
    var reviewId: String
    var jobId: String
    var tradieId: String
    var rating: Double
    var review: String
}
