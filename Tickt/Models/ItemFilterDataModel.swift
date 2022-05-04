//
//  ItemFilterDataModel.swift
//  Tickt
//
//  Created by Admin on 09/03/21.
//  Copyright © 2021 Tickt. All rights reserved.
//


import Foundation
import CoreLocation
import UIKit.UIImage

extension Float {

    func zeroFormat() -> String {
        return String(format: "%.2f", self)
    }
    
    func priceLocaleFormat() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.decimalSeparator = "."
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: self as NSNumber) ?? self.zeroFormat()
    }
}

extension Double {
    
    func checkDecimalZeroAndGiveFormat() -> String {
        let intDouble = Double(Int(self))
        if (self - intDouble).isZero {
            return Int(self).description
        }
        return self.zeroFormat()
    }

    func zeroFormat() -> String {
        return String(format: "%.2f", self)
    }
    
    func priceLocaleFormat() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.decimalSeparator = "."
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: self as NSNumber) ?? self.checkDecimalZeroAndGiveFormat()
    }
}

protocol APIParsableProtocol: Codable {
    init()
}

extension APIParsableProtocol {
    public init(block: (Self) -> Void) {
        self.init()
        block(self)
    }
}


enum SortingData: Int, CaseIterable {
    case mostHired = 0, closestToMe, minimumHire, mostFavourites, experiencesOnly, highestRatedSupplier, verifiedBusinessOnly, none
            
    var title: String {
        switch self {
        case .mostHired:
            return LS.mostHired
        case .closestToMe:
            return LS.closestToMe
        case .minimumHire:
            return LS.minimumHireLower
        case .mostFavourites:
            return LS.mostFavouritesLower
        case .experiencesOnly:
            return LS.experiencesOnlyLower
        case .highestRatedSupplier:
            return LS.highestRatedSupplier
        case .verifiedBusinessOnly:
            return LS.verifiedBusinessOnly
        case .none:
            return ""
        }
    }
    
    func getImage(_ isSelected: Bool) -> UIImage? {
        switch self {
        case .mostHired:
            return isSelected ? #imageLiteral(resourceName: "squareFilterMostHired") : #imageLiteral(resourceName: "squareFilterMostHiredUnselected")
        case .closestToMe:
            return isSelected ? #imageLiteral(resourceName: "filterClosestToMeSelected") : #imageLiteral(resourceName: "filterClosestToMe")
        case .minimumHire:
            return isSelected ? #imageLiteral(resourceName: "squareFilterMinimumHireSelected") : #imageLiteral(resourceName: "squareFilterMinimumHire")
        case .mostFavourites:
            return isSelected ? #imageLiteral(resourceName: "filterMostFavoritesSelected") : #imageLiteral(resourceName: "filterMostFavorites")
        case .experiencesOnly:
            return isSelected ? #imageLiteral(resourceName: "filterExperienceOnlySelected") : #imageLiteral(resourceName: "filterExperienceOnly")
        case .highestRatedSupplier:
            return isSelected ? #imageLiteral(resourceName: "filterHighestRatedSelected") : #imageLiteral(resourceName: "filterHighestRated")
        case .verifiedBusinessOnly:
            return isSelected ? #imageLiteral(resourceName: "filterHighestRatedSelected") : #imageLiteral(resourceName: "filterHighestRated")
        case .none: return nil
        }
    }
    
    var sortIndex: Int {
        switch self {
        case .mostHired:
            return 1
        case .closestToMe:
            return 6
        case .minimumHire:
            return 2
        case .mostFavourites:
            return 4
        case .experiencesOnly:
            return 5
        case .highestRatedSupplier:
            return 3
        case .verifiedBusinessOnly:
            return 7
        case .none:
            return -1
        }
    }
}

protocol ItemDataBookmarkDelegate: AnyObject {
    func bookmarkUpdation(model: ItemDataModel)
}

enum ItemTagTypes: Int {
    case mostHired = 1
    case minimumHire = 2
    case highestRated = 3
    case mostFavourites = 4
    case experiencesOnly = 5
    case closetToMe = 6
    case none
    
    var title: String {
        switch self {
        case .mostHired:
            return LS.mostHiredCaps
        case .minimumHire:
            return LS.minimumHire
        case .highestRated:
            return LS.highestRated
        case .mostFavourites:
            return LS.mostFavourites
        case .experiencesOnly:
            return LS.experiencesOnly
        case .closetToMe:
            return LS.closetToMe
        case .none:
            return ""
        }
    }
}

struct ItemDataModelList: APIParsableProtocol {
    
    var itemsArr: [ItemDataModel] = []
    var limit: Int
    var nextHit: Int
    var pageNo: Int = 1
    var total: Int
    var totalPage: Int
    var lastSuccessPage: Int = 0

    //MARK:- CodingKey Enum
    //=====================
    enum CodingKeys: String, CodingKey {
        case itemsArr = "list", total, pageNo, totalPage, nextHit, limit
    }
    
    //MARK:- Initializers
    //===================
    init() {
        self.itemsArr = []
        self.total = 0
        self.pageNo = 1
        self.totalPage = 0
        self.nextHit = 0
        self.limit = 10
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.itemsArr = try container.decode([ItemDataModel].self, forKey: .itemsArr)
        self.total = try container.decode(Int.self, forKey: .total)
        self.pageNo = try container.decode(Int.self, forKey: .pageNo)
        self.totalPage = try container.decode(Int.self, forKey: .totalPage)
        self.nextHit = try container.decode(Int.self, forKey: .nextHit)
        self.limit = try container.decode(Int.self, forKey: .limit)
    }
    
    @discardableResult
    mutating func updateItemBookmarkStatus(id: String, isBookmark: Bool) -> ItemDataModel? {
        if let itemIndex = self.itemsArr.firstIndex(where: {$0.id == id}) {
            self.itemsArr[itemIndex].updateBookmarkStatus(isBookmark: isBookmark)
            return self.itemsArr[itemIndex]
        }
        return nil
    }
    
    mutating func addItemIntoList(model: ItemDataModel) {
        self.itemsArr.insert(model, at: 0)
        if self.itemsArr.count > 5 {
            self.itemsArr.removeLast()
        }
    }
    
    mutating func removeItemFromList(id: String) {
        if let itemIndex = self.itemsArr.firstIndex(where: {$0.id == id}) {
            self.itemsArr.remove(at: itemIndex)
        }
    }
    
    mutating func updateDataModel(model: ItemDataModelList) {
        self.total = model.total
        if self.pageNo == 1 {
            self.itemsArr.removeAll()
        }
        self.itemsArr.append(contentsOf: model.itemsArr)
        self.pageNo += 1
        self.lastSuccessPage = model.pageNo
        self.totalPage = model.totalPage
        self.nextHit = model.nextHit
        self.limit = 10
    }
    
    mutating func reInitializeDataModel(model: ItemDataModelList) {
        self.total = model.total
        self.itemsArr.removeAll()
        self.itemsArr.append(contentsOf: model.itemsArr)
        self.pageNo += 1
        self.lastSuccessPage = model.pageNo
        self.totalPage = model.totalPage
        self.nextHit = model.nextHit
        self.limit = 10
    }

    
    mutating func nextPageHitSetUp() {
        self.pageNo = self.lastSuccessPage + 1
    }
    
    mutating func pullToRefreshSetUp() {
        self.total = 0
        self.pageNo = 1
        self.totalPage = 0
        self.nextHit = 0
    }
}

struct ItemDataModel: APIParsableProtocol {
    let id: String
    let itemName: String
    let itemDescription: String
    let userId: String
    let distance: Double
    var distanceString: String {
        return distance.priceLocaleFormat()
    }
    let rating: Float
    let reviewTag: String
    let itemTag: Int
    let itemTagTypes: ItemTagTypes
    let media: [Media]
    private (set) var price: [PriceModel]
    var bookMarked: Bool
    var remainingItems: Int64 = 0
    var instantBooking: Bool = false
    var pickUpLocation: LocationDataModel?
    
    //MARK:- CodingKey Enum
    //=====================
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case itemName
        case itemDescription
        case userId
        case distance
        case rating
        case media
        case price
        case bookMarked
        case remainingItems
        case instantBooking
        case reviewTag
        case itemTag
        case pickUpLocation
    }
    
    //MARK:- Initializers
    //===================
    init() {
        self.id = ""
        self.itemName = ""
        self.itemDescription = ""
        self.userId = ""
        self.distance = 0
        self.rating = 0
        self.media = []
        self.price = []
        self.bookMarked = false
        self.reviewTag = ""
        self.itemTag = -1
        self.itemTagTypes = .none
        self.pickUpLocation = nil

    }
    
    init(_ itemDetailsModel: ItemDetailsModel) {
        self.id = itemDetailsModel.id
        self.itemName = itemDetailsModel.itemName
        self.itemDescription = itemDetailsModel.itemDescription
        self.userId = itemDetailsModel.userID
        self.distance = 0
        self.rating = 0
        self.media = itemDetailsModel.media
        self.price = itemDetailsModel.price
        self.bookMarked = itemDetailsModel.bookMarked
        self.remainingItems = 0
        self.instantBooking = itemDetailsModel.instantBooking
        self.reviewTag = itemDetailsModel.reviewTag
        self.itemTag = -1
        self.itemTagTypes = .none
        self.pickUpLocation = nil
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.itemName = try container.decode(String.self, forKey: .itemName)
        self.itemDescription = try container.decode(String.self, forKey: .itemDescription)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.distance = try container.decodeIfPresent(Double.self, forKey: .distance) ?? 0
        self.rating = try container.decodeIfPresent(Float.self, forKey: .rating) ?? 0.0
        self.media = try container.decode([Media].self, forKey: .media)
        self.price = try container.decode([PriceModel].self, forKey: .price)
        if self.price.isEmpty {
            self.price = [PriceModel()]
        }
        self.bookMarked = try container.decode(Bool.self, forKey: .bookMarked)
        self.remainingItems = try container.decodeIfPresent(Int64.self, forKey: .remainingItems) ?? 0
        self.instantBooking = try container.decodeIfPresent(Bool.self, forKey: .instantBooking) ?? false
        self.reviewTag = try container.decode(String.self, forKey: .reviewTag)
        self.itemTag = try container.decode(Int.self, forKey: .itemTag)
        self.itemTagTypes = ItemTagTypes.init(rawValue: self.itemTag) ?? .none
        self.pickUpLocation = try container.decodeIfPresent(LocationDataModel.self, forKey: .pickUpLocation)
    }
    
    mutating func updateBookmarkStatus(isBookmark: Bool) {
        self.bookMarked = isBookmark
    }
}

struct BookmarkItemDataModel: APIParsableProtocol {
    let id: String
    let bookMarked: Bool
    var remainingItems: Int64 = 0
    
    //MARK:- CodingKey Enum
    //=====================
    enum CodingKeys: String, CodingKey {
        case id = "_id", bookMarked, remainingItems
    }
    
    //MARK:- Initializers
    //===================
    init() {
        self.id = ""
        self.bookMarked = false
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.bookMarked = try container.decode(Bool.self, forKey: .bookMarked)
        self.remainingItems = try container.decodeIfPresent(Int64.self, forKey: .remainingItems) ?? 0
    }
}

struct Media: APIParsableProtocol {

    let url: String
    let thumbnailImage: String
    let type: Int
    let mediaType: MediaType
    var getMediaImage: String {
        return self.mediaType == .image ? self.url : self.thumbnailImage
    }
    
    
    //MARK:- CodingKey Enum
    //=====================
    enum CodingKeys: String, CodingKey {
        case url
        case thumbnailImage
        case type
    }
    
    //MARK:- Initializers
    //===================
    init() {
        self.url = CommonStrings.emptyString
        self.type = 0
        self.thumbnailImage = CommonStrings.emptyString
        self.mediaType = .image
    }
    
    init(imageUrl: String) {
        self.url = imageUrl
        self.type = 1
        self.thumbnailImage = CommonStrings.emptyString
        self.mediaType = .image
    }
    
    init(videoUrl: String, thumbnailUrl: String) {
        self.url = videoUrl
        self.type = 2
        self.thumbnailImage = thumbnailUrl
        self.mediaType = .video
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try container.decode(String.self, forKey: .url)
        self.thumbnailImage = try container.decodeIfPresent(String.self, forKey: .thumbnailImage) ?? ""
        self.type = try container.decode(Int.self, forKey: .type)
        self.mediaType = MediaType.init(rawValue: self.type) ?? .image
    }
}


enum PriceType: Int {
    case day = 1
    case week = 2
    case month = 3
    case year = 4
}

struct PriceModel: APIParsableProtocol {
    let amount: Double
    let type: Int
    let priceType: PriceType
    var priceInLocaleFormat: String {
        self.amount.priceLocaleFormat()
    }
    var getPriceString: String {
        switch self.priceType {
        case .day:
            return CommonStrings.dollar + self.priceInLocaleFormat + CommonStrings.whiteSpace + CommonStrings.forwdSlash + CommonStrings.whiteSpace + LS.day
        case .week:
            return CommonStrings.dollar + self.priceInLocaleFormat + CommonStrings.whiteSpace + CommonStrings.forwdSlash + CommonStrings.whiteSpace + LS.week
        case .month:
            return CommonStrings.dollar + self.priceInLocaleFormat + CommonStrings.whiteSpace + CommonStrings.forwdSlash + CommonStrings.whiteSpace + LS.month
        case .year:
            return CommonStrings.dollar + self.priceInLocaleFormat + CommonStrings.whiteSpace + CommonStrings.forwdSlash + CommonStrings.whiteSpace + LS.year
        }
    }
    
    //MARK:- CodingKey Enum
    //=====================
    enum CodingKeys: String, CodingKey {
        case amount, type
    }
    
    //MARK:- Initializers
    //===================
    init() {
        self.amount = 0.00
        self.type = 1
        self.priceType = .day
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.amount = try container.decodeIfPresent(Double.self, forKey: .amount) ?? 0.0
        self.type = try container.decode(Int.self, forKey: .type)
        self.priceType = PriceType.init(rawValue: self.type) ?? .day
    }
}


struct LocationDataModel: Codable {
    
    //MARK:- Variables
    //================
    let address: String
    let coordinates: [Double]
    let latitude: Double
    let longitude: Double
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case address, coordinates, latitude, longitude, type
    }
    
    //MARK:- Initializers
    //===================
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.address = try container.decodeIfPresent(String.self, forKey: .address) ?? CommonStrings.emptyString
        self.coordinates = try container.decodeIfPresent([Double].self, forKey: .coordinates) ?? []
        self.latitude = try container.decodeIfPresent(Double.self, forKey: .latitude) ?? 0
        self.longitude = try container.decodeIfPresent(Double.self, forKey: .longitude) ?? 0
        self.type = try container.decodeIfPresent(String.self, forKey: .type) ?? CommonStrings.emptyString
    }
}

struct ItemDetailsModel: Codable {
    
    let id: String
    let instantBooking: Bool
    let bookMarksUsers, hireCount: Int
    let itemName: String
    let media: [Media]
    let itemDescription: String
    let pickUpDaysAndTime: [PickUpDaysAndTime]
    let price: [PriceModel]
    let minimumHireDuration: MinimumHireDuration
    let pickUpLocation: PickUpLocation
    let userID: String
    let itemConditionNotes: String
    var bookMarked: Bool
    let shareURL, reviewTag: String
    var questions: Questions
    let supplierRating: SupplierRating
    var dayPriceModel: PriceModel? {
        self.price.first(where: {$0.priceType == .day})
    }
    var weekPriceModel: PriceModel? {
        self.price.first(where: {$0.priceType == .week})
    }
    var monthPriceModel: PriceModel? {
        self.price.first(where: {$0.priceType == .month})
    }
    var yearPriceModel: PriceModel? {
        self.price.first(where: {$0.priceType == .year})
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case instantBooking, bookMarksUsers, hireCount, itemName, media, itemDescription, pickUpDaysAndTime, price, minimumHireDuration, pickUpLocation
        case userID = "userId"
        case itemConditionNotes, bookMarked
        case shareURL = "shareUrl"
        case reviewTag, questions, supplierRating
    }
}

// MARK: - MinimumHireDuration
struct MinimumHireDuration: Codable {
    let value, type: Int
    
    var priceType: PriceType {
        return PriceType.init(rawValue: type) ?? .day
    }
}

// MARK: - PickUpDaysAndTime
struct PickUpDaysAndTime: Codable {
    let startTime, endTime: Int
    let day: String
    var timeText: String {
        return self.startTimeInHour.description + CommonStrings.whiteSpace + CommonStrings.dash + CommonStrings.whiteSpace + self.endTimeInHour.description
    }
    var startTimeInHour: String {
        if let date = Date.createTime(hour: 0, minute: self.startTime, second: 0) {
            let startTimeInFormat = date.toString(dateFormat: Date.DateFormat.MMMdyyyyHHmma.rawValue)
            return startTimeInFormat
        } else {
            var time = Double(self.startTime)/60.0
            let abervation = CommonStrings.whiteSpace + (time > 12 ? LS.pm : LS.am)
            time = time > 12 ? 24 - time : time
            return time.zeroFormat() + abervation
        }
    }
    
    var endTimeInHour: String {
        if let date = Date.createTime(hour: 0, minute: self.endTime, second: 0) {
            let endTimeInFormat = date.toString(dateFormat: Date.DateFormat.MMMdyyyyHHmma.rawValue)
            return endTimeInFormat
        } else {
            var time = Double(self.endTime)/60.0
            let abervation = CommonStrings.whiteSpace + (time > 12 ? LS.pm : LS.am)
            time = time > 12 ? 24 - time : time
            return time.zeroFormat() + abervation
        }
    }
}

// MARK: - PickUpLocation
struct PickUpLocation: Codable {
    let type: String
    let coordinates: [Double]
    let address, city, state: String
    let latitude, longitude: Double
}

// MARK: - Questions
struct Questions: Codable {
    var totalQuestion, newQuestion: Int
    
    init() {
        self.totalQuestion = 0
        self.newQuestion = 0
    }
    
    mutating func updateData(model: Questions) {
        self.totalQuestion = model.totalQuestion
        self.newQuestion = model.newQuestion
    }
    
    mutating func increaseCounts() {
        self.increaseTotalQuestionCount()
        self.increaseNewQuestionCounts()
    }
    
    mutating func decreaseCounts() {
        self.decreaseTotalQuestionCount()
        self.decreaseNewQuestionCounts()
    }
    
    mutating func increaseTotalQuestionCount() {
        self.totalQuestion += 1
    }
    
    mutating func increaseNewQuestionCounts() {
        self.newQuestion += 1
    }
    
    mutating func decreaseTotalQuestionCount() {
        guard self.totalQuestion >= 0 else { return }
        self.totalQuestion -= 1
    }
    
    mutating func decreaseNewQuestionCounts() {
        guard self.newQuestion >= 0 else { return }
        self.newQuestion -= 1
    }
}

// MARK: - SupplierRating
struct SupplierRating: Codable {
    let userID, name, userType, profilePicture: String
    let rating: Double
    let totalHireItem: Int
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case name, userType, profilePicture, rating, totalHireItem
    }
}
