//
//  SentMessageView.swift
//  KozeePro
//
//  Created by Harsh on 23/01/19.
//  Copyright © 2019 Kozee. All rights reserved.
//

import UIKit

@IBDesignable
class ReceivedImageMessageView: UIView {

    var maskLayer : CAShapeLayer?
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
//        addMaskLayer()
    }
    
    func addMaskLayer() {
        
        let width = frame.width
        let height = frame.height
        
        let bezierPath = UIBezierPath()
        //        if bezierPath.bounds.height == 0.0 {
        
        bezierPath.move(to: CGPoint(x: width-20, y: 0))
        bezierPath.addLine(to: CGPoint(x: 20, y: 0))
        bezierPath.addCurve(to: CGPoint(x: 0, y: 20), controlPoint1: CGPoint(x: 10  , y: 0), controlPoint2: CGPoint(x: 0, y: 10))
        bezierPath.addLine(to: CGPoint(x: 0, y: height - 20))
        bezierPath.addCurve(to: CGPoint(x: 20, y: height), controlPoint1: CGPoint(x: 0, y: height - 10), controlPoint2: CGPoint(x: 10, y: height))
        bezierPath.addLine(to: CGPoint(x: width, y: height))
        bezierPath.addLine(to: CGPoint(x: width, y: 20))
        bezierPath.addCurve(to: CGPoint(x: width - 20, y: 0), controlPoint1: CGPoint(x: width, y: 10), controlPoint2: CGPoint(x: width - 10, y: 0))
        bezierPath.close()
        
        self.maskLayer?.removeFromSuperlayer()
        self.layer.mask = nil
        if let l = self.maskLayer {
            self.layer.sublayers?.removeAll(where: {$0 == l})
        }
        
        // Add rounded corners
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bezierPath.bounds
        maskLayer.path = bezierPath.cgPath
        maskLayer.fillColor = UIColor.lightGray.withAlphaComponent(0.05).cgColor
        maskLayer.strokeColor = UIColor.clear.cgColor
        maskLayer.borderColor = UIColor.clear.cgColor
        maskLayer.lineWidth = 1
        self.maskLayer = maskLayer
        self.layer.mask = maskLayer
        self.layer.insertSublayer(maskLayer, at: 0)
        
        self.borderColor = UIColor.clear
    }
}



//ReceivedImageMessageView
