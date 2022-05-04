//
//  EditProfileDetailsBuilderModel.swift
//  Tickt
//
//  Created by S H U B H A M on 27/06/21.
//

import Foundation

struct EditProfileDetailsBuildeModel: Codable {
    var status: Bool
    var message: String
    var statusCode: Int
    var result: EditProfileDetailsModel
    
    enum CodingKeys: String, CodingKey {
        case status, message, result
        case statusCode = "status_code"
    }
}

struct EditProfileDetailsModel: Codable {
    var userId: String = ""
    var position: String? = ""
    var fullName: String = ""
    var email: String = ""
    var mobileNumber: String = ""
    var companyName: String? = ""
    var businessName: String? = ""
    var userType: Int = 0
    var abn: String? = ""
    var qualificationDoc: [QualificationDoc]? = []
}

struct QualificationDoc: Codable {
    let url: String
    let docName: String?
    let qualificationId: String
    var isSelected: Bool?
    var isUploaded: Bool?
    var docType: String?
    
    enum CodingKeys: String, CodingKey {
        case url, docName, isSelected, docType, isUploaded
        case qualificationId = "qualification_id"
    }
}
