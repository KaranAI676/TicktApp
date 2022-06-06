//
//  JobDetails.swift
//  Tickt
//
//  Created by Admin on 27/04/21.
//

import Foundation
import SwiftyJSON

struct JobDetailsModel {
    let message: String
    let statusCode: Int
    let status: Bool
    var result: JobDetailsData?
    
    enum CodingKeys: String, CodingKey {
        case message, result, status
        case statusCode = "status_code"
    }
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        message = json["message"].stringValue
        status = json["status"].boolValue
        statusCode = json["status_code"].intValue
        result = JobDetailsData.init(json["result"])
    }
}

struct JobDetailsData {
    let time: String?
    var isSaved: Bool?
    let editJob: Bool?
    let jobId: String?
    var quoteJob: Bool?
    let quoteCount:Int?
    let status: String?
    let toDate: String?
    let amount: String?
    var isInvited: Bool?
    let tradeId: String?
    let details: String?
    let jobName: String?
    let fromDate: String?
    let distance: Double?
    let duration: String?
    let jobStatus: String?
    let tradeName: String?
    let postedBy: PostedBy?
    var questionsCount: Int?
    let milestoneNumber: Int?
    let totalMilestones: Int?
    let locationName: String?
    let jobType: JobTypeData?
    var isChangeRequest: Bool?
    var appliedStatus: String?
    var quote: [JobDetailQuote]?
    let photos: [PhotosObject]?
    var alreadyApplyQuote: Bool?
    let applyButtonDisplay: Bool?
    let tradeSelectedUrl: String?
    let specializationId: String?
    var isCancelJobRequest: Bool?
    let specializationName: String?
    var reasonForCancelJobRequest: Int?
    let reasonForChangeRequest: [String]?
    var changeRequestDeclineReason: String?
    var reasonNoteForCancelJobRequest: String?
    let changeRequestData: [ChangeRequestData]?
    let jobMilestonesData: [JobMilestonesData]?
    let specializationData: [SpecializationData]?
    var rejectReasonNoteForCancelJobRequest: String?
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        time = json["time"].stringValue
        isSaved = json["isSaved"].boolValue
        editJob = json["editJob"].boolValue
        jobId = json["jobId"].stringValue
        quoteJob = json["quoteJob"].boolValue
        quoteCount = json["quoteCount"].intValue
        status = json["status"].stringValue
        toDate = json["toDate"].stringValue
        amount = json["amount"].stringValue
        isInvited = json["isInvited"].boolValue
        tradeId = json["tradeId"].stringValue
        details = json["details"].stringValue
        jobName = json["jobName"].stringValue
        fromDate = json["fromDate"].stringValue
        distance = json["distance"].doubleValue
        jobStatus = json["jobStatus"].stringValue
        duration = json["duration"].stringValue
        tradeName = json["tradeName"].stringValue
        postedBy = PostedBy.init(json["postedBy"])
        questionsCount = json["questionsCount"].intValue
        milestoneNumber = json["milestoneNumber"].intValue
        totalMilestones = json["totalMilestones"].intValue
        locationName = json["locationName"].stringValue
        jobType = JobTypeData.init(json["jobType"])
        isChangeRequest = json["isChangeRequest"].boolValue
        appliedStatus = json["appliedStatus"].stringValue
        quote =  json["quote"].arrayValue.map({JobDetailQuote.init($0)})
        photos = json["photos"].arrayValue.map({PhotosObject.init($0)})
        alreadyApplyQuote = json["alreadyApplyQuote"].boolValue
        applyButtonDisplay = json["applyButtonDisplay"].boolValue
        tradeSelectedUrl = json["tradeSelectedUrl"].stringValue
        specializationId = json["specializationId"].stringValue
        isCancelJobRequest = json["isCancelJobRequest"].boolValue
        specializationName = json["specializationName"].stringValue
        reasonForCancelJobRequest = json["reasonForCancelJobRequest"].intValue
        reasonForChangeRequest = json["reasonForChangeRequest"].arrayObject as? [String] ?? []
        changeRequestDeclineReason = json["changeRequestDeclineReason"].stringValue
        reasonNoteForCancelJobRequest = json["reasonNoteForCancelJobRequest"].stringValue
        changeRequestData =  json["changeRequestData"].arrayValue.map({ChangeRequestData.init($0)})
        jobMilestonesData = json["jobMilestonesData"].arrayValue.map({JobMilestonesData.init($0)})
        specializationData =  json["specializationData"].arrayValue.map({SpecializationData.init($0)})
        rejectReasonNoteForCancelJobRequest = json["rejectReasonNoteForCancelJobRequest"].stringValue
        
    }
}

struct JobDetailQuote {
    let tradieId: String?
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        tradieId = json["tradieId"].stringValue
    }
}

struct ChangeRequestData {
    let order: Int
    let id: String
    let status: Int
    let toDate: String?
    let fromDate: String
    let milestoneId: String?
    let milestoneName: String
    let isDeleteRequest: Bool?
    let isPhotoevidence: Bool?
    let recommendedHours: String?
    
    enum CodingKeys: String, CodingKey {
        case order, status, milestoneId, isDeleteRequest, isPhotoevidence
        case id = "_id"
        case toDate = "to_date"
        case fromDate = "from_date"
        case milestoneName = "milestone_name"
        case recommendedHours = "recommended_hours"
    }
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        order = json["order"].intValue
        id = json["_id"].stringValue
        status = json["status"].intValue
        toDate = json["toDate"].stringValue
        fromDate = json["fromDate"].stringValue
        milestoneId = json["milestoneId"].stringValue
        milestoneName = json["milestoneName"].stringValue
        isDeleteRequest = json["isDeleteRequest"].boolValue
        isPhotoevidence = json["isPhotoevidence"].boolValue
        recommendedHours = json["recommendedHours"].stringValue
    }
}

struct PhotosObject {
    let mediaType: Int
    let link: String
    let thumbnail: String?
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        mediaType = json["mediaType"].intValue
        link = json["link"].stringValue
        thumbnail = json["thumbnail"].stringValue
    }
}

struct PostedBy {
    let reviews: Int?
    let ratings: Double?
    let builderId: String?
    let builderName: String?
    let builderImage: String?
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        reviews = json["reviews"].intValue
        ratings = json["ratings"].doubleValue
        builderId = json["builderId"].stringValue
        builderName = json["builderName"].stringValue
        builderImage = json["builderImage"].stringValue
    }
}

struct JobMilestonesData {
    let status: Int?
    let fromDate: String?
    let toDate: String?
    let milestoneId: String
    let milestoneName: String?
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        status = json["status"].intValue
        fromDate = json["fromDate"].stringValue
        toDate = json["toDate"].stringValue
        milestoneId = json["milestoneId"].stringValue
        milestoneName = json["milestoneName"].stringValue
    }
    
}

struct SpecializationData {
    var specializationId: String
    var specializationName: String
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        specializationId = json["specializationId"].stringValue
        specializationName = json["specializationName"].stringValue
    }
}

struct JobTypeData {
    let jobTypeId: String
    let jobTypeName: String
    let jobTypeImage: String
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        jobTypeId = json["jobTypeId"].stringValue
        jobTypeName = json["jobTypeName"].stringValue
        jobTypeImage = json["jobTypeImage"].stringValue
    }
}
