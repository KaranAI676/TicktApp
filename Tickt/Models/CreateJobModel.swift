//
//  CreateJobModel.swift
//  Tickt
//
//  Created by S H U B H A M on 25/03/21.
//

import UIKit
import Foundation
import GooglePlaces

struct CreateJobModel {
    var jobName: String = ""
    var categories: TradeList? = nil
    var jobType = [ResulDateObject]()
    var jobLocation = JobLocation()
    var specialisation: [SpecializationModel]?
    var jobDescription: String = ""
    var paymentAmount: String = ""
    var paymentType: PaymentType = .perHour
    var isQuoteJob : Bool=false
    var fromDate = MilestoneDates()
    var toDate = MilestoneDates()
    var milestones = [MilestoneModel]()
    var mediaUrls = [MediaUploadableObject]()
    var mediaImages = [UploadMediaObject]()
    ///
    var republishCategories: RepublishCategory?
    var allTradeModel: TradeModel?
    var allJobType = JobTypeModel()
    var jobId: String = ""
    
    init() {}
    
    
    init(model: RepublishJobResult) {
        isQuoteJob = model.isQuoteJob
        jobName = model.jobName
        jobType = model.jobType.map({ eachModel -> ResulDateObject in
            return ResulDateObject(model: eachModel)
        })
        republishCategories = model.categories.first
        jobLocation = JobLocation(model: model.location, locationName: model.locationName)
        specialisation = model.specialization.map({ eachModel -> SpecializationModel in
            return SpecializationModel(model: eachModel)
        })
        jobDescription = model.jobDescription
        paymentType = PaymentType.init(rawValue: model.payType) ?? .perHour
        paymentAmount = "\(model.amount)"
        fromDate = MilestoneDates(model.fromDate)
        toDate = MilestoneDates(model.toDate)
        ///
        milestones = model.milestones.compactMap({ eachModel -> MilestoneModel? in
            return MilestoneModel(eachModel)
        })
        ///
        
        mediaImages = model.urls.compactMap({ eachModel -> UploadMediaObject? in
            if let mediaType = MediaTypes.init(rawValue: eachModel.mediaType) {
                switch mediaType {
                case .image:
                    return (image: UIImage(), type: .image, videoUrl: nil, finalUrl: "", mimeType: .imageJpeg, genericUrl: eachModel.link, genericThumbnail: nil)
                case .video:
                    return (image: UIImage(), type: .video, videoUrl: nil, finalUrl: "", mimeType: .videoMp4, genericUrl: eachModel.link, genericThumbnail: eachModel.thumbnail)
                case .doc:
                    if let index = eachModel.link.lastIndex(of: ".") {
                        let _extension = eachModel.link[index...]
                        switch String(_extension) {
                        case ".doc":
                            return (image: #imageLiteral(resourceName: "DOC-1"), type: .doc, videoUrl: nil, finalUrl: "", mimeType: .msword, genericUrl: eachModel.link, genericThumbnail: nil)
                        case ".txt":
                            return (image: #imageLiteral(resourceName: "TXT-1"), type: .doc, videoUrl: nil, finalUrl: "", mimeType: .textPlain, genericUrl: eachModel.link, genericThumbnail: nil)
                        case ".rtf":
                            return (image: #imageLiteral(resourceName: "RTF"), type: .doc, videoUrl: nil, finalUrl: "", mimeType: .rtf, genericUrl: eachModel.link, genericThumbnail: nil)
                        default:
                            return nil
                        }
                    }else {
                        return nil
                    }
                case .pdf:
                    return (image: #imageLiteral(resourceName: "PDF-1"), type: .pdf, videoUrl: nil, finalUrl: "", mimeType: .pdf, genericUrl: eachModel.link, genericThumbnail: nil)
                }
            }else {
                return nil
            }
        })
    }
    
}

struct JobLocation: Codable {
    
    var locationName: String = ""
    var locationType: String = ""
    var isCurrentLocation: Bool = false
    var locationCanDisplay: Bool = true
    var locationLat: CLLocationDegrees = Double()
    var locationLong: CLLocationDegrees = Double()
    
    init() {}
    
    init(model: LocationObject, locationName: String) {
        self.locationName = locationName
        locationType = model.type
        isCurrentLocation = false
        locationCanDisplay = false
        if model.coordinates.count > 1 {
//            locationLat = model.coordinates[0]
//            locationLong = model.coordinates[1]
            locationLat = model.coordinates[1]
            locationLong = model.coordinates[0]

        }
    }
}

struct JobTypeModel: Codable {
    var message: String = ""
    var status: Bool = false
    var statusCode: Int = 0
    var result = ResultData()
    enum CodingKeys: String, CodingKey {
        case message, status, result
        case statusCode = "status_code"
    }
}

struct ResultData: Codable {
    var resultData = [ResulDateObject]()
}

struct ResulDateObject: Codable {
    var status: Int = 0
    var id: String = ""
    var image: String = ""
    var description: String = ""
    var name: String = ""
    var sortBy: Int = 0
    var isSelected: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case name, description, image, status
        case id = "_id"
        case sortBy = "sort_by"
    }
    
    init(model: RepublishJobType) {
        status = 0
        id = model.jobTypeId
        image = model.jobTypeImage
        description = ""
        name = model.jobTypeName
        sortBy = 0
        isSelected = true
    }
}
