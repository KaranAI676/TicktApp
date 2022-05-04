//
//  AllReviewModel.swift
//  Tickt
//
//  Created by Vijay's Macbook on 28/06/21.
//

import Foundation

struct AllReviewsModel: Codable {
    let status: Bool
    let message: String
    var result: AllReviewResult?
}

struct AllReviewResult: Codable {
    var count: Int?
    var list: [ReviewList]?
}

struct ReviewList: Codable {
    var reviewData: AllReviewData?
}

struct AllReviewData: Codable {
    let jobId: String?
    let userImage: String
    let review: String
    let rating: Double
    let date: String
    var replyData: ReplyData
    let reviewId, name: String
    let isModifiable: Bool
    var isReviewVisible: Bool? = false
}

struct ReplyData: Codable {
    let userImage: String?
    var reply: String?
    let date: String?
    let reviewId: String?
    var replyId: String?
    let name: String?
    let isModifiable: Bool?
}
