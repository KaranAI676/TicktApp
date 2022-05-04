//
//  JobDashboardModel.swift
//  Tickt
//
//  Created by S H U B H A M on 06/05/21.
//

import Foundation
import SwiftyJSON

//MARK:- OPEN JOBS
//================
struct OpenJobModel {
    
    var result: OpenJobsResult
    var statusCode: Int
    var message: String
    var status: Bool
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        message = json["message"].stringValue
        status = json["status"].boolValue
        statusCode = json["status_code"].intValue
        result = OpenJobsResult.init(json["result"])
    }
}

struct OpenJobsResult {
    
    var needApprovalCount: Int?
    var newApplicantsCount: Int?
    var open: [OpenJobs]?
    
    init() {
        self.init(JSON([:]))
        self.needApprovalCount = 0
        self.newApplicantsCount = 0
        self.open = [OpenJobs]()
    }
    
    init(_ json: JSON) {
        needApprovalCount = json["needApprovalCount"].intValue
        newApplicantsCount = json["newApplicantsCount"].intValue
        open = json["open"].arrayValue.map({OpenJobs.init($0)})
    }
}
struct OpenJobs {
    
    var timeLeft: String
    var tradeName: String
    var totalMilestones: Int
    var tradieId: String
    var tradeId: String
    var status: String
    var amount: String
    var total: String
    var tradieImage: String?
    var specializationName: String
    var tradeSelectedUrl: String
    var jobName: String
    var specializationId: String
    var jobId: String
    var durations: String
    var fromDate: String
    var toDate: String?
    var isApplied: Bool
    var milestoneNumber: Int
    var quoteJob = false
    var quoteCount:Int
    
    init() {
        self.init(JSON([:]))
    }
    
    
    init(_ json: JSON) {
        timeLeft = json["timeLeft"].stringValue
        tradeName = json["tradeName"].stringValue
        totalMilestones = json["totalMilestones"].intValue
        tradieId = json["tradieId"].stringValue
        tradeId = json["tradeId"].stringValue
        status = json["status"].stringValue
        amount = json["amount"].stringValue
        total = json["total"].stringValue
        tradieImage = json["tradieImage"].stringValue
        specializationName = json["specializationName"].stringValue
        tradeSelectedUrl = json["tradeSelectedUrl"].stringValue
        jobName = json["jobName"].stringValue
        specializationId = json["specializationId"].stringValue
        jobId = json["jobId"].stringValue
        durations = json["durations"].stringValue
        fromDate = json["fromDate"].stringValue
        toDate = json["toDate"].stringValue
        isApplied = json["isApplied"].boolValue
        milestoneNumber = json["milestoneNumber"].intValue
        quoteJob = json["quoteJob"].boolValue
        quoteCount = json["quoteCount"].intValue
    }
}


//MARK:- PAST JOBS
//================
struct PastJobModel {
    
    var result: PastJobsResults
    var statusCode: Int
    var message: String
    var status: Bool
    
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        message = json["message"].stringValue
        status = json["status"].boolValue
        statusCode = json["status_code"].intValue
        result = PastJobsResults.init(json["result"])
    }
}

struct PastJobsResults {
    
    var newApplicantsCount: Int
    var needApprovalCount: Int
    var past: [PastJobs]?
    
    init() {
        self.init(JSON([:]))
        self.needApprovalCount = 0
        self.newApplicantsCount = 0
        self.past = [PastJobs]()
    }
    
    init(_ json: JSON) {
        newApplicantsCount = json["newApplicantsCount"].intValue
        needApprovalCount = json["needApprovalCount"].intValue
        past = json["past"].arrayValue.map({PastJobs.init($0)})
    }
}

struct PastJobs {
    
    var jobId: String
    var tradieId: String
    var tradieImage: String?
    var tradeName: String?
    var jobName: String
    var specializationName: String
    var fromDate: String
    var toDate: String?
    var amount: String
    var locationName: String
    var status: String
    var milestoneNumber: Int
    var totalMilestones: Int
    var isRated: Bool
    var jobData: PastJobData?
    var tradieData: PastJobTradieData
    
    init() {
        self.init(JSON([:]))
        self.jobId = ""
        self.tradieId = ""
        self.tradieImage = ""
        self.tradeName = ""
        self.jobName = ""
        self.specializationName = ""
        self.fromDate = ""
        self.toDate = ""
        self.amount = ""
        self.locationName = ""
        self.status = ""
        self.isRated = false
        self.milestoneNumber = 0
        self.totalMilestones = 0
        self.jobData = PastJobData()
        self.tradieData = PastJobTradieData()
    }
    
    init(_ json: JSON) {
        jobId = json["jobId"].stringValue
        tradieId = json["tradieId"].stringValue
        tradieImage = json["tradieImage"].stringValue
        tradeName = json["tradeName"].stringValue
        jobName = json["jobName"].stringValue
        specializationName = json["specializationName"].stringValue
        fromDate = json["fromDate"].stringValue
        toDate = json["toDate"].stringValue
        amount = json["amount"].stringValue
        locationName = json["locationName"].stringValue
        status = json["status"].stringValue
        milestoneNumber = json["milestoneNumber"].intValue
        totalMilestones = json["totalMilestones"].intValue
        isRated = json["isRated"].boolValue
        jobData = PastJobData.init(json["jobData"])
        tradieData = PastJobTradieData.init(json["tradieData"])
        
    }
}

struct PastJobData {
    
    var jobId: String?
    var tradeSelectedUrl: String?
    var tradeName: String?
    var fromDate: String?
    var toDate: String?
    var jobName: String?
    
    init() {
        self.init(JSON([:]))
        self.jobId = ""
        self.tradeSelectedUrl = ""
        self.tradeName = ""
        self.fromDate = ""
        self.toDate = ""
        self.jobName = nil
    }
    
    init(_ json: JSON) {
        jobId = json["jobId"].stringValue
        tradeSelectedUrl = json["tradeSelectedUrl"].stringValue
        tradeName = json["tradeName"].stringValue
        fromDate = json["fromDate"].stringValue
        toDate = json["toDate"].stringValue
        jobName = json["jobName"].stringValue
    }
    
    init(jobName: String, data: PastJobData) {
        self.jobId = data.jobId
        self.tradeSelectedUrl = data.tradeSelectedUrl
        self.tradeName = data.tradeName
        self.fromDate = data.fromDate
        self.toDate = data.toDate
        self.jobName = jobName
    }
    
    init(jobId: String, jobName: String, tradeImage: String, tradeName: String, fromDate: String, toDate: String) {
        self.jobId = jobId
        self.tradeSelectedUrl = tradeImage
        self.tradeName = tradeName
        self.fromDate = fromDate
        self.toDate = toDate
        self.jobName = jobName
    }
}

struct PastJobTradieData {
    
    var tradieId: String?
    var tradieImage: String?
    var tradieName: String?
    var reviews: Int?
    var ratings: Double?
    
    init() {
        self.init(JSON([:]))
        self.tradieId = ""
        self.tradieImage = ""
        self.tradieName = ""
        self.reviews = 0
        self.ratings = 0
    }
    
    init(_ json: JSON) {
        tradieId = json["tradieId"].stringValue
        tradieImage = json["tradieImage"].stringValue
        tradieName = json["tradieName"].stringValue
        reviews = json["reviews"].intValue
        ratings = json["ratings"].doubleValue
    }
    
    init(tradieId: String, tradieImage: String, tradieName: String, reviews: Int, rating: Double) {
        self.tradieId = tradieId
        self.tradieImage = tradieImage
        self.tradieName = tradieName
        self.reviews = reviews
        self.ratings = rating
    }
}


//==================
//MARK:- ACTIVE JOBS
//==================
struct ActiveJobModel {
    
    var statusCode: Int
    var message: String
    var status: Bool
    var result: ActiveJobsResults
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        message = json["message"].stringValue
        status = json["status"].boolValue
        statusCode = json["status_code"].intValue
        result = ActiveJobsResults.init(json["result"])
    }
}

struct ActiveJobsResults {
    
    var needApprovalCount: Int
    var newApplicantsCount: Int
    var milestonesCount: Int?
    var active: [ActiveJobs]?
    
    init() {
        self.init(JSON([:]))
        self.needApprovalCount = 0
        self.newApplicantsCount = 0
        self.milestonesCount = 0
        self.active = [ActiveJobs]()
    }
    
    init(_ json: JSON) {
        needApprovalCount = json["needApprovalCount"].intValue
        newApplicantsCount = json["newApplicantsCount"].intValue
        milestonesCount = json["milestonesCount"].intValue
        active = json["active"].arrayValue.map({ActiveJobs.init($0)})
    }
}

struct ActiveJobs {
    
    var timeLeft: String
    var tradeName: String
    var milestoneNumber: Int
    var tradieId: String
    var totalMilestones: Int
    var amount: String
    var status: String
    var total: String
    var tradieImage: String?
    var specializationName: String
    var tradeId: String
    var jobName: String
    var jobId: String
    var approvalCount: Int?
    var specializationId: String
    var tradeSelectedUrl: String
    var durations: String
    var fromDate: String
    var toDate: String?
    var needApproval: Bool?
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        timeLeft = json["timeLeft"].stringValue
        tradeName = json["tradeName"].stringValue
        milestoneNumber = json["milestoneNumber"].intValue
        tradieId = json["tradieId"].stringValue
        totalMilestones = json["totalMilestones"].intValue
        amount = json["amount"].stringValue
        status = json["status"].stringValue
        total = json["total"].stringValue
        tradieImage = json["tradieImage"].stringValue
        specializationName = json["specializationName"].stringValue
        tradeId = json["tradeId"].stringValue
        jobName = json["jobName"].stringValue
        jobId = json["jobId"].stringValue
        approvalCount = json["approvalCount"].intValue
        specializationId = json["specializationId"].stringValue
        tradeSelectedUrl = json["tradeSelectedUrl"].stringValue
        durations = json["durations"].stringValue
        fromDate = json["fromDate"].stringValue
        toDate = json["toDate"].stringValue
        needApproval = json["needApproval"].boolValue
    }
}

//====================
//MARK:- Republish Job
//====================
struct RepublishJobModel {
    
    var statusCode: Int
    var message: String
    var status: Bool
    var result: RepublishJobResult
    
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        message = json["message"].stringValue
        status = json["status"].boolValue
        statusCode = json["status_code"].intValue
        result = RepublishJobResult.init(json["result"])
    }
}

struct RepublishJobResult {
    
    var categories: [RepublishCategory]
    var amount: Double
    var fromDate: String
    var toDate: String
    var payType: String
    var location: LocationObject
    var locationName: String
    var milestones: [MilestonesObject]
    var specialization: [RepublishSpecialisation]
    var urls: [PhotosObject]
    var jobName: String
    var jobDescription: String
    var jobType: [RepublishJobType]
    var isQuoteJob:Bool
    
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        categories = json["categories"].arrayValue.map({RepublishCategory.init($0)})
        amount = json["amount"].doubleValue
        fromDate = json["from_date"].stringValue
        toDate = json["to_date"].stringValue
        payType = json["pay_type"].stringValue
        location = LocationObject.init(json["location"])
        locationName = json["location_name"].stringValue
        milestones = json["milestones"].arrayValue.map({MilestonesObject.init($0)})
        specialization = json["specialization"].arrayValue.map({RepublishSpecialisation.init($0)})
        urls = json["urls"].arrayValue.map({PhotosObject.init($0)})
        jobName = json["jobName"].stringValue
        jobDescription = json["job_description"].stringValue
        jobType = json["job_type"].arrayValue.map({RepublishJobType.init($0)})
        isQuoteJob = json["quoteJob"].boolValue
    }
}

struct MilestonesObject {
    
    var status: Int
    var id: String
    var isPhotoevidence: Bool
    var milestoneName: String
    var recommendedHours: String
    var declinedCount: Int?
    var fromDate: String?
    var toDate: String?
    var order: Int
    
    enum CodingKeys: String, CodingKey {
        case status, isPhotoevidence, order
        case id = "_id"
        case milestoneName = "milestone_name"
        case recommendedHours = "recommended_hours"
        case declinedCount = "declined_count"
        case fromDate = "from_date"
        case toDate = "to_date"
    }
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        status = json["status"].intValue
        id = json["_id"].stringValue
        isPhotoevidence = json["isPhotoevidence"].boolValue
        milestoneName = json["milestone_name"].stringValue
        recommendedHours = json["recommended_hours"].stringValue
        declinedCount = json["declinedCount"].intValue
        fromDate = json["from_date"].stringValue
        toDate = json["to_date"].stringValue
        order = json["order"].intValue
    }
}

struct LocationObject {
    
    var type: String
    var coordinates: [Double]
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        type = json["type"].stringValue
        coordinates = json["coordinates"].arrayObject as? [Double] ?? []
    }
}

struct RepublishJobType {
    
    var jobTypeId: String
    var jobTypeName: String
    var jobTypeImage: String
    
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        jobTypeId = json["jobTypeId"].stringValue
        jobTypeName = json["jobTypeName"].stringValue
        jobTypeImage = json["jobTypeImage"].stringValue
    }
}

struct RepublishSpecialisation {
    
    var specializationName: String
    var specializationId: String
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        specializationName = json["specializationName"].stringValue
        specializationId = json["specializationId"].stringValue
    }
}

struct RepublishCategory: Codable {
    
    var categoryId: String
    var categoryName: String
    var categorySelectedUrl: String
    
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        categoryId = json["categoryId"].stringValue
        categoryName = json["categoryName"].stringValue
        categorySelectedUrl = json["categorySelectedUrl"].stringValue
    }
}
