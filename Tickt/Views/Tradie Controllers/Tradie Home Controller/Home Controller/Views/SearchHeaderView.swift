//
//  SeachHeaderView.swift
//  Tickt
//
//  Created by Admin on 30/03/21.
//

import UIKit

class SearchHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var headerLabel: CustomBoldLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()        
    }        
}

extension UITableViewHeaderFooterView {
    public static var defaultReuseIdentifier: String {
        return "\(self)"
    }
}
