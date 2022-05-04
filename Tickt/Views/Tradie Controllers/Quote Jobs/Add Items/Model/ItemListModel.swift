//
//  ItemListModel.swift
//  Tickt
//
//  Created by Vijay's Macbook on 08/09/21.
//

import Foundation

struct ItemListModel: Codable {
    
}

struct ItemDetails: Codable {
    var id: String
    var status: Int
    var price: Double
    var quoteId: String
    var quantity: Int
    var itemNumber: Int
    var totalAmount: Double
    var description: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case itemNumber = "item_number"
        case description, price, quantity, totalAmount, status, quoteId
    }
}


