//
//  MilestoneListingVC + DotColorMethods.swift
//  Tickt
//
//  Created by S H U B H A M on 22/07/21.
//

import Foundation

extension MilestoneListingVC {
    
    func manageDotColor() {
        milestoneColorsArray = getUniqueColorsArray()
        MilestoneListingVC.datesDict = getColorsDictionary()
    }
    
    private func getUniqueColorsArray() -> [UIColor] {
        UIColor().generateRandomColors(milestonesArray.count, colorArray: milestoneColorsArray)
    }
    
    private func getColorsDictionary() -> [Date: [UIColor]] {
        var datesArray = [Date]() { didSet { datesArray = datesArray.unique() }}
        var dict = [Date: [UIColor]]()
        
        /// Assign unique color to each milestone
        for i in 0..<milestonesArray.count {
            milestonesArray[i].dotColor = milestoneColorsArray[i]
            if let fromDate = milestonesArray[i].fromDate.date {
                datesArray.append(fromDate)
            }
            if let toDate = milestonesArray[i].toDate.date {
                datesArray.append(toDate)
            }
        }
        
        /// Make dict of color with the date key
        let _ = datesArray.map({ eachDate in
            let colorArray: [UIColor] = milestonesArray.filter({ $0.fromDate.date == eachDate || $0.toDate.date == eachDate }).compactMap({ eachColor -> UIColor? in
                return eachColor.dotColor
            })
            dict[eachDate] = colorArray
        })
        
        return dict
    }
}
