//
//  AppGuide + SetCoachViewsMethods.swift
//  Tickt
//
//  Created by S H U B H A M on 16/07/21.
//

import Foundation

extension AppGuideVC {
    
    func setupCoachData() {
        tabbarArray.forEach({ setTabIcons($0.tabValue, image: $0.image)})
        setNotificationIcon()
        setSkipButton()
    }
    
    private func setTabIcons(_ tabIndex: Int, image: UIImage) {
        let imageView = getImageView(image)
        imageView.frame = getTabIconsFrame(tabIndex)
        self.view.addSubview(imageView)
        
        let arrowImageView = getImageView(tabbarArray[tabIndex].arrows)
        arrowImageView.frame = getTabArrowFrame(tabIndex, iconImageView: imageView)
        self.view.addSubview(arrowImageView)
        
        let label = getLabel(tabbarArray[tabIndex].coachMessage)
        label.frame = getTabeLabelFrame(tabIndex, arrowImageView: arrowImageView, label: label)
        self.view.addSubview(label)
        
        coachmarksArray.append(([imageView, arrowImageView, label]))
    }
    
    private func setNotificationIcon() {
        if let vc = homeVC {
            let imageView = getImageView(#imageLiteral(resourceName: "Notification"))
            var frame = vc.notificationButton.frame
            frame.origin.y += kAppDelegate.window?.safeAreaInsets.top ?? 45
            imageView.frame = frame
            imageView.addSubview(badgeView)
            badgeView.isHidden = (vc.badgeCountLabel.text?.intValue ?? 0) < 1
            badgeLabel.text = vc.badgeCountLabel.text
            badgeView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: -badgeLabel.width/2).isActive = true
            badgeView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -badgeLabel.width/2).isActive = true
            self.view.addSubview(imageView)
            
            let arrowImageView = getImageView(#imageLiteral(resourceName: "arrowFacingUp"))
            arrowImageView.frame.origin.x = imageView.origin.x - (imageView.frame.size.width) - 12
            arrowImageView.frame.origin.y = imageView.frame.maxY
            arrowImageView.frame.size.width = 48
            arrowImageView.frame.size.height = 48
            self.view.addSubview(arrowImageView)
            
            let label = getLabel("Check notifications and stay on the front foot")
            label.frame.origin.x = 32
            label.frame.origin.y = arrowImageView.origin.y + 5
            label.frame.size.width = kScreenWidth - (label.frame.origin.x + (kScreenWidth - arrowImageView.frame.origin.x))
            label.frame.size.height = label.text!.heightOfText(label.frame.size.width, font: label.font)
            self.view.addSubview(label)
            
            coachmarksArray.append(([imageView, arrowImageView, label]))
        }
    }
    
    func setSkipButton() {
        let button = getButton("SKIP")
        button.frame = getSkipButtonFrames()
        view.addSubview(button)
        view.bringSubviewToFront(button)
    }
}
