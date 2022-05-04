//
//  AddTradiePortfolio.swift
//  Tickt
//
//  Created by Vijay's Macbook on 02/07/21.
//

import Foundation

struct AddTradiePortfolioModel: Codable {
    var status: Bool
    var message: String
    var result: TradiePortfolioDetail
}

struct TradiePortfolioDetail: Codable {
    let jobName: String?
    let portfolioId: String?
    let jobDescription: String?
    let portfolioImage: [String]?
}
