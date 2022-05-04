//
//  LS.swift
//  Tickt
//
//  Created by Admin on 22/03/21.
//


enum LS: String {

    // MARK: - App Title
    //===================
    case tickt = "tickt"
    
    // MARK: - UIViewController Extension
    //=================================
    static var chooseOptions: String { return "ChooseOptions".localized }
    static var camera: String { return "Camera".localized }
    static var addImage: String { return "addImage".localized }
    static var openCamera: String { return "openCamera".localized }
    static var appleMap: String { return "appleMap".localized }
    static var googleMap: String { return "googleMap".localized }
    static var cameraNotAvailable: String { return "CameraNotAvailable".localized }
    static var chooseImage: String { return "ChooseImage".localized }
    static var chooseFromGallery: String { return "ChooseFromGallery".localized }
    static var takePhoto: String { return "TakePhoto".localized }
    static var cancel: String { return "Cancel".localized }
    static var alert: String { return "Alert".localized }
    static var ok: String { return "ok".localized }
    static var or: String { return "or".localized }
    static var osClaimsItsMemoryByReleasing: String { return "osClaimsItsMemoryByReleasing" }
    static var settings: String { return "Settings".localized }
    static var termsCondition: String { return "termsCondition".localized }
    static var privacyPolicy: String { return "privacyPolicy".localized }
    static var emailVerifiedMessage: String { return "emailVerifiedMessage".localized }
    static var congratulations: String { return "congratulations".localized }
    static var youLoggedInWithDifferentAccount: String { return "youLoggedInWithDifferentAccount".localized }
    static var deviceIosVersionDoesntSupportAppleLogin: String { return "deviceIosVersionDoesntSupportAppleLogin".localized }
    static var restrictedFromUsingCamera: String { return "restrictedFromUsingCamera".localized }
    static var changePrivacySettingAndAllowAccessToCamera: String { return "restrictedFromUsingCamera".localized }
    static var restrictedFromUsingLibrary: String { return "restrictedFromUsingCamera".localized }
    static var changePrivacySettingAndAllowAccessToLibrary: String { return "restrictedFromUsingCamera".localized }
    static var changePrivacySettingAndAllowAccessToLocation: String { return "changePrivacySettingAndAllowAccessToLocation".localized }
    static var operationNotCompletedAlert: String { return "operationNotCompletedAlert".localized }
    static var userCancelledSignInFLow: String { return "userCancelledSignInFLow".localized }
    static var userCancelledSignUpFLow: String { return "userCancelledSignUpFLow".localized }
    static var signIn: String { return "signIn".localized }
    static var signUp: String { return "signUp".localized }
    static var getStarted: String { return "getStarted".localized }
    static var facebook: String { return "facebook".localized }
    static var google: String { return "google".localized }
    static var apple: String { return "apple".localized }
    static var dismiss: String { return "dismiss".localized }
    static var userNameWithWhiteSpace: String { return "userNameWithWhiteSpace".localized }
    static var passwordWithWhiteSpace: String { return "passwordWithWhiteSpace".localized }
    static var keychainCredentialReceived: String { return "keychainCredentialReceived".localized }
    static var noInternetConnection: String { return "noInternetConnection".localized }
    static var apiTimeOut: String { return "apiTimeOut".localized }
    static var theInternetAppearsOffline: String { return "theInternetAppearsOffline".localized }
    static var pleaseWriteComment: String { return "pleaseWriteComment".localized }
    static var selectedCredentialFromKeychain: String { return "selectedCredentialFromKeychain".localized }
    static var youCanNotChangeStartTimeAsEventHasAlreadyBeenStarted: String { return "youCanNotChangeStartTimeAsEventHasAlreadyBeenStarted".localized }
    static var pleaseCheckYourInternetConnection: String { return "pleaseCheckYourInternetConnection".localized }
    static var cameraAccessRequired: String { return "cameraAccessRequired".localized }
    static var allowCamera: String { return "allowCamera".localized }
    static var imageCaptureError: String { return "imageCaptureError".localized }
    static var youAreOnSimulator: String { return "youAreOnSimulator".localized }
    static var openSettingsToChangeLocation: String { return "openSettingsToChangeLocation".localized }
    static var locationIsNotEnabled: String { return "locationIsNotEnabled".localized }
    
    //MARK:- Onboarding
    //=================
    static var searchForEquipment: String { return "searchForEquipment".localized }
    static var andFindImpressions: String { return "andFindImpressions".localized }
    static var boostYourBusinessAndMakeSomeCash: String { return "boostYourBusinessAndMakeSomeCash".localized }
    static var forgottenYourPassword: String { return "forgottenYourPassword".localized }
    
    //MARK:- SignUp
    //=============
    static var enterEmailAddress: String { return "enterEmailAddress".localized }
    static var enterPassword: String { return "enterPassword".localized }
    static var password: String { return "password".localized }
    static var referralCode: String { return "referralCode".localized }
    static var enterReferralCode: String { return "enterReferralCode".localized }
    static var enterPhoneNumber: String { return "enterPhoneNumber".localized }
    static var enterYourNewPhoneNumber: String { return "enterYourNewPhoneNumber".localized }
    static var pleaseEnterPhoneNumber: String { return "pleaseEnterPhoneNumber".localized }
    static var phoneNumberShouldHaveMinimum6Digits: String { return "phoneNumberShouldHaveMinimum6Digits".localized }
    static var pleaseEnterEmailAddress: String { return "pleaseEnterEmailAddress".localized }
    static var pleaseEnterValidEmailAddress: String { return "pleaseEnterValidEmailAddress".localized }
    static var pleaseAcceptTermsAndPrivacyPolicy: String { return "pleaseAcceptTermsAndPrivacyPolicy".localized }
    static var pleaseEnterPassword: String { return "pleaseEnterPassword".localized }
    static var passwordMustBe8CharLong: String { return "passwordMustBe8CharLong".localized }
    static var pleaseEnterAValidReferralCode: String { return "pleaseEnterAValidReferralCode".localized }
    static var pleaseEnterOTP: String { return "pleaseEnterOTP".localized }
    static var pleaseEnterValidOTP: String { return "pleaseEnterValidOTP".localized }
    static var iAgreeToTheAirhireMePrivacyPolicyAndTermsConditions: String { return "iAgreeToTheAirhireMePrivacyPolicyAndTermsConditions".localized }
    static var oopsWeDidNotReceiveYourEmailFromSocialAccount: String { return "oopsWeDidNotReceiveYourEmailFromSocialAccount".localized }
    
    //MARK:- OTP
    //==========
    static var dontRcvCode: String { return "dontRcvCode".localized }
    static var reSendCode: String { return "reSendCode".localized }
    static var next: String { return "next".localized }
    
    //MARK:- Almost Done
    //==================
    static var enterFirstName: String { return "enterFirstName".localized }
    static var enterLastName: String { return "enterLastName".localized }
    static var enterAddress: String { return "enterAddress".localized }
    static var addYourID: String { return "addYourID".localized }
    static var verifyYourID: String { return "verifyYourID".localized }
    static var yourIDsAdded: String { return "yourIDsAdded".localized }
    static var yourIDIsVerified: String { return "yourIDIsVerified".localized }
    static var done: String { return "done".localized }
    static var dontWorryNobodyWillSeeYourID: String { return "dontWorryNobodyWillSeeYourID".localized }
    static var pleaseEnterFirstName: String { return "pleaseEnterFirstName".localized }
    static var pleaseEnterValidFirstName: String { return "pleaseEnterValidFirstName".localized }
    static var pleaseEnterLastName: String { return "pleaseEnterLastName".localized }
    static var pleaseEnterValidLastName: String { return "pleaseEnterValidLastName".localized }
    static var pleaseEnterYourAddress: String { return "pleaseEnterYourAddress".localized }
    static var pleaseAddYourID: String { return "pleaseAddYourID".localized }
    static var pleaseAddYourFrontID: String { return "pleaseAddYourFrontID".localized }
    static var pleaseAddYourBackID: String { return "pleaseAddYourBackID".localized }
    static var pleaseAddYourFace: String { return "pleaseAddYourFace".localized }
    static var firstNameShouldBeGreaterThan3Charecters: String { return "firstNameShouldBeGreaterThan3Charecters".localized }
    static var lastNameShouldBeGreaterThan3Charecters: String { return "lastNameShouldBeGreaterThan3Charecters".localized }
    static var idsFrontImage: String { return "idsFrontImage".localized }
    static var idsBackImage: String { return "idsBackImage".localized }
    static var yourFacePicture: String { return "yourFacePicture".localized }
    static var searchWithThreeDot: String { return "searchWithThreeDot".localized }
    static var addPhoneNumber: String { return "addPhoneNumber".localized }
    static var enterYourPhoneNumberForVerification: String { return "enterYourPhoneNumberForVerification".localized }
    static var phoneNumber: String { return "phoneNumber".localized }
    
    //MARK:- Add ID Screen
    //====================
    static var theBackPartOfID: String { return "theBackPartOfID".localized }
    static var theFrontPartOfID: String { return "theFrontPartOfID".localized }
    static var makeSureThatTheLightIsGoodAndPutTheBackPart: String { return "makeSureThatTheLightIsGoodAndPutTheBackPart".localized }
    static var makeSureThatTheLightIsGoodAndPutTheFrontPart: String { return "makeSureThatTheLightIsGoodAndPutTheFrontPart".localized }
    static var weCompareThePhotoOfYourFaceWithThePhotoOnTheDocuments: String { return "weCompareThePhotoOfYourFaceWithThePhotoOnTheDocuments".localized }
    static var takeAPhoto: String { return "takeAPhoto".localized }
    static var uploadFromGallery: String { return "uploadFromGallery".localized }
    static var confirm: String { return "confirm".localized }
    static var tryAgain: String { return "tryAgain".localized }
    static var idFrontPictureUploadedSuccessfully: String { return "idFrontPictureUploadedSuccessfully".localized }
    static var idBackPictureUploadedSuccessfully: String { return "idBackPictureUploadedSuccessfully".localized }
    static var faceIDPictureUploadedSuccessfully: String { return "faceIDPictureUploadedSuccessfully".localized }

    //MARK:- Categories
    //=================
    static var pleaseSelectAtLeastOneCategory: String { return "pleaseSelectAtLeastOneCategory".localized }
    
    //MARK:- Tutorials
    //================
    static var checkNotificationsAndAlweysStayUpdated: String { return "checkNotificationsAndAlweysStayUpdated".localized }
    static var hereWillBeAllYourBookings: String { return "hereWillBeAllYourBookings".localized }
    static var hi: String { return "hi".localized }
    static var welcomeDiscoverEquipmentsHereAndFindTheBestToHaveGreatTime: String { return "welcomeDiscoverEquipmentsHereAndFindTheBestToHaveGreatTime".localized }
    static var hiJohnWelcomeDiscoverEquipmentsHereAndFindTheBestToHaveGreatTime: String { return "hiJohnWelcomeDiscoverEquipmentsHereAndFindTheBestToHaveGreatTime".localized }
    static var addItemsAndStartEarnMoney: String { return "addItemsAndStartEarnMoney".localized }
    static var hereIsThePalceToChatWithOthers: String { return "hereIsThePalceToChatWithOthers".localized }
    static var yourProfile: String { return "yourProfile".localized }
    static var skip: String { return "skip".localized }
    
    //MARK:- Home
    //===========
    static var whatDoYouWantToDo: String { return "whatDoYouWantToDo".localized }
    static var searchHere: String { "searchHere".localized }
    static var logout: String { "logout".localized }
    static var areYouSureWantToLogout: String { "areYouSureWantToLogout".localized }
    static var uploading: String { "uploading".localized }
    static var pleaseWaitImageIsUploading: String { "pleaseWaitImageIsUploading".localized }
    static var banner: String { "banner".localized }
    static var categories: String { "categories".localized }
    static var yourSavedItems: String { "yourSavedItems".localized }
    static var adventureStories: String { "adventureStories".localized }
    static var getOutdoorsThisWeekend: String { "getOutdoorsThisWeekend".localized }
    static var getOutdoorsThisWeekendWithNewLine: String { "getOutdoorsThisWeekendWithNewLine".localized }
    static var allAroundMe: String { "allAroundMe".localized }
    static var all: String { "all".localized }
    static var day: String { "day".localized }
    static var days: String { "days".localized }
    static var week: String { "week".localized }
    static var weeks: String { "weeks".localized }
    static var month: String { "month".localized }
    static var months: String { "months".localized }
    static var noDataFound: String { return "noDataFound".localized }
    static var no: String { return "no".localized }
    static var noResultFound: String { return "noResultFound".localized }
    static var relatedItems: String { return "relatedItems".localized }
    
    //MARK:- Adventure Stories
    //========================
    static var forYou: String { "forYou".localized }
    static var popular: String { "popular".localized }
    static var new: String { "new".localized }
    static var TicktsPick: String { "airhireMesPick".localized }
    static var shareText: String { "shareText".localized }
    static var adventureStoryWithColon: String { "adventureStoryWithColon".localized }
    
    //MARK:- Profile
    //==============
    static var myAccount: String { "myAccount".localized }
    static var myProfile: String { "myProfile".localized }
    static var viewProfile: String { "viewProfile".localized }
    static var personalInformation: String { "personalInformation".localized }
    static var paymentsDetail: String { "paymentsDetail".localized }
    static var notificationSettings: String { "notificationSettings".localized }
    static var referralProgram: String { "referralProgram".localized }
    static var tutorial: String { "tutorial".localized }
    static var supportChat: String { "supportChat".localized }
    static var editProfile: String { "editProfile".localized }
    
    //MARK:- View Profile
    //===================
    static var about: String { "about".localized }
    static var showAllInfo: String { "showAllInfo".localized }
    static var recentlyAdded: String { "recentlyAdded".localized }
    static var highlyRatedItems: String { "highlyRatedItems".localized }
    static var mostHired: String { "mostHired".localized }
    static var showAllItems: String { "showAllItems".localized }
    static var items: String { "items".localized }
    static var item: String { "item".localized }
    static var results: String { "results".localized }
    static var result: String { "result".localized }
    static var found: String { "found".localized }
    static var allItems: String { "allItems".localized }
    static var reviews: String { "reviews".localized }
    static var questions: String { "questions".localized }
    static var newQuestions: String { "newQuestions".localized }
    static var newQuestion: String { "newQuestion".localized }
    static var showAll: String { "showAll".localized }
    static var seeMore: String { "seeMore".localized }
    static var seeLess: String { "seeLess".localized }
        
    //MARK:- Item Details
    //===================
    static var fastReply: String { "fastReply".localized }
    static var dayMinimum: String { "dayMinimum".localized }
    static var daysMinimum: String { "daysMinimum".localized }
    static var weekMinimum: String { "weekMinimum".localized }
    static var weeksMinimum: String { "weeksMinimum".localized }
    static var monthMinimum: String { "monthMinimum".localized }
    static var monthsMinimum: String { "monthsMinimum".localized }
    static var yearMinimum: String { "yearMinimum".localized }
    static var yearsMinimum: String { "yearsMinimum".localized }
    static var instantBooking: String { "instantBooking".localized }
    static var year: String { "year".localized }
    static var description: String { "description".localized }
    static var location: String { "location".localized }
    static var thisItemIsAvailableForPickupFrom: String { "thisItemIsAvailableForPickupFrom".localized }
    static var pickupDaysAndTimes: String { "pickupDaysAndTimes".localized }
    static var monday: String { "monday".localized }
    static var tuesday: String { "tuesday".localized }
    static var wednesday: String { "wednesday".localized }
    static var thursday: String { "thursday".localized }
    static var friday: String { "friday".localized }
    static var saturday: String { "saturday".localized }
    static var sunday: String { "sunday".localized }
    static var am: String { "am".localized }
    static var pm: String { "pm".localized }
    static var unavailable: String { "unavailable".localized }
    static var itemConditionNotes: String { "itemConditionNotes".localized }
    static var supplier: String { "supplier".localized }
    static var itemForHire: String { "itemForHire".localized }
    static var itemsForHire: String { "itemsForHire".localized }
    static var requestItem: String { "requestItem".localized }
    static var mostHiredCaps: String { "mostHiredCaps".localized }
    static var minimumHire: String { "minimumHire".localized }
    static var highestRated: String { "highestRated".localized }
    static var mostFavourites: String { "mostFavourites".localized }
    static var experiencesOnly: String { "experiencesOnly".localized }
    static var closetToMe: String { "closetToMe".localized }
    static var contactSupplier: String { "contactSupplier".localized }
    
    //MARK:- Question
    //===============
    static var question: String { "question".localized }
    static var capsQuestions: String { "capsQuestions".localized }
    static var answer: String { "answer".localized }
    static var answers: String { "answers".localized }
    static var hideAnswer: String { "hideAnswer".localized }
    static var showAnswer: String { "showAnswer".localized }
    static var edit: String { "edit".localized }
    static var delete: String { "delete".localized }
    static var allAreNewQuestions: String { "allAreNewQuestions".localized }
    
    //MARK:- QuestionAnswer
    //=====================
    static var askQuestion: String { "askQuestion".localized }
    static var yourQuestion: String { "yourQuestion".localized }
    static var text: String { "text".localized }
    static var yourAnswer: String { "yourAnswer".localized }
    static var answerText: String { "answerText".localized }
    static var pleaseEnterYourQuestion: String { "pleaseEnterYourQuestion".localized }
    static var pleaseEnterYourAnswer: String { "pleaseEnterYourAnswer".localized }
    static var answerCouldNotBeSameAsPrevious: String { "answerCouldNotBeSameAsPrevious".localized }
    static var areYouSureWantToAskAQuestion: String { "areYouSureWantToAskAQuestion".localized }
    static var areYouSureWantToDeleteTheAnswer: String { "areYouSureWantToDeleteTheAnswer".localized }
    
    //MARK:- Edit Profile
    //===================
    static var change: String { "change".localized }
    static var discardIDMessage: String { return "discardIDMessage".localized }
    
    //MARK:- Change Email
    //======================
    static var enterYourNewEmail: String { return "enterYourNewEmail".localized }
    
    //MARK:- Change Phone Number
    //==========================
    static var verifyYourPhoneNumber: String { return "verifyYourPhoneNumber".localized }
    static var verificationCodeYourPhoneNumber: String { return "verificationCodeYourPhoneNumber".localized }
    
    //MARK:- Change Password
    //======================
    static var changePassword: String { "changePassword".localized }
    static var pleaseEnterOldPassword: String { "pleaseEnterOldPassword".localized }
    static var pleaseEnterNewPassword: String { "pleaseEnterNewPassword".localized }
    static var pleaseEnterConfirmPassword: String { "pleaseEnterConfirmPassword".localized }
    static var newPasswordRule: String { "newPasswordRule".localized }
    static var newPasswordAndConfirmPasswordDoesntMatch: String { "newPasswordAndConfirmPasswordDoesntMatch".localized }
    static var enterNewPassword: String { return "enterNewPassword".localized }
    static var enterOldPassword: String { return "enterOldPassword".localized }
    static var enterConfirmPassword: String { return "enterConfirmPassword".localized }
    
    //MARK:- Search Categories
    //========================
    static var searchItem: String { "searchItem".localized }
    static var recentSearches: String { "recentSearches".localized }
    static var noRecentSearches: String { "noRecentSearches".localized }
    
    //MARK:- Search Location
    //=======================
    static var typeAStateCityOrSuburb: String { "typeAStateCityOrSuburb".localized }
    static var apply: String { return "apply".localized }
    
    //MARK:- Filter screen
    //====================
    static var clearAll: String { "clearAll".localized }
    static var closestToMe: String { "closestToMe".localized }
    static var minimumHireLower: String { "minimumHireLower".localized }
    static var mostFavouritesLower: String { "mostFavouritesLower".localized }
    static var experiencesOnlyLower: String { "experiencesOnlyLower".localized }
    static var highestRatedSupplier: String { "highestRatedSupplier".localized }
    static var verifiedBusinessOnly: String { "verifiedBusinessOnly".localized }
    static var sortBy: String { "sortBy".localized }
    static var priceRange: String { "priceRange".localized }
    static var category: String { "category".localized }
    static var subcategory: String { "subcategory".localized }
    
    //MARK:- Invite Screen
    //====================
    static var inviteYourFriendAndGetDollor: String { "inviteYourFriendAndGetDollor".localized }
    static var credit: String { "credit".localized }
    static var whenYourFriendWillDownload: String { "whenYourFriendWillDownload".localized }
    static var creditForNextRent: String { "creditForNextRent".localized }
    static var preInviteMessage: String { "preInviteMessage".localized }
    static var postInviteMessage: String { "postInviteMessage".localized }
    static var codeCopied: String { "codeCopied".localized }
    
    //MARK:- Payment Details
    //======================
    static var paymentDetails: String { "paymentDetails".localized }
    static var useCardToMakePayments: String { "useCardToMakePayments".localized }
    static var card: String { "card".localized }
    static var creditCard: String { "creditCard".localized }
    static var fillInBankDetailsToRecievePayment: String { "fillInBankDetailsToRecievePayment".localized }
    static var bankDetails: String { "bankDetails".localized }
    static var creditsAndDiscounts: String { "creditsAndDiscounts".localized }
    static var forNext1Rent: String { "forNext1Rent".localized }
    static var expDate: String { "expDate".localized }
    static var getMoreCredit: String { "getMoreCredit".localized }
    static var accountNumber: String { "accountNumber".localized }
    static var bsbNumber: String { "bsbNumber".localized }
    static var cardDetails: String { "cardDetails".localized }
    static var editCardDetails: String { "editCardDetails".localized }
    static var cardNumber: String { "cardNumber".localized }
    static var cardholderName: String { "cardholderName".localized }
    static var expirationDate: String { "expirationDate".localized }
    static var CVV_CVC: String { "CVV_CVC".localized }
    static var addAnotherCard: String { "addAnotherCard".localized }
    static var saveChanges: String { "saveChanges".localized }
    
    //MARK:- Error Msg
    //================
    static var errDataLoad: String { return "errDataLoad".localized }
    static var errSetPropertyUndefined: String { return "errSetPropertyUndefined".localized }
    static var serviceUnavailable: String { return "serviceUnavailable".localized }
    static var underDevelopment: String { return "underDevelopment".localized }
    static var somethingWentWrong: String { return "somethingWentWrong".localized }
}

extension LS {
    var localized: String {
        return self.rawValue.localized
    }
}
