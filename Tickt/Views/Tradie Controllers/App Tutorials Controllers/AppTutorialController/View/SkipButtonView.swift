//
//  SkipButtonView.swift
//  Tickt
//
//  Created by Tickt on 18/12/20.
//  Copyright © 2020 Tickt. All rights reserved.
//

import UIKit

class SkipButtonView: UIView {
    
    var didTapOnButton: (() -> Void)? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
//        let skipButton = UIButton(type: .custom)
//        skipButton.setTitleForAllMode(title: LS.skip)
//        skipButton.backgroundColor = .clear
//        skipButton.setTitleColorForAllMode(color: .white)
//        skipButton.titleLabel?.font = AppFonts.DMSans_Bold.withSize(14.0)
//        skipButton.cropCorner(radius: 12.0, borderWidth: 1.0, borderColor: .white)
//        skipButton.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(skipButton)
//        skipButton.widthAnchor.constraint(equalToConstant: 62).isActive = true
//        skipButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        skipButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        skipButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        skipButton.addTarget(self, action: #selector(self.skipButtonTap(_:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func skipButtonTap(_ sender: UIButton) {
        self.didTapOnButton?()
    }
}
