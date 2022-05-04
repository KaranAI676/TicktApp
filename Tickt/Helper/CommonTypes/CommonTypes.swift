//
//  CommonEnums.swift
//  Tickt
//
//  Created by S H U B H A M on 21/05/21.
//

import Foundation

typealias tradeSpecial = (image: String, name: String, type: TradeSpecialEnum)
typealias MediaUploadableObject = (thumbnail: String?, mediaLink: String, mediaType: MediaTypes)
typealias UploadMediaObject = (image: UIImage, type: MediaTypes, videoUrl: URL?, finalUrl: String, mimeType: MimeTypes, genericUrl: String?, genericThumbnail: String?)

enum TradeSpecialEnum {
    case trade
    case specialisation
}

enum AcceptDecline {
    case accept
    case decline
    
    var tag: Int {
        switch self {
        case .accept:
            return 1
        case .decline:
            return 2
        }
    }
    
    var statusDesc: String {
        switch self {
        case .accept:
            return "This is accepted"
        case .decline:
            return "This is rejected"
        }
    }
}

enum JobDashboardTabs {
    case active
    case past
    case open
}

enum ResponseType {
    case willHit
    case success
    case failure
}

enum JobStatus: String {
    case open = "OPEN"
    case active = "ACTIVE"
    case expired = "EXPIRED"
    case pending = "PENDING"
    case inactive = "INACTIVE"
    case approved = "APPROVED"
    case awaiting = "AWAITING"
    case completed = "COMPLETED"
    case cancelled = "CANCELLED"
    case pendingDispute = "PENDING_DISPUTE"    
    case cancelledApply = "cancelledApply"
    case paymentPending = "Pending"
    case paymentComming = "Comming"
    case paymentApproved = "Approved"
    case needApproval = "NEEDS APPROVAL"
    case cancelledJob = "CANCELLED JOB"
    case requestAccepted = "Request Accepted"
}

enum RedirectStatus: Int {
    case past = 1
    case active = 2
    case new = 3    
}

enum MilestoneStatus: Int {
    case notComplete = 0
    case completed = 1
    case approved = 2
    case declined = 3
    case changeRequest = 4
    case changeRequestAccepted = 5
}

enum CRMessages: String {
    case added = "Some milestones are added"
    case updated = "Some milestone details are updated."
    case deleted = "Some milestones are deleted."
    case rearranged = "Milestones are reordered."
}

enum PaymentType: String {
    
    case perHour = "Per hour"
    case fixedPrice = "Fixed price"
    
    var tag: String {
        switch self {
        case .perHour:
            return "p/h"
        case .fixedPrice:
            return "f/p"
        }
    }
}
