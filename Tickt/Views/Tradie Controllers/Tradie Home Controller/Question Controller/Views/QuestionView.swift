//
//  QuestionView.swift
//  Tickt
//
//  Created by Admin on 06/05/21.
//

import UIKit

class QuestionView: UITableViewHeaderFooterView {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: CustomBoldLabel!
    @IBOutlet weak var editButton: CustomBoldButton!
    @IBOutlet weak var dateLabel: CustomRegularLabel!
    @IBOutlet weak var deleteButton: CustomBoldButton!
    @IBOutlet weak var questionLabel: CustomRomanLabel!
    @IBOutlet weak var showAnswerButton: CustomBoldButton!
    @IBOutlet weak var editButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var answerButtonButtonHeight: NSLayoutConstraint!
    
    var editButtonClosure: (() -> ())?
    var deleteButtonClosure: (() -> ())?
    var showAnswerButtonClosure: (() -> ())?
     
    var question: QuestionData? {
        didSet {
            dateLabel.text = question?.date
            nameLabel.text = question?.userName
            questionLabel.text = question?.question
            userImage.sd_setImage(with: URL(string: question?.userImage ?? ""), placeholderImage: #imageLiteral(resourceName: "Placeholder"))
            if question?.isModifiable ?? false {
                editButtonHeight.constant = 40
            } else {
                editButtonHeight.constant = 0
            }
            let answerShown = question?.isAnswerShown ?? false
            if question?.answerData?._id != nil, !answerShown {
                answerButtonButtonHeight.constant = 40
            } else {
                answerButtonButtonHeight.constant = 0
            }
            layoutIfNeeded()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender {
        case editButton:
            editButtonClosure?()
        case deleteButton:
            deleteButtonClosure?()
        case showAnswerButton:
            showAnswerButtonClosure?()
        default:
            break
        }
    }
}
