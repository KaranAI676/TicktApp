//
//  ItemDetailsModel.swift
// Tickt
//
//  Created by Admin on 12/06/21.
//  Copyright © 2021Tickt. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ItemDetailsChatModel {
   
    var jobId: String
    var jobName: String
    var tradieId: String
    var username: String
    var builderId: String
    var profileImage: String
    
    init(withJSON json: JSON) {
        jobId = json["jobId"].stringValue
        jobName = json["jobName"].stringValue
        tradieId = json["tradieId"].stringValue
        username = json["username"].stringValue
        builderId = json["builderId"].stringValue
        profileImage = json["profileImage"].stringValue
    }
    
    init(_jobId: String, _jobName: String, _tradieId: String, _builderId: String, _profileImage: String, _username: String) {
        jobId = _jobId
        jobName = _jobName
        tradieId = _tradieId
        username = _username
        builderId = _builderId
        profileImage = _profileImage
    }
}
