//
//  AnswerDataModel.swift
//  Tickt
//
//  Created by S H U B H A M on 14/06/21.
//

import Foundation
import SwiftyJSON

struct AnswerDataModel {
    var message: String
    let status_code: Int
    let status: Bool
    let result: AnswerData
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        message = json["message"].stringValue
        status = json["status"].boolValue
        status_code = json["status_code"].intValue
        result = AnswerData.init(json["result"])
    }
}

struct AnswerDatasModel {
    var message: String
    let status_code: Int
    let status: Bool
    let result: AnswerDataResult
    
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        message = json["message"].stringValue
        status = json["status"].boolValue
        status_code = json["status_code"].intValue
        result = AnswerDataResult.init(json["result"])
    }
}

struct AnswerDataResult {
    let status_code: Bool
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        status_code = json["status_code"].boolValue
    }
}

struct ReplyDataModel {
    var message: String
    let status_code: Int
    let status: Bool
    let result: ReviewBuilderReplyData
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        message = json["message"].stringValue
        status = json["status"].boolValue
        status_code = json["status_code"].intValue
        result = ReviewBuilderReplyData.init(json["result"])
    }
}

//===================
//MARK:- Review Model
//===================
struct ReviewListBuilderModel {
    
    let message: String
    let statusCode: Int
    let status: Bool
    var result: ReviewListResultBuilderModel
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        message = json["message"].stringValue
        status = json["status"].boolValue
        statusCode = json["status_code"].intValue
        result = ReviewListResultBuilderModel.init(json["result"])
    }
    
}

struct ReviewListResultBuilderModel {
    var reviewCount: Int
    var list: [ReviewListBuilderResultModel]
    
    init() {
        self.init(JSON([:]))
    }
    
    init (_ json: JSON = JSON()) {
        reviewCount = json["count"].intValue
        list = json["list"].arrayValue.map({ReviewListBuilderResultModel.init($0)})
    }
}

struct ReviewListBuilderResultModel {
    var reviewData: ReviewBuilderDataModel
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        reviewData = ReviewBuilderDataModel.init(json["reviewData"])
    }
}

struct ReviewBuilderDataModel {
    
    var userImage: String
    var review: String
    var rating: Double
    var date: String
    var replyData: ReviewBuilderReplyData
    var reviewId: String
    var name: String
    var isModifiable: Bool
    var isAnswerShown: Bool?
    
    init() {
        self.init(JSON([:]))
        userImage = ""
        review = ""
        rating = 0.0
        date = ""
        replyData = ReviewBuilderReplyData()
        reviewId = ""
        name = ""
        isModifiable = false
        isAnswerShown = false
    }
    
    init(_ json: JSON) {
        userImage = json["userImage"].stringValue
        review = json["review"].stringValue
        rating = json["rating"].doubleValue
        date = json["date"].stringValue
        replyData = ReviewBuilderReplyData.init(json["replyData"])
        reviewId = json["reviewId"].stringValue
        name = json["name"].stringValue
        isModifiable = json["isModifiable"].boolValue
        isAnswerShown = json["isAnswerShown"].boolValue
    }
}

struct ReviewBuilderReplyData {
    var userImage: String? = nil
    var reply: String? = nil
    var date: String? = nil
    var reviewId: String? = nil
    var replyId: String? = nil
    var name: String? = nil
    var isModifiable: Bool? = false
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json: JSON) {
        userImage = json["userImage"].stringValue
        reply = json["reply"].stringValue
        date = json["date"].stringValue
        reviewId = json["reviewId"].stringValue
        replyId = json["replyId"].stringValue
        name = json["name"].stringValue
        isModifiable = json["isModifiable"].boolValue
    }
}
