//
//  ProfileFooterView.swift
//  Tickt
//
//  Created by Vijay's Macbook on 24/05/21.
//

class ProfileFooterView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var footerButton: CustomBoldButton!
    
    var buttonHandler: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()        
        footerButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    }
    
    @objc func buttonAction(_ sender: UIButton) {
        buttonHandler?()
    }
}
