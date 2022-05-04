//
//  ReviewModel.swift
//  Tickt
//
//  Created by Vijay's Macbook on 18/06/21.
//

import Foundation

struct ReviewModel: Codable {
    let message: String
    let status: Bool
    let result: ReviewResult?
}

struct ReviewResult: Codable {
    let reviewId: String
    let builderId: String
    let review: String
    let jobId: String
    let rating: Double
}
