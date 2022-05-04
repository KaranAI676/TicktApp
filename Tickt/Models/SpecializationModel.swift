//
//  AnySpecialisationModel.swift
//  Tickt
//
//  Created by S H U B H A M on 08/03/21.
//

import Foundation
import SwiftyJSON

struct SpecializationModel {
    var id: String
    var status: Int
    var name: String
    var tradeID: String
    var sortBy: Int
    var isSelected: Bool?
    var isUploaded: Bool?
    var docType: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case status
        case name
        case tradeID = "tradeId"
        case sortBy = "sort_by"
        case isSelected, docType
    }
    
    init(_ json: JSON) {
        id = json["_id"].stringValue
        status = json["status"].intValue
        name = json["name"].stringValue
        tradeID = json["tradeId"].stringValue
        sortBy = json["sort_by"].intValue
        isSelected = json["isSelected"].boolValue
        docType = json["docType"].stringValue
        isUploaded = json["isUploaded"].boolValue
    }
    
    init() {
        self.init(JSON([:]))
        id = ""
        status = 0
        name = ""
        tradeID = ""
        sortBy = 0
        isSelected = false
        isUploaded = false
        docType = ""
    }
    
    init(id: String, status: Int, name: String, tradeID: String, sortBy: Int, isSelected: Bool, isUploaded: Bool, docType: String?) {
        self.id = id
        self.status = status
        self.name = name
        self.tradeID = tradeID
        self.sortBy = sortBy
        self.isSelected = isSelected
        self.isUploaded = isUploaded
        self.docType = docType
    }
    
    init(model: RepublishSpecialisation) {
        id = model.specializationId
        status = 0
        name = model.specializationName
        tradeID = ""
        sortBy = 0
        isSelected = true
        isUploaded = false
        docType = ""
    }
}
