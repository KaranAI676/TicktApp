//
//  ConfirmAndPayPaymentBuilderModel.swift
//  Tickt
//
//  Created by S H U B H A M on 18/06/21.
//

import Foundation

struct CardListModel: Codable {
    
    var status: Bool
    var message: String
    var statusCode: Int
    var result: [CardListResultModel]
    
    enum CodingKeys: String, CodingKey {
        case status, message, result
        case statusCode = "status_code"
    }
}

struct CardListResultModel: Codable {
    
    var cardId: String
    var funding: String
    var expMonth: Int
    var brand: String
    var last4: String
    var name: String
    var expYear: Int
    ///
    var isSelected: Bool? = false
    
    enum CodingKeys: String, CodingKey {
        case cardId, funding, brand, last4, name, isSelected
        case expMonth = "exp_month"
        case expYear = "exp_year"
    }
    
    init(_ model: CardAddedResultModel) {
        cardId = model.id
        funding = model.funding
        expMonth = model.expMonth
        brand = model.brand
        last4 = model.last4
        name = model.name
        expYear = model.expYear
    }
}
