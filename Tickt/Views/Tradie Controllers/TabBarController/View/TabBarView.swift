//
//  TabBarView.swift
//  Tickt
//
//  Created by Tickt on 17/12/20.
//  Copyright © 2020 Tickt. All rights reserved.
//

import UIKit

class TabBarView: UITabBar {
    
    lazy var centerButton: UIButton = {
        let buttonImage = UIImage(named: "plus")!
        $0.setImage(buttonImage, for: .normal)
        $0.frame = CGRect(x: 0.0, y: 0.0, width: buttonImage.size.width, height: buttonImage.size.height)
        $0.setBackgroundImage(buttonImage, for: .normal)
        $0.clipsToBounds = true
        $0.setBackgroundImage(buttonImage, for: .highlighted)
        $0.isUserInteractionEnabled = true
        $0.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 0)
        $0.layer.shadowColor = UIColor.gray.cgColor
        $0.layer.shadowOffset = CGSize(width: 2.0, height: 0.0)
        $0.layer.shadowOpacity = 1.0
        $0.layer.shadowRadius = 6
        $0.layer.masksToBounds = false
        $0.layer.cornerRadius = (buttonImage.size.width/2)
        return $0
    }(UIButton())

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if !kUserDefaults.isTradie() {
            addCenterButton()
        }
//        self.tintColor = AppColors.tabBarSelected
//        self.unselectedItemTintColor = AppColors.tabBarUnselected
//        self.backgroundColor = AppColors.themeBlue
//        self.barStyle = .default
//        self.isTranslucent = true
//        self.items?.forEach({$0.title = nil})
//        self.shadowImage = UIImage()
//        self.layer.shadowOffset = CGSize(width: 0, height: 0)
//        self.layer.shadowRadius = 8
//        self.layer.shadowColor = AppColors.tabBarUnselected.cgColor
//        self.layer.shadowOpacity = 0.2
//        self.backgroundImage = UIImage()
//        self.itemSpacing = 0
        
        self.layer.shadowColor = UIColor.systemPink.cgColor
        self.layer.shadowOffset = CGSize(width: 1.0, height: 0.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 6
        self.layer.masksToBounds = false
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.isHidden {
            return super.hitTest(point, with: event)
        }
        let from = point
        let to = centerButton.center
        let first = from.x - to.x
        let first1 = from.x - to.x
        
        let middle = from.y - to.y
        let middle1 = from.y - to.y
        return sqrt( first*first1 + middle*middle1) <= 39 ? centerButton : super.hitTest(point, with: event)
    }
    
    func addCenterButton() {
        addSubview(centerButton)
        bringSubviewToFront(centerButton)
        
        if let count = items?.count {
            let i = floor(Double(count / 2))
            let item = items![Int(i)]
            item.title = ""
        }
    }

    func shadowSetUp() {
        let view = UILabel()
        view.frame = self.bounds
        view.backgroundColor = .white

        let shadows = UIView()
        shadows.frame = view.frame
        shadows.clipsToBounds = false
        view.addSubview(shadows)

        let shadowPath = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 0)
        let layer = CALayer()
        layer.shadowPath = shadowPath.cgPath
        layer.shadowColor = UIColor(red: 0.682, green: 0.682, blue: 0.682, alpha: 0.2).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 40
        layer.shadowOffset = CGSize(width: 0, height: -2)
        layer.bounds = shadows.bounds
        layer.position = shadows.center
        shadows.layer.addSublayer(layer)

        let shapes = UIView()
        shapes.frame = view.frame
        shapes.clipsToBounds = true
        view.addSubview(shapes)

        let layer1 = CALayer()
        layer1.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        layer1.bounds = shapes.bounds
        layer1.position = shapes.center
        shapes.layer.addSublayer(layer1)
        
        self.addSubview(view)
        view.fillSuperview()
    }
    
}

extension UITabBar {

    func getFrameForTabAt(index: Int) -> CGRect? {
        var frames = self.subviews.compactMap { return $0 is UIControl ? $0.frame : nil }
        frames.sort { $0.origin.x < $1.origin.x }
        return frames[safe: index]
    }

}
