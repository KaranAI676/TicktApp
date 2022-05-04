//
//  PriceMapMarkerView.swift
//  Tickt
//
//  Created by Admin on 17/02/21.
//  Copyright © 2021 Tickt. All rights reserved.
//

import UIKit
import CoreLocation

class PriceMapMarkerView: UIView {
    
    private var backgroundView = UIView()
    private var normalImage = UIImage(named: "shop")
    private var selectedImage = UIImage(named: "shop")?.imageWithColor(.white)
    private var imageView = UIImageView()
    let index: Int
    let coordinate: CLLocationCoordinate2D
    
    init(itemIndex: Int, coordinate: CLLocationCoordinate2D) {
        index = itemIndex
        self.coordinate = coordinate
        super.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        backgroundColor = .clear
        backgroundView.round(radius: 4)
        backgroundView.backgroundColor = .white
        backgroundView.frame = bounds.inset(by: UIEdgeInsets.init(top: 1, left: 1, bottom: 1, right: 1))
        imageView.frame = backgroundView.bounds.inset(by: UIEdgeInsets.init(top: 6, left: 6, bottom: 6, right: 6))
        imageView.image = normalImage
        backgroundView.addSubview(imageView)
        addSubview(self.backgroundView)
        updateUI(isSelected: false)
    }
    
    func updateUI(isSelected: Bool) {
        backgroundView.backgroundColor = isSelected ? UIColor(hex: "#0B41A8") : .white
        imageView.image = isSelected ? selectedImage : normalImage
        layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
