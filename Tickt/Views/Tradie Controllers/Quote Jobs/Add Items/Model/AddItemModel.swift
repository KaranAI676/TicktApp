//
//  AddItemModel.swift
//  Tickt
//
//  Created by Vijay's Macbook on 24/09/21.
//

import Foundation

struct AddItemModel: Codable {
    let result: AddItemResult
    let status: Bool
    let message: String
}

struct AddItemResult: Codable {
    let resultData: ItemDetails
}

