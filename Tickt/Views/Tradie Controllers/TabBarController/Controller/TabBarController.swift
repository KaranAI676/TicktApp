//
//  TabBarController.swift
//  Tickt
//
//  Created by Tickt on 17/12/20.
//  Copyright © 2020 Tickt. All rights reserved.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers


class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCenterButton()     
        tabBarSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadControllers()
    }
    
    func tabLineSetup() {
        tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: #colorLiteral(red: 0.9960784314, green: 0.9019607843, blue: 0, alpha: 1), size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count), height:  (tabBar.frame.height)-1), lineWidth: 2.5).resizableImage(withCapInsets: .zero, resizingMode: .stretch).roundCorners(proportion: 3)
    }
    
    func tabBarSetup() {
        tabLineSetup()
        delegate = self
        
        tabBar.layer.shadowColor = UIColor.gray.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 1.0, height: 0.0)
        tabBar.layer.shadowOpacity = 1.0
        tabBar.layer.shadowRadius = 6
        tabBar.layer.masksToBounds = false
        
        tabBar.unselectedItemTintColor = .white
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.kAppDefaultFontRegular(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.kAppDefaultFontRegular(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        tabBar.backgroundColor = AppColors.themeBlue
    }
    
    func loadControllers() {
        
        var controllers: [UIViewController] = []
        
        /// Home Tab
        if let homeVC = getHomeVC() {
            homeVC.tabBarItem = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "Home_unselected"), selectedImage: #imageLiteral(resourceName: "Home_selected"))
            controllers.append(homeVC)
        }
        
        /// Job Tab
        if kUserDefaults.isTradie() {
            if let jobVC = getTradieJobVC() {
                jobVC.tabBarItem = UITabBarItem(title: "Jobs", image: #imageLiteral(resourceName: "jobsInactive"), selectedImage: #imageLiteral(resourceName: "jobsActive"))
                controllers.append(jobVC)
            }
        } else {
            if let jobVC = getBuilderJobVC() {
                jobVC.tabBarItem = UITabBarItem(title: "Jobs", image: #imageLiteral(resourceName: "jobsInactive"), selectedImage: #imageLiteral(resourceName: "jobsActive"))
                controllers.append(jobVC)
            }
        }
        
        /// Middle Tab
        if !kUserDefaults.isTradie() {
            let vc2 = UIViewController()
            vc2.tabBarItem.isEnabled = false
            controllers.append(vc2)
        }
        
        /// Chat Tab
        if let chatVC = getChatVC() {
            chatVC.tabBarItem = UITabBarItem(title: "Chat", image:#imageLiteral(resourceName: "Chat_unselected"), selectedImage: #imageLiteral(resourceName: "Chat_selected"))
            ChatHelper.getAllUnreadMessageCount(userId: kUserDefaults.getUserId(), completion: { unreadCount in
                chatVC.tabBarItem.badgeValue = unreadCount == 0 ? nil : "\(unreadCount)"
            })
            controllers.append(chatVC)
        }
        
        /// Profile Tab
        if let jobVC = getUserProfile() {
            jobVC.tabBarItem = UITabBarItem(title: "Profile", image: #imageLiteral(resourceName: "accountInactive"), selectedImage: #imageLiteral(resourceName: "accountActive"))
            controllers.append(jobVC)
        }
        
        viewControllers = controllers
    }
    
    func setupCenterButton() {
        if !kUserDefaults.isTradie() {
            let centerButton = (tabBar as? TabBarView)?.centerButton
            centerButton!.addTarget(self, action: #selector(centerButtonAction(_:)), for: .touchUpInside)
        } else {
            let indexToRemove = 2
            if indexToRemove < (viewControllers?.count ?? 0) {
                var controller = viewControllers
                controller?.remove(at: indexToRemove)
                viewControllers = controller
            }
        }
    }
    
    func selectFiles() {
        if #available(iOS 14.0, *) {
//            let types = UTType.types(tag: "json",
//                                     tagClass: UTTagClass.filenameExtension,
//                                     conformingTo: nil)
            let documentPickerController = UIDocumentPickerViewController(documentTypes: ["public.text", "com.apple.iwork.pages.pages", "public.data"], in: .import)
          //  documentPickerController.delegate = self
            self.present(documentPickerController, animated: true, completion: nil)
        }else{}
    }
    
    
    @objc func centerButtonAction(_ sender : UIButton) {
        let vc = CreateJobVC.instantiate(fromAppStoryboard: .jobPosting)
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .overCurrentContext
        self.present(navController, animated: true, completion: nil)
    }
    
    func getTabBarFrameInRespectToController() -> CGRect {
        return self.view.convert(self.tabBar.frame, from:self.view)
    }
    
    func getHomeVC() -> TradieHomeVC? {
        if let vc = viewControllers?.filter({$0.isKind(of: TradieHomeVC.self)}).first as? TradieHomeVC {
            return vc
        } else {
            return TradieHomeVC.instantiate(fromAppStoryboard: .home)
        }
    }
    
    func getTradieJobVC() -> JobDashboardVC? {
        if let vc = viewControllers?.filter({$0.isKind(of: JobDashboardVC.self)}).first as? JobDashboardVC {
            return vc
        } else {
            return JobDashboardVC.instantiate(fromAppStoryboard: .jobDashboard)
        }
    }
    
    func getBuilderJobVC() -> JobDashboardBuilderVC? {
        if let vc = viewControllers?.filter({$0.isKind(of: JobDashboardBuilderVC.self)}).first as? JobDashboardBuilderVC {
            return vc
        } else {
            return JobDashboardBuilderVC.instantiate(fromAppStoryboard: .jobDashboardBuilder)
        }
    }
    
    func getChatVC() -> InboxVC? {
        if let vc = viewControllers?.filter({$0.isKind(of: InboxVC.self)}).first as? InboxVC {
            return vc
        } else {
            return InboxVC.instantiate(fromAppStoryboard: .chat)
        }
    }
    
    func getUserProfile() -> LoggedInUserProfileBuilderVC? {
        if let vc = viewControllers?.filter({$0.isKind(of: LoggedInUserProfileBuilderVC.self)}).first as? LoggedInUserProfileBuilderVC {
            return vc
        } else {
            return LoggedInUserProfileBuilderVC.instantiate(fromAppStoryboard: .loggedInUserProfileBuilder)
        }
    }
}


extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
    }
}

extension UIImage {
    func createSelectionIndicator(color: UIColor, size: CGSize, lineWidth: CGFloat) -> UIImage {
        let newX = (size.width - 41) / 2
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(x: newX, y: 0, width: 39, height: lineWidth)) //(size.width)/2
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func roundCorners(proportion: CGFloat) -> UIImage {
        let minValue = min(self.size.width, self.size.height)
        let radius = minValue/proportion
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1)
        UIBezierPath(roundedRect: rect, cornerRadius: radius).addClip()
        self.draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        return image
    }
}
