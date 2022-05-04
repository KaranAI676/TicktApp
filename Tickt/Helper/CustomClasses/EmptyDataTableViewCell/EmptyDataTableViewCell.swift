//
//  EmptyDataTableViewCell.swift
//  Tickt
//
//  Created by Tickt on 28/07/20.
//  Copyright © 2020 Tickt. All rights reserved.
//

import UIKit

class EmptyDataTableViewCell: UITableViewCell {
    
    //MARK:- Variables
    //================
    
    //MARK:- IBOutlets
    //================
    @IBOutlet weak var emptyMessageLabel: UILabel!
    
    //MARK:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }
    
    //MARK:- Functions
    //================
    private func configureUI() {
        self.emptyMessageLabel.text = ""
        self.emptyMessageLabel.textColor = UIColor.lightGray
        self.emptyMessageLabel.numberOfLines = 0
        self.emptyMessageLabel.textAlignment = .center
        self.emptyMessageLabel.font = UIFont.kAppDefaultFontBold()
    }
    
    func configCell(title: String, textColor: UIColor = UIColor.lightGray, textFont: UIFont = UIFont.kAppDefaultFontBold(ofSize: 20)) {
        self.emptyMessageLabel.text = title
        self.emptyMessageLabel.textColor = textColor
        self.emptyMessageLabel.font = textFont
    }
    
    static func getEmptyDataTableViewCell(tableView: UITableView, indexPath: IndexPath, title: String, textColor: UIColor = UIColor.lightGray, textFont: UIFont = UIFont.kAppDefaultFontBold()) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: EmptyDataTableViewCell.self, indexPath: indexPath)
        cell.configCell(title: title, textColor: textColor, textFont: textFont)
        return cell
    }
}
