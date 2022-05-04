//
//  QuestionModel.swift
//  Tickt
//
//  Created by Admin on 06/05/21.
//

import SwiftyJSON


struct GenericResponse : Codable {
    let message: String
    let statusCode: Int
    let status: Bool
    
    enum CodingKeys: String, CodingKey {
        case message, status
        case statusCode = "status_code"
    }
}

struct QuestionModel {
    let message: String
    let statusCode: Int
    let status: Bool
    var result: QuestionResultModel
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        message = json["message"].stringValue
        status = json["status"].boolValue
        statusCode = json["status_code"].intValue
        result = QuestionResultModel.init(json["result"])
    }
}

struct QuestionResultModel {
    var questionCount: Int
    var list: [QuestionResults]
    
    init() {
        self.init(JSON([:]))
    }

    init (_ json: JSON = JSON()) {
        questionCount = json["count"].intValue
        list = json["list"].arrayValue.map({QuestionResults.init($0)})
    }
}

struct QuestionResult {
    var questionData: QuestionData?
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        questionData = QuestionData.init(json["questionData"])
    }
}


struct QuestionResults {

    var updatedAt : String
    var tradieId : String
    var tradieData : [TradieData]
    var builderData : [BuilderFullData]
    var _id : String
    var answerSize : Int
    var question : String
    var isModifiable : Bool
    var createdAt : String
    var builderId : String
    var jobId : String
    var answers : [AnswerData]
    var isShowAll : Bool = false
    
    init() {
        self.init(JSON([:]))
    }

    init (_ json: JSON = JSON()) {
        
        updatedAt  = json["updatedAt"].stringValue
        tradieId  = json["tradieId"].stringValue
        _id  = json["_id"].stringValue
        answerSize  = json["answerSize"].intValue
        question  = json["question"].stringValue
        isModifiable  = json["isModifiable"].boolValue
        createdAt  = json["createdAt"].stringValue
        builderId  = json["builderId"].stringValue
        jobId = json["jobId"].stringValue
        answers = json["answers"].arrayValue.map({AnswerData.init($0)})
        tradieData = json["tradieData"].arrayValue.map({TradieData.init($0)})
        builderData = json["builderData"].arrayValue.map({BuilderFullData.init($0)})
    }
}

struct TradieData {
    
var tradieId: String?
var tradieImage: String?
var tradieName: String
var businessName:String?
var position: String?
    var firstName : String?

    
    init() {
        self.init(JSON([:]))
    }

    init (_ json: JSON = JSON()) {
        
        tradieId  = json["tradieId"].stringValue
        tradieImage  = json["tradieImage"].stringValue
        tradieName  = json["tradieName"].stringValue
        businessName  = json["businessName"].stringValue
        position  = json["position"].stringValue
        firstName  = json["firstName"].stringValue
        
    }
    
}

struct BuilderFullData {
    var businessName : String?
    var user_image : String?
    var position : String?
    var abn : String?
    var firstName : String?
    var email : String?
    var accountType : String?
    var country_code : String?
    var mobileNumber : String?
    var company_name : String?
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        businessName = json["businessName"].stringValue
        user_image = json["user_image"].stringValue
        position = json["position"].stringValue
        abn = json["abn"].stringValue
        firstName = json["firstName"].stringValue
        email = json["email"].stringValue
        accountType = json["accountType"].stringValue
        country_code = json["country_code"].stringValue
        mobileNumber = json["mobileNumber"].stringValue
        company_name = json["company_name"].stringValue
    }
}

struct QuestionData {
    let isModifiable: Bool?
    let questionId, userId, userImage, userName: String
    let date, question: String
    var answerData: AnswerData?
    var isAnswerShown: Bool?
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        isModifiable = json["isModifiable"].boolValue
        questionId = json["questionId"].stringValue
        userId = json["userId"].stringValue
        userImage = json["userImage"].stringValue
        userName = json["userName"].stringValue
        date = json["date"].stringValue
        question = json["question"].stringValue
        answerData = AnswerData.init(json["answerData"])
        isAnswerShown = json["isAnswerShown"].boolValue
    }
}

struct AskQuestion {
    let statusCode: Int
    let message: String
    let result: QuestionData?
    let status: Bool
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        message = json["message"].stringValue
        status = json["status"].boolValue
        statusCode = json["status_code"].intValue
        result = QuestionData.init(json["result"])
    }
}

struct AnswerData {
    var _id:String?
    var answer:String
    var tradie:[UserData]
    var builder:[UserData]
    var builderId:String
    var tradieId:String
    var updatedAt:String
    var createdAt:String
    var sender_user_type:Int
    
    init() {
        self.init(JSON([:]))
    }
    
    init (_ json: JSON = JSON()) {
        
        _id  = json["_id"].stringValue
        answer  = json["answer"].stringValue
        tradie  =  json["tradie"].arrayValue.map({UserData.init($0)})
        builder  = json["builder"].arrayValue.map({UserData.init($0)}) 
        builderId  = json["builderId"].stringValue
        tradieId  = json["tradieId"].stringValue
        createdAt  = json["createdAt"].stringValue
        updatedAt  = json["updatedAt"].stringValue
        sender_user_type  = json["sender_user_type"].intValue
    }
}

struct UserData {
    var firstName:String
    var email:String
    var _id:String
    var user_image:String
    
    init() {
        self.init(JSON([:]))
    }
    
    init (_ json: JSON = JSON()) {
        
        firstName  = json["firstName"].stringValue
        email  = json["email"].stringValue
        _id  = json["_id"].stringValue
        user_image  = json["user_image"].stringValue
    }
}

