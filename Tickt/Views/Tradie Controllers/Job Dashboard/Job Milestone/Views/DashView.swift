//
//  DashView.swift
//  Tickt
//
//  Created by Admin on 14/05/21.
//

import UIKit

class DashView: UIView, DashLine {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        createDottedLine(width: 1, color: UIColor(hex: "#0B41A8"))
    }
}

protocol DashLine { }

extension DashLine where Self: UIView {
    func createDottedLine(width: CGFloat, color: UIColor) {
        let dashLayer = CAShapeLayer()
        dashLayer.strokeColor = color.cgColor
        dashLayer.lineWidth = width
        dashLayer.lineDashPattern = [3,3]
        let path = CGMutablePath()
        let point = [CGPoint(x: 0, y: 0), CGPoint(x: 0, y: frame.height)]
        path.addLines(between: point)
        dashLayer.path = path
        layer.addSublayer(dashLayer)        
    }
}
