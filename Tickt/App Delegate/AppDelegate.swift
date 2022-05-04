//
//  AppDelegate.swift
//  Tickt
//
//  Created by Admin on 02/03/21.
//

import UIKit
import Firebase
import GoogleMaps
import GooglePlaces
import IQKeyboardManagerSwift
import Segment_MoEngage
import MOAnalytics
import Stripe
import SwiftyDropbox

var PUBLISHER_KEY = "pk_test_51IdTOqKjjnW7jXnVURB0mRIVVZ997twxcbwTmAyc9EDhI60iB05YtmCNOC8ExoEMNO3t7ZBSc8WhqHFZMlzZyDen00cSy6hX4e"


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var tabbar: TabBarView?
    var tradeModel: TradeModel?
    var searchModel = SearchModel()
    var signupModel = SignupModel()
    var datesDict = [Date: [UIColor]]()
    var tabBarController: TabBarController?
    var postJobModel: CreateJobModel? = nil
    var totalMilestonesNonApproved: Int? = nil
    var searchingBuilderModel: SearchingContentsModel?
    let mainNavigation: NavigationController = {
        let navigation = NavigationController()
        navigation.isNavigationBarHidden = true
        return navigation
    }()
    
    var googleHandler: GoogleLoginManager?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        handleThirdPartyService(application: application, launchOptions: launchOptions)
        StripeAPI.defaultPublishableKey = "pk_test_51IdTOqKjjnW7jXnVURB0mRIVVZ997twxcbwTmAyc9EDhI60iB05YtmCNOC8ExoEMNO3t7ZBSc8WhqHFZMlzZyDen00cSy6hX4e"
        setUpKeyboardSetup(status: true)
        AppRouter.launchApp()
        TicketMoengage.shared.setupMoengage(launchOptions: launchOptions)
        let config = AnalyticsConfiguration(writeKey:"9MGBIF1KHFC5GXE7YHMXRPEE")
        // Add MoEngageIntegrationFactory. Without this data will not come to MoEngage.
        config.use(SEGMoEngageIntegrationFactory.instance())
        Analytics.setup(with: config)
        Stripe.setDefaultPublishableKey(PUBLISHER_KEY)
        TicketMoengage.shared.postEvent(eventType: .appOpen(app_open: true))
        DropboxClientsManager.setupWithAppKey("idupreahq9po18m")
        return true
    }
    
    func handleThirdPartyService(application: UIApplication,  launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        configureFirebase()
        LocationManager.sharedInstance.requestLocatinPermission { (_) in }
        GMSPlacesClient.provideAPIKey("AIzaSyDKFFrKp0D_5gBsA_oztQUhrrgpKnUpyPo")
        GMSServices.provideAPIKey("AIzaSyDKFFrKp0D_5gBsA_oztQUhrrgpKnUpyPo")//AIzaSyANW01BOj9CiPh-MrauC_OkukJ1LnuXJGw
        googleHandler = GoogleLoginManager(application: application, launchOptions: launchOptions)
        IntercomHandler.shared.registerAPI()
        IntercomHandler.shared.registerUser()
    }
    
    func configureFirebase() {
        Messaging.messaging().delegate = self
        registerForRemoteNotification()
    }
    
    func setUpKeyboardSetup(status: Bool) {
        IQKeyboardManager.shared.enable = status
        IQKeyboardManager.shared.enableAutoToolbar = status
        IQKeyboardManager.shared.layoutIfNeededOnUpdate = status
        IQKeyboardManager.shared.shouldResignOnTouchOutside = status
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let oauthCompletion: DropboxOAuthCompletion = {
          if let authResult = $0 {
              switch authResult {
              case .success:
                  print("Success! User is logged into DropboxClientsManager.")
//                  NotificationCenter.default.post(name: NotificationName.openDocumentViewer, object: nil, userInfo: nil)
              case .cancel:
                  print("Authorization flow was manually canceled by user!")
              case .error(_, let description):
                  print("Error: \(String(describing: description))")
              }
          }
        }
        let canHandleUrl = DropboxClientsManager.handleRedirectURL(url, completion: oauthCompletion)
        return canHandleUrl
    }
}
