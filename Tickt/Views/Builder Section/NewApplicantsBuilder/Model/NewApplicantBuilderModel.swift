//
//  NewApplicantBuilderModel.swift
//  Tickt
//
//  Created by S H U B H A M on 16/05/21.
//

import Foundation

struct NewApplicantBuilderModel: Codable {
    
    var result: [NewApplicantResult]
    var statusCode: Int
    var message: String
    var status: Bool
    
    enum CodingKeys: String, CodingKey {
        case message, result, status
        case statusCode = "status_code"
    }
}

struct NewApplicantResult: Codable {
    
    var timeLeft: String
    var tradeName: String
    var tradeSelectedUrl: String
    var fromDate: String
    var amount: String
    var toDate: String?
    var total: String
    var specializationName: String
    var builderImage: String
    var jobDescription: String
    var builderId: String
    var jobId: String
    var jobName: String
    var durations: String
    var quoteCount: Int
    var quoteJob:Bool
    
    init() {
        self.timeLeft = ""
        self.tradeName = ""
        self.tradeSelectedUrl = ""
        self.fromDate = ""
        self.amount = ""
        self.toDate = ""
        self.total = ""
        self.specializationName = ""
        self.builderImage = ""
        self.jobDescription = ""
        self.builderId = ""
        self.jobId = ""
        self.durations = ""
        self.jobName = ""
        self.quoteJob = false
        self.quoteCount = 0
    }
}
