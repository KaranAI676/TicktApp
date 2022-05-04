//
//  MyQuoteModel.swift
//  Tickt
//
//  Created by Vijay's Macbook on 24/09/21.
//

import Foundation

struct MyQuoteModel: Codable {
    let result: MyQuoteResult
    let status: Bool
    let message: String
}

struct MyQuoteResult: Codable {
    let resultData: [MyQuoteData]
}

struct MyQuoteData: Codable {
    let selectedUrl: String?
    let tradieImage: String?
//    let amount: String
    let status, locationName: String
    let quoteItem: [ItemDetails]
    let duration: String?
    let id: String
    let jobName: String?
    let totalQuoteAmount: Double?
    let reviewCount: Int?
    let tradeName, tradieName: String?
    let rating: Double?
    let jobId, userId: String

    enum CodingKeys: String, CodingKey {
        case selectedUrl = "selected_url"
        case tradieImage, status
        case locationName = "location_name"
//        case amount
        case quoteItem = "quote_item"
        case duration
        case id = "_id"
        case jobName, totalQuoteAmount, reviewCount, jobId, userId
        case tradeName = "trade_name"
        case tradieName, rating
    }
}
