//
//  CalendarMonthCollectionReusableView.swift
//  Tickt
//
//  Created by Tickt on 09/02/21.
//  Copyright © 2021 Tickt. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarMonthCollectionReusableView: JTACMonthReusableView {
    
    @IBOutlet weak var monthTitleLabel: UILabel!
    @IBOutlet weak var monLabel: UILabel!
    @IBOutlet weak var tueLabel: UILabel!
    @IBOutlet weak var wedLabel: UILabel!
    @IBOutlet weak var thuLabel: UILabel!
    @IBOutlet weak var friLabel: UILabel!
    @IBOutlet weak var satLabel: UILabel!
    @IBOutlet weak var sunLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
