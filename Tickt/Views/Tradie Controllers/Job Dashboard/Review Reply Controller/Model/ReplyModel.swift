//
//  ReplyModel.swift
//  Tickt
//
//  Created by Vijay's Macbook on 09/07/21.
//

struct ReplyModel: Codable {
    let result: ReplyResult?
    let status: Bool
    let statusCode: Int
    let message: String

    enum CodingKeys: String, CodingKey {
        case result, status
        case statusCode = "status_code"
        case message
    }
}

struct ReplyResult: Codable {
    //New Review
    let name: String?
    let date: String?
    let reply: String?
    let replyId: String?
    let reviewId: String?
    let userImage: String?
    
    let review: String?
    let status: Int?
    let id: String?
    let rating: Double?
    let comments: [CommentData]?
    let jobId: String?

    enum CodingKeys: String, CodingKey {
        case review, status, name, date, reply, replyId, reviewId, userImage
        case id = "_id"
        case rating, comments
        case jobId
    }
}

struct CommentData: Codable {
    let id: String?
    let comment: String?
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case comment = "comment"
    }
}
