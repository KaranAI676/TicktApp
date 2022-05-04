//
//  SignupModel.swift
//  Tickt
//
//  Created by Admin on 08/03/21.
//
  
import UIKit

struct SignupModel {
    var name = ""
    var email = ""
    var password = ""
    var position = ""
    var abnNumber = ""
    var businessName = ""
    var phoneNumber = ""
    var companyName = ""
    var profileImage = ""
    var qualificationDocument = ""
    var tradeList: [TradeList] = []
    var qualifications: [SpecializationModel] = []
    var specializations: [SpecializationModel] = []
    var location: [Double] = [144.491327, -37.9701477]//Longitude , Latitude
    var docImages: [(Data, String, Int, String, String)] = [] //Data, FileName, Index, Id, FileType
}

struct SearchModel {
    var page = 1
    var sortBy: SortingType?
    var toDate = ""
    var payType = ""
    var fromDate = ""
    var tradeName = ""
    var minBudget = 0.0
    var maxBudget = 0.0
    var locationName = ""
    var tradeId: [String] = []
    var jobTypes: [String] = []
    var specializationName = ""
    var isSliderSelected = false
    var specializationId: [String] = []
    var location: [Double] = Array(repeating: 0.0, count: 2)
}

//37.8136, 144.9631
