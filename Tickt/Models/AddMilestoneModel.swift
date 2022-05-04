//
//  AddMilestoneModel.swift
//  Tickt
//
//  Created by S H U B H A M on 24/03/21.
//

import Foundation

struct MilestoneModel: Equatable {
    
    var isSelected: Bool = false
    var milestoneName: String = ""
    var isPhotoevidence: Bool = false
    var fromDate = MilestoneDates()
    var toDate = MilestoneDates()
    var displayDateFormat: String = ""
    var recommendedHours: String = ""
    var order: Int = 0
    ///
    var milestoneId: String? = nil
    var status: Int? = nil
    var isEdit: Bool? = true
    var isDragged: Bool? = false
    var dotColor: UIColor? = .clear
    
    init() {}
    
    init(_ milestone: MilestonesModel) {
        self.isSelected = false
        self.milestoneName = milestone.milestoneName
        self.isPhotoevidence = false
        self.fromDate = MilestoneDates(milestone.fromDate)
        self.toDate = MilestoneDates(milestone.toDate ?? "")
        self.recommendedHours = "\(milestone.recommendedHours)"
        self.order = milestone.order
        self.milestoneId = milestone.milestoneId
        ///displayDateFormat
        if let fromDate = fromDate.date {
            self.displayDateFormat = CommonFunctions.getFormattedDates(fromDate: fromDate, toDate: nil)
        }
        if let fromDate = fromDate.date, let toDate = toDate.date {
            self.displayDateFormat = CommonFunctions.getFormattedDates(fromDate: fromDate, toDate: toDate)
        }
    }
    
    init(_ model: CheckApprovedMilestones) {
        isSelected = false
        milestoneName = model.milestoneName
        isPhotoevidence = model.isPhotoevidence
        fromDate = MilestoneDates(model.fromDate)
        toDate = MilestoneDates(model.toDate ?? "")
        displayDateFormat = CommonFunctions.getFormattedDates(fromDate: fromDate.date, toDate: toDate.date)
        recommendedHours = model.recommendedHours
        order = model.order
        ///
        milestoneId = model.milestoneId
        status = model.status
        isEdit = false
    }
    
    init(_ model: MilestonesObject) {
        isSelected = false
        milestoneName = model.milestoneName
        isPhotoevidence = model.isPhotoevidence
        fromDate = MilestoneDates(model.fromDate ?? "")
        toDate = MilestoneDates(model.toDate ?? "")
        displayDateFormat = CommonFunctions.getFormattedDates(fromDate: model.fromDate?.convertToDateAllowsNil(), toDate: model.toDate?.convertToDateAllowsNil())
        recommendedHours = model.recommendedHours
        order = model.order
        ///
        milestoneId = model.id
        status = model.status
    }
    
    static func == (lhs: MilestoneModel, rhs: MilestoneModel) -> Bool {
        lhs.milestoneName == rhs.milestoneName && lhs.isPhotoevidence == rhs.isPhotoevidence && lhs.fromDate == rhs.fromDate && lhs.toDate == rhs.toDate && lhs.recommendedHours == rhs.recommendedHours && lhs.milestoneId == rhs.milestoneId
    }
}

struct MilestoneDates: Equatable {
    
    var backendFormat: String = ""
    var date: Date? = nil
    
    init() {
        backendFormat = ""
        date = nil
    }
    
    init(_ dateString: String) {
        self.date = dateString.toDate(dateFormat: Date.DateFormat.yyyyMMddTHHmmssSSSZ.rawValue)?.removeTimeStamp()
        if let date = date {
            self.backendFormat = date.toString(dateFormat: Date.DateFormat.yyyy_MM_dd.rawValue)
        }
    }
    
    static func == (lhs: MilestoneDates, rhs: MilestoneDates) -> Bool {
        lhs.backendFormat == rhs.backendFormat && lhs.date == rhs.date
    }
}
