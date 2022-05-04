//
//  AppGuide + GetResourcesMethods.swift
//  Tickt
//
//  Created by S H U B H A M on 16/07/21.
//

import Foundation

extension AppGuideVC {
    
    func getLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.frame = CGRect()
        label.isUserInteractionEnabled = false
        label.alpha = 0.0
        label.backgroundColor = .clear
        label.font = UIFont.kDMSansFontBold(ofSize: 18)
        label.textColor = .white
        label.text = text
        return label
    }
    
    func getImageView(_ image: UIImage) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.frame = CGRect()
        imageView.isUserInteractionEnabled = false
        imageView.alpha = 0.0
        imageView.backgroundColor = .clear
        imageView.image = image
        return imageView
    }
    
    func getButton(_ text: String) -> UIButton {
        let button = UIButton()
        button.setTitleForAllMode(title: text)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont.kDMSansFontBold(ofSize: 14)
        button.setBorder(width: 1, color: .white)
        button.round(radius: 3)
        button.frame = CGRect()
        button.tag = 1
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }
}
