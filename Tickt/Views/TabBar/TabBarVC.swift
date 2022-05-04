//
//  TabBarVC.swift
//  Tickt
//
//  Created by S H U B H A M on 23/03/21.
//

import UIKit

class TabBarVC: UITabBarController {

    var kBarHeight : CGFloat = 86
    fileprivate lazy var defaultTabBarHeight = { tabBar.frame.size.height }()

    // MARK: - ViewController life cycle
    //==================================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        self.tabBar.drawShadow()
//        self.tabBar.isTranslucent = false
        self.tabBar.backgroundColor = AppColors.themeBlue
        
        let newTabBarHeight = defaultTabBarHeight + 400.0

        var newFrame = tabBar.frame
        newFrame.size.height = newTabBarHeight
        newFrame.origin.y = view.frame.size.height - newTabBarHeight

        tabBar.frame = newFrame
        
//        tabBar.frame.size.height = kBarHeight
//        tabBar.frame.origin.y = -86 //view.frame.height - kBarHeight
        
        self.tabBar.roundCorner([.topLeft , .topRight], radius: 30)
//        var tabFrame: CGRect = self.tabBar.frame
//        tabFrame.size.height = kBarHeight
//        tabFrame.origin.y = self.view.frame.size.height - kBarHeight
//        self.tabBar.frame = tabFrame
//        self.tabBar.frame.size.height = 400
    }

//    override func sizeThatFits(size: CGSize) -> CGSize {
//         var size = super.sizeThatFits(size)
//         size.height = 88
//         return size
//    }

    // MARK: - Functions
    //====================================

    ///function for basic setup of views
    func initialSetup() {
        self.navigationController?.navigationBar.isHidden = true
        let appearance = UITabBarItem.appearance()
        let attributes = [NSAttributedString.Key.font: UIFont.kAppDefaultFontMedium(ofSize: 10)]
        appearance.setTitleTextAttributes(attributes, for: .normal)
        UITabBar.appearance().tintColor = .red
//        UITabBar.appearance().shadowImage = UIImage(named:"tabbarShadow")
//        UITabBar.appearance().backgroundImage = UIImage(named:"tabbarShadow")
//        self.tabBar.backgroundColor = AppColors.pureWhite
//        self.tabBar.shadowImage = UIImage()

        setupTabBar()
        
    }
    
    func addGreyView() {
        let greyView = UIView()
        greyView.backgroundColor = #colorLiteral(red: 0.0862745098, green: 0.1137254902, blue: 0.2901960784, alpha: 1)
        greyView.frame = tabBar.frame

        tabBar.addSubview(greyView)
    }
    
    ///function to setup tab bar
    func setupTabBar() {
        guard let tabBarItems = self.tabBar.items else {return}
        for index in 0...tabBarItems.endIndex - 1 {
            switch index {
            case 0:
                if let item = self.tabBar.items?[index] {
                    item.image = #imageLiteral(resourceName: "homeInactive").withRenderingMode(.alwaysOriginal)
                    item.title = "Discovery"
                    item.selectedImage = #imageLiteral(resourceName: "navigationHomeActive").withRenderingMode(.alwaysOriginal)
                }
            case 1:
                if let item = self.tabBar.items?[index] {
                    item.image = #imageLiteral(resourceName: "jobsInactive").withRenderingMode(.alwaysOriginal)
                    item.title = "My Planner"
                    item.selectedImage = #imageLiteral(resourceName: "jobsActive").withRenderingMode(.alwaysOriginal)
                }
            case 2:
                if let item = self.tabBar.items?[index] {
                    item.image = #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal)
                    item.imageInsets.top = -12
                    item.title = ""
                    item.selectedImage = #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal)
                }
            case 3:
                if let item = self.tabBar.items?[index] {
                    item.image = #imageLiteral(resourceName: "navigationChatInactive").withRenderingMode(.alwaysOriginal)
                    item.title = "Messages"
                    item.selectedImage = #imageLiteral(resourceName: "Chat_selected")
                }
            default:
                if let item = self.tabBar.items?[index] {
                    item.image = #imageLiteral(resourceName: "navigationAccountInactive").withRenderingMode(.alwaysOriginal)
                    item.title = "Profile"
                    item.selectedImage = #imageLiteral(resourceName: "accountActive").withRenderingMode(.alwaysOriginal)
                }
            }
        }
    }
}
