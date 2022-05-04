//
//  JobListingBuilderModel.swift
//  Tickt
//
//  Created by S H U B H A M on 16/06/21.
//

import Foundation

//MARK:- JobListingBuilderModel
//=============================
struct JobListingBuilderModel: Codable {
    
    var status: Bool
    var message: String
    var statusCode: Int
    var result: [JobListingBuilderResult]
    
    enum CodingKeys: String, CodingKey {
        case status, message, result
        case statusCode = "status_code"
    }
}

struct JobListingBuilderResult: Codable {
    
    var toDate: String = ""
    var jobName: String = ""
    var tradeId: String = ""
    var tradeName: String = ""
    var specializationName: String? = ""
    var fromDate: String = ""
    var jobId: String = ""
    var jobDescription: String = ""
    var specializationId: String = ""
    var invitationId: String? = ""
    ///
    var isSelected: Bool? = false
    
    init() {}
    
    init(_ model: CreateJobModel) {
        
        jobName = model.jobName
        tradeId = model.categories?.id ?? ""
        tradeName = model.categories?.tradeName ?? ""
        jobId = model.jobId
        jobDescription = model.jobDescription
        isSelected = true
        if let fromDateObject = model.fromDate.date {
            fromDate = fromDateObject.localToUTC()
        }
        if let toDateObject = model.toDate.date {
            toDate = toDateObject.localToUTC()
        }
        ///
//        specializationName = model
//        invitationId = model
//        specializationId = model
        
    }
}


//MARK:- InvitationModel
//======================
struct InvitationModel: Codable {
    var status: Bool
    var statusCode: Int
    var message: String
    var result: InvitationResultModel
    
    enum CodingKeys: String, CodingKey {
        case status, message, result
        case statusCode = "status_code"
    }
}

struct InvitationResultModel: Codable {
    
    var invitationId: String
    var jobId: String
}
