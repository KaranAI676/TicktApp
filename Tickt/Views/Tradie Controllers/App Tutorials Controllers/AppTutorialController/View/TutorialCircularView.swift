//
//  TutorialCircularView.swift
//  Tickt
//
//  Created by Tickt on 18/12/20.
//  Copyright © 2020 Tickt. All rights reserved.
//

import UIKit

class TutorialCircularView: UIView {
    
    var imgView: UIImageView?
    
    init(frame: CGRect, image: UIImage) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.imgView = UIImageView()
        self.imgView!.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.imgView!)
        self.imgView!.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.92).isActive = true
        self.imgView!.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.92).isActive = true
        self.imgView!.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.imgView!.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.imgView?.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
