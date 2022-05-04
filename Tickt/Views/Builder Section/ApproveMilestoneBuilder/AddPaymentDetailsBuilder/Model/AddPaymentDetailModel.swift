//
//  AddPaymentDetailModel.swift
//  Tickt
//
//  Created by S H U B H A M on 18/06/21.
//

import Foundation

struct AddPaymentDetailBuilderModel {

    var cardNumber: String
    var holderName: String
    var expirationDate: String
    var expirationMonth: Int
    var expirationYear: Int
    var cvv: String
    ///
    var cardId: String
    
    init() {
        cardNumber = ""
        holderName = ""
        expirationDate = ""
        cvv = ""
        expirationMonth = 0
        expirationYear = 0
        cardId = ""
    }
    
    init(_ model: CardListResultModel) {
        cardNumber = model.last4
        holderName = model.name
        expirationDate = String(format:"%02i/%02i", model.expMonth, abs(2000 - model.expYear))
        expirationMonth = model.expMonth
        expirationYear = Date().plus(years: UInt(abs(Date().year - model.expYear))).toString(dateFormat: "YY").intValue
        cvv = "000"
        cardId = model.cardId
    }
}

//MARK:- Card Added Model
struct CardAddedModel: Codable {
    
    var status: Bool
    var message: String
    var statusCode: Int
    var result: CardAddedResultModel
    
    enum CodingKeys: String, CodingKey {
        case status, message, result
        case statusCode = "status_code"
    }
}

struct CardAddedResultModel: Codable {
    
    var id: String
    var funding: String
    var expMonth: Int
    var brand: String
    var last4: String
    var name: String
    var expYear: Int
    ///
    var isSelected: Bool? = false
    
    enum CodingKeys: String, CodingKey {
        case id, funding, brand, last4, name, isSelected
        case expMonth = "exp_month"
        case expYear = "exp_year"
    }
    
    init(_ model: CardListResultModel) {
        id = model.cardId
        funding = model.funding
        expMonth = model.expMonth
        brand = model.brand
        last4 = model.last4
        name = model.name
        expYear = model.expYear
    }
}
