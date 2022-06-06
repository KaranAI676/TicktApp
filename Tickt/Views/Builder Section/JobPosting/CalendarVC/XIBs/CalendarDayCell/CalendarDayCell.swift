//
//  CalendarDayCell.swift
//  Tickt
//
//  Created by Tickt on 09/02/21.
//  Copyright © 2021 Tickt. All rights reserved.
//

import UIKit
import JTAppleCalendar

enum CalendarDayCellMode {
    case singleHead, singleTail, head, tail, mid, left, right, pastDates, futureDates, outDates, none
}

class CalendarDayCell: JTACDayCell {
            
    //MARK:- IB Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nodeView: CircularView!
    @IBOutlet weak var halfLeftView: UIView!
    @IBOutlet weak var halfRightView: UIView!
    @IBOutlet weak var leftView: LeftEdgesCirculaView!
    @IBOutlet weak var rightView: RightEdgesCirculaView!
    @IBOutlet weak var dateLabel: UILabel!
    ///
    @IBOutlet weak var dotOneView: UIView!
    @IBOutlet weak var dotTwoView: UIView!
    @IBOutlet weak var dotThreeView: UIView!
    @IBOutlet weak var dotFourView: UIView!
    
    //MARK:- Variables
    var dotViewsArray: [UIView] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.nodeView.backgroundColor = #colorLiteral(red: 0.6274509804, green: 0.6235294118, blue: 0.6549019608, alpha: 0.15)
        
//        self.halfLeftView.backgroundColor = #colorLiteral(red: 0.6274509804, green: 0.6235294118, blue: 0.6549019608, alpha: 0.15)
//        self.halfRightView.backgroundColor = #colorLiteral(red: 0.6274509804, green: 0.6235294118, blue: 0.6549019608, alpha: 0.15)

        self.leftView.backgroundColor = #colorLiteral(red: 0.6274509804, green: 0.6235294118, blue: 0.6549019608, alpha: 0.15)
        self.rightView.backgroundColor = #colorLiteral(red: 0.6274509804, green: 0.6235294118, blue: 0.6549019608, alpha: 0.15)
        
        dotViewsArray = [dotOneView, dotTwoView, dotThreeView, dotFourView]
        initialHideDots()
    }
    
    func resetViewsState() {
        self.backgroundColor = .clear
        self.nodeView.isHidden = true
        self.halfLeftView.isHidden = true
        self.halfRightView.isHidden = true
        self.leftView.isHidden = true
        self.rightView.isHidden = true
    }
    
    func configCell(date: String, cellMode: CalendarDayCellMode) {
        self.resetViewsState()
        switch cellMode {
        case .singleHead:
            self.nodeView.isHidden = false
            self.dateLabel.textColor = AppColors.themeBlue
        case .singleTail:
            self.nodeView.isHidden = false
            self.dateLabel.textColor = AppColors.themeBlue
        case .head:
            self.nodeView.isHidden = false
            self.halfRightView.isHidden = false
            self.dateLabel.textColor = AppColors.themeBlue
        case .tail:
            self.nodeView.isHidden = false
            self.halfLeftView.isHidden = false
            self.dateLabel.textColor = AppColors.themeBlue
        case .mid:
            self.backgroundColor = #colorLiteral(red: 0.6274509804, green: 0.6235294118, blue: 0.6549019608, alpha: 0.15)
            self.dateLabel.textColor = AppColors.themeBlue //AppColors.normalTextColor
        case .left:
            self.leftView.isHidden = false
            self.dateLabel.textColor = AppColors.themeBlue //AppColors.normalTextColor
        case .right:
            self.rightView.isHidden = false
            self.dateLabel.textColor = AppColors.themeBlue
        case .outDates:
            self.dateLabel.textColor = .clear
        case .none:
            self.dateLabel.textColor = AppColors.themeBlue //AppColors.gray45
        case .pastDates:
            self.dateLabel.textColor = AppColors.pastDateColor //AppColors.tabBarUnselected
        case .futureDates:
            self.dateLabel.textColor = AppColors.pastDateColor //AppColors.tabBarUnselected
        }
        self.dateLabel.text = date
        setupFonts(cellMode: cellMode)
    }
    
    private func setupFonts(cellMode: CalendarDayCellMode) {
        switch cellMode {
        case .singleHead, .singleTail, .head, .tail:
            self.dateLabel.font = UIFont.kAppDefaultFontBold(ofSize: 14)
            self.dateLabel.textColor = AppColors.themeBlue
        default:
            self.dateLabel.font = UIFont.systemFont(ofSize: 14)
        }
    }
    
    func initialHideDots() {
        for i in 0..<dotViewsArray.count {
            dotViewsArray[i].isHidden = true
        }
    }
    
    func setDotColors(_ colors: [UIColor]) {
        for i in 0..<colors.count {
            dotViewsArray[i].isHidden = false
            dotViewsArray[i].backgroundColor = colors[i]
        }
    }
}


final class CustomFlowLayout: UICollectionViewFlowLayout {

    let cellSpacing: CGFloat = 0

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if let attributes = super.layoutAttributesForElements(in: rect) {
            for (index, attribute) in attributes.enumerated() {
                if index == 0 { continue }
                let prevLayoutAttributes = attributes[index - 1]
                let origin = prevLayoutAttributes.frame.maxX
                if (origin + cellSpacing + attribute.frame.size.width < self.collectionViewContentSize.width) {
                    attribute.frame.origin.x = origin + cellSpacing
                }
            }
            return attributes
        }
        return nil
    }
}
