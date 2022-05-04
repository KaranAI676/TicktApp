//
//  RetryButton.swift
//  Tickt
//
//  Created by S H U B H A M on 01/08/21.
//

import Foundation

protocol RetryButtonDelegate: class {
    func didPressRetryButton()
}

class RetryButton: UIButton {
    
    weak var delegate: RetryButtonDelegate? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        self.backgroundColor = .clear
        self.setImageForAllMode(image: #imageLiteral(resourceName: "refresh"))
        self.addTarget(self, action: #selector(retryButtonAction), for: .touchUpInside)
        self.setTitleForAllMode(title: CommonStrings.emptyString)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if self.superview == nil {
            self.delegate = nil
        }
    }

    @objc private func retryButtonAction() {
        self.delegate?.didPressRetryButton()
    }
}
