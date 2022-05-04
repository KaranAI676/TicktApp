//
//  CommonTextViewTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 18/06/21.
//

import UIKit

class CommonTextViewTableCell: UITableViewCell {

    enum CellType {
        case declineMilestone
        case addVouch
    }
    
    //MARK:- IB Outlets
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var textViewOutlet: UITextView!
    @IBOutlet weak var textViewBackView: UIView!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    
    //MARK:- Variables
    var cellType: CellType = .declineMilestone {
        didSet {
            setupTextView()
        }
    }
    private var maxLength = 1000
    var placeHolder: String = ""
    var placeHolderColor: UIColor = #colorLiteral(red: 0.8745098039, green: 0.8980392157, blue: 0.937254902, alpha: 1)
    var placeHolderFont: UIFont = UIFont.kAppDefaultFontMedium(ofSize: 16)
    var textColorr: UIColor = #colorLiteral(red: 0.0862745098, green: 0.1137254902, blue: 0.2901960784, alpha: 1)
    var textFont: UIFont = UIFont.kAppDefaultFontMedium(ofSize: 16)
    var tableView: UITableView? = nil
    var updateTextWithIndexClosure: ((String, IndexPath)->Void)? = nil
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension CommonTextViewTableCell {
    
    private func configUI() {
        textViewOutlet.delegate = self
    }
    
    private func setupTextView() {
        switch cellType {
        case .declineMilestone:
            textViewBackView.borderWidth = 1
            textViewBackView.borderColor = #colorLiteral(red: 0.8745098039, green: 0.8980392157, blue: 0.937254902, alpha: 1)
            textViewBackView.round(radius: 4)
            ///
            placeHolder = "It's really bad work, because"
            placeHolderColor = #colorLiteral(red: 0.8745098039, green: 0.8980392157, blue: 0.937254902, alpha: 1)
            placeHolderFont = UIFont.kAppDefaultFontMedium(ofSize: 16)
        case .addVouch:
            placeHolder = "Text"
            placeHolderColor = #colorLiteral(red: 0.8745098039, green: 0.8980392157, blue: 0.937254902, alpha: 1)
            placeHolderFont = UIFont.systemFont(ofSize: 14)
            ///
            textViewBackView.borderWidth = 1
            textViewBackView.borderColor = #colorLiteral(red: 0.8745098039, green: 0.8980392157, blue: 0.937254902, alpha: 1)
            textViewBackView.round(radius: 6)
        }
        if textViewOutlet.text.byRemovingLeadingTrailingWhiteSpaces == "" {
            textViewOutlet.text = placeHolder
            textViewOutlet.font = placeHolderFont
            textViewOutlet.textColor = placeHolderColor
        }
    }
}

extension CommonTextViewTableCell: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let text = textView.text {
            textView.text = text.byRemovingLeadingTrailingWhiteSpaces
            if text == placeHolder {
                textView.text = ""
                textView.font = textFont
                textView.textColor = textColorr
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let text = textView.text {
            textView.text = text.byRemovingLeadingTrailingWhiteSpaces
            if text == "" {
                textView.text = placeHolder
                textView.font = placeHolderFont
                textView.textColor = placeHolderColor
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard text.rangeOfCharacter(from: CharacterSet.newlines) == nil else {
            textView.resignFirstResponder()
            return false
        }
        let txtt: NSString = textView.text as NSString
        let newString = txtt.replacingCharacters(in: range, with: text)
        if text == placeHolder {
            textView.text = ""
        }
        if let tableView = tableView, let index = tableViewIndexPath(tableView) {
            updateTextWithIndexClosure?(textView.text.byRemovingLeadingTrailingWhiteSpaces, index)
        }
        return newString.count <= self.maxLength
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if let tableView = tableView, let index = tableViewIndexPath(tableView) {
            updateTextWithIndexClosure?(textView.text.byRemovingLeadingTrailingWhiteSpaces, index)
        }
    }
}
