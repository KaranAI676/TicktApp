//
//  CircularView.swift
//  Tickt
//
//  Created by Tickt on 19/11/20.
//  Copyright © 2020 Tickt. All rights reserved.
//

import UIKit
import Foundation


class CircularView: UIView {
    
    //MARK:- Variables
    //=================

    //MARK:- LifeCycle
    //=================

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.commonInit()
    }
    
    //MARK:- Functions
    //=================
    private func commonInit() {
        layer.cornerRadius = frame.width / 2
        layer.cornerRadius = 6 //frame.width / 2
    }
}

class LeftEdgesCirculaView: UIView {
    
    //MARK:- Variables
    //=================

    //MARK:- LifeCycle
    //=================

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.commonInit()
    }
    
    //MARK:- Functions
    //=================
    private func commonInit() {
        layer.cornerRadius = self.height/2.0
        layer.cornerRadius = 6 //self.height/2.0
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
}

class RightEdgesCirculaView: UIView {
    
    //MARK:- Variables
    //=================

    //MARK:- LifeCycle
    //=================

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.commonInit()
    }
    
    //MARK:- Functions
    //=================
    private func commonInit() {
        layer.cornerRadius = self.height/2.0
        layer.cornerRadius = 6 //self.height/2.0
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
}
