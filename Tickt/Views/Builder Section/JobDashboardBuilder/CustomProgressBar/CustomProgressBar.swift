//
//  UIProgressBar.swift
//  Tickt
//
//  Created by S H U B H A M on 06/05/21.
//

import UIKit

class CustomProgressBar: UIProgressView {
    
    override func layoutSubviews() {
        let maskLayerPath = UIBezierPath(roundedRect: bounds, cornerRadius: 4.0)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskLayerPath.cgPath
        layer.mask = maskLayer
    }
}
