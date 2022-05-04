//
//  AppGuideVC + GetFramesMethods.swift
//  Tickt
//
//  Created by S H U B H A M on 16/07/21.
//

import Foundation

extension AppGuideVC {
    
    func getTabIconsFrame(_ tabIndex: Int) -> CGRect {
        guard let tabView = kAppDelegate.tabbar?.items?[tabIndex].value(forKey: ApiKeys.view) as? UIView else {
            return CGRect()
        }
        let convertableFrame = tabView.convert(tabView.frame, to: view.superview)
        var frame: CGRect = tabView.frame
        if tabbarArray[tabIndex] == .create {
            frame.origin.x = (kScreenWidth/2 - 28)
            frame.origin.y = convertableFrame.origin.y - 29
            frame.size.width = 56
            frame.size.height = 56
        } else {
            frame.origin.x += 14
            frame.origin.y = convertableFrame.origin.y
            frame.size.width = 46
            frame.size.height = 46
        }
        return frame
    }
    
    func getTabArrowFrame(_ tabIndex: Int, iconImageView imageView: UIImageView) -> CGRect {
        var frame = CGRect()
        frame.origin.x = tabbarArray[tabIndex] == .home ? (imageView.frame.maxX - 12) : (imageView.frame.minX - 40)
        frame.origin.y = tabbarArray[tabIndex] == .create ?
            (abs(getTabIconsFrame(0).height - getTabIconsFrame(0).origin.y - 5)) :
            (abs(imageView.height - imageView.frame.origin.y - 5))
        frame.size.width = 48
        frame.size.height = 48
        return frame
    }
    
    func getTabeLabelFrame(_ tabIndex: Int, arrowImageView: UIImageView, label: UILabel) -> CGRect {
        var frame = CGRect()
        var initial: CGFloat = 0
        var final: CGFloat = 0
        
        switch tabbarArray[tabIndex] {  /// This used to set the initial position & width of label
        case .home:
            let firstTabFrame = getTabIconsFrame(TabBarIndex.home.tabValue)
            let secondTabFrame = getTabIconsFrame(TabBarIndex.profile.tabValue)
            initial = firstTabFrame.origin.x + firstTabFrame.width/2
            final = kScreenWidth - (secondTabFrame.origin.x)
        case .jobs:
            let firstTabFrame = getTabIconsFrame(TabBarIndex.home.tabValue)
            let secondTabFrame = getTabIconsFrame(TabBarIndex.profile.tabValue)
            initial = firstTabFrame.origin.x + firstTabFrame.width/2
            final = kScreenWidth - (secondTabFrame.maxX)
        case .create:
            let firstTabFrame = getTabIconsFrame(TabBarIndex.jobs.tabValue)
            let secondTabFrame = getTabIconsFrame(TabBarIndex.chat.tabValue)
            initial = firstTabFrame.origin.x + firstTabFrame.width/2
            final = kScreenWidth - (secondTabFrame.maxX)
        case .chat:
            let firstTabFrame = getTabIconsFrame(TabBarIndex.create.tabValue)
            let secondTabFrame = getTabIconsFrame(TabBarIndex.profile.tabValue)
            initial = kScreenWidth - (firstTabFrame.maxX)
            final = kScreenWidth - (secondTabFrame.maxX)
        case .profile:
            let firstTabFrame = getTabIconsFrame(TabBarIndex.create.tabValue)
            let secondTabFrame = getTabIconsFrame(TabBarIndex.profile.tabValue)
            initial = kScreenWidth - (firstTabFrame.origin.x)
            final = kScreenWidth - (secondTabFrame.maxX)
        }
        
        frame.size.width = kScreenWidth - (initial + final)
        frame.origin.x = initial
        frame.origin.y = arrowImageView.frame.minY - label.text!.heightOfText(frame.size.width, font: label.font)
        frame.size.height = label.text!.heightOfText(frame.size.width, font: label.font)
        return frame
    }
    
    func getSkipButtonFrames() -> CGRect {
        var frame = CGRect()
        frame.size.width = 76
        frame.size.height = 36
        frame.origin.x = kScreenWidth - 94
        frame.origin.y = 150 //   kScreenHeight/2 - (frame.size.height)/2
        return frame
    }
}
