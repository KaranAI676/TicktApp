//
//  LodgeDisputeModel.swift
//  Tickt
//
//  Created by S H U B H A M on 12/06/21.
//

import Foundation

struct LodgeDisputeModel {
    
    var reasonType: ReasonsType? = nil
    var disputeReasonType: DisputeReason? = nil
    var jobName: String = ""
    var jobId: String = ""
    var detail: String = ""
    var images: [UIImage] = []
    var imageUrls: [String] = []
}
