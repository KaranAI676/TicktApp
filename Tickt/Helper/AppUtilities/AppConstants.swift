//
//  AppConstants.swift
//  NowCrowdApp
//
//  Created by Admin on 15/06/20.
//  Copyright © 2020 Admin2020. All rights reserved.
//

import Foundation
import UIKit

var k_RealmSchemaVersion: UInt64 = 4
var k_maxFrameRate: Int32 = 60
var k_defaultVideoSize = CGSize(width: 540, height: 960)
let K_API_KEY = "AIzaSyAR9z9V9-gBXAYc0iuBeuDhTqkYd9YMltA"
let max_Limit_Api_Response:Int = 20

let kUserDefaults = UserDefaults.standard
let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height
let kTimeZone = TimeZone.current.identifier
let kAppDelegate = UIApplication.shared.delegate as! AppDelegate

//var exportPreset = AVAssetExportPreset960x540
//var scExportPreset: String {
//
//    switch exportPreset {
//    case AVAssetExportPresetLowQuality:
//        return SCPresetLowQuality
//    case AVAssetExportPresetMediumQuality:
//        return SCPresetMediumQuality
//    case AVAssetExportPreset960x540:
//        return SCPreset960x540
//    default:
//        return SCPresetHighestQuality
//    }
//}
//
//var videoSettings:[String : Any] {
//    return [
//        AVVideoCodecKey : AVVideoCodecType.h264,
//        AVVideoScalingModeKey: AVVideoScalingModeResizeAspect,
//        AVVideoWidthKey: k_defaultVideoSize.width,
//        AVVideoHeightKey: k_defaultVideoSize.height,
//        AVVideoCompressionPropertiesKey: [
//            AVVideoAverageBitRateKey: 1900000, //Previously 1900000
//            AVVideoProfileLevelKey: AVVideoProfileLevelH264HighAutoLevel,
//            AVVideoH264EntropyModeKey: AVVideoH264EntropyModeCABAC,
//            AVVideoMaxKeyFrameIntervalKey: k_maxFrameRate
//        ],
//    ]
//}
//
//var audioSettings:[String : Any] {
//    return [
//        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
//        AVNumberOfChannelsKey: 2,
//        AVSampleRateKey: 44100,
//        AVEncoderBitRateKey: 128000,
//    ]
//}

enum AppConstants : String {
//    case poolIDAWS = "us-east-1:b1f250f2-66a7-4d07-96e9-01817149a439"
	case googleAPIKey = "AIzaSyCYVGa50KuwOcTs35CsRYUjMpHZ7zS_-VY"//"AIzaSyAB0RM8qn8nTq5p-0EoqeHEiRYmz7yRUG0" //"AIzaSyAw7-pyEPZIjisG8q4YHHjUXji3Xcfk4nw"
    case googlePlaceKey = "AIzaSyD9xVqVmWv1Z-L9WxWt4MUTwhoK5nhGI_w"
	case stripePublishableKey = "pk_test_uv7ZoexVvjjzPn1LGmqW0NGR" //ClientAccountTest
	case stripeSecretKey = "sk_test_7mvoCTwidIgfeF3WzzLvDa2K"      //ClientAccountTest
//	case stripePublishableKey = "pk_live_Vmjx9btQMQx8IMWuE6vXxZCf" //ClientAccountLive
//	case stripeSecretKey = "sk_live_VtbZydLjbGy2jzzuiLlm8Hbz00UnEQebdL"      //ClientAccountLive
	case s3AccessKey =  "AKIA6DQMUBGGY6CUWRG4"//"AKIAXKAEDW4N4CEJLK4A"//"AKIA6DQMUBGGY6CUWRG4"//"AKIA6DQMUBGG4IRED37R"//"AKIAJ3UHQTWRRT2AH3RA"
	case s3SecretKey = "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"//"XyUo83HbFu2dJAnpM8IQTGr3S+P1AoPtqzfMeyfZ"
    case mixPanelTokenKey = "680419d7d082a4a189516eb21001e636"//"0c7b46f7975446ef685fb7ef582ef7ff"
    
    //InterCom
    case getIntercomApiKey = "ios_sdk-11f041b6eb37d470561d82d0db6d9b74c1a101f6"
    case getIntercomAppId = "tvbm4bhr"
}


struct Validation {
    static let errorMandatoryField = "This field is mandatory"
    static let errorEmptyOTP = "Please enter OTP"
    static let errorEmptyReview = "Please write a review"
    static let errorEmptyRating = "Please rate the builder"
    static let errorEmptyField = "This field can't be left empty"
    static let invalidABNNumber = "Please enter valid ABN number"
    static let invalidBSBNumber = "Please enter valid BSB number"
    static let errorEmptyFirstName = "Please enter first name"
    static let errorEmptyLastName = "Please enter last name"
    static let errorProfileImage = "Please select profile image"
    static let errorEnterOldPassword = "Please enter old password"
    static let errorEnterNewPassword = "Please enter new password"
    static let errorEnterConfirmPassword = "Please enter confirm password"
    static let errorEmptyCountry = "Please select country"
    static let errorEmptyPhoneNumber = "Please enter phone number"
    static let errorEmptyCountryField = "Please select Country"
    static let errorNotNumeric = "Please enter numbers"
    static let errorPhoneLength = "Phone Number should be between 8 to 15 digits"
    static let errorPhotoEmpty = "Please select at least one photos."
    static let errorEmptyUsername = "Please enter username"
    static let invalidUserName = "Invalid name"
    static let errorNameInvalid = "Please enter valid name"
    static let invalidPhoneNumber = "Invalid phone number"
    static let errorNameLength = "Name should be between 3 to 10 characters"
    static let errorEmptyName = "Please enter full name"
    static let errorTermsAndCondition = "Please agree to Terms & Conditions"
    static let errorSelectTrade = "Please select a trade"
    static let errorSelectLocation = "Please select location"
    static let errorEmailEmpty = "Please enter your email address"
    static let verifyMobileNumber = "Mobile number is not verified"
    static let errorEmailInvalid = "Please enter valid email address"
    static let errorPasswordEmpty = "Please enter password"
    static let errorConfirmPasswordEmpty = "Please enter confirm password"
    static let errorSpecializationEmpty = "Please select at least one specialisation"
    static let errorCompanyEmpty = "Company name can't be empty"
    static let errorPositionEmpty = "Position can't be empty"
    static let errorAbnNumber = "ABN number should be of 11 digits"
    static let errorEmptyQuestion = "Question can't be left empty."
    static let errorEmptyAnswer = "Answer can't be left empty."
    static let errorEmptyReviewEdit = "Review can't be left empty."
    static let errorEmptyStartDate = "Please select start date"
    static let errorSelectAccount = "Please select bank account"
    
    static let errorEmptyAccountName = "Account name can't be left empty"
    static let errorEmptyAccountNumber = "Account number can't be left empty"
    static let errorEmptyBSBNumber = "BSB number can't be left empty"
    
    static let errorEmptyDates = "Please select the dates"
    static let errorEmptyEndDate = "Please select end date"
    static let errorEmptyMaximumBudget = "Please enter maximum budget"
    static let errorAbnNumberEmpty = "ABN can't be empty"
    static let errorBusinessNameEmpty = "Business Name can't be empty"
    static let errorBusinessName = "Business Name should be greater than 3 digits"
    static let errorEmptyHour = "Please enter the estimated hours"
    static let errorInvalidHour = "Please select the valid estimated hours"
    static let errorPasswordInvalid = "Please ensure your password is at least 8 characters long and contains a special character or number"
    static let errorEmptyNote = "Please write decline reason"
    static let errorEnterPassword = "Please enter password"
    static let errorPasswordLength = "Password must contain at least 8 characters"
    static let errorPasswordLengthInvalid = "Password must contain characters between 8 to 50"
    static let errorEmptyDescription = "Description can't be left empty"
    static let errorValiPassword = "Please enter password in required format"
    static let errorPasswordMismatch = "Password and confirm password should be same"
    static let errorInvalidCountry = "Please select country"
    static let verifyID = "Please verify your id first"
    
}
