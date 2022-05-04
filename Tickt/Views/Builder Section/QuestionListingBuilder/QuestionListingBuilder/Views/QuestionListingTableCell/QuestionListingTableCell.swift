//
//  QuestionListingTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 12/05/21.
//

import UIKit

class QuestionListingTableCell: UITableViewCell {
    
    enum ButtonType {
        case edit
        case reply
        case delete
        case answerReply
    }
    
    //MARK:- IB Outlets
    @IBOutlet weak var mainContainerView: UIView!
    /// QuestionView
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var replyButtonBackView: UIView!
    @IBOutlet weak var showAnswerButton: UIButton!
    /// AnswerView
    @IBOutlet weak var answerView: UIView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var answerUserImageView: UIImageView!
    @IBOutlet weak var answerUserNameLabel: UILabel!
    @IBOutlet weak var answerDateLabel: UILabel!
    @IBOutlet weak var answerViewAdjustLabel: UILabel!
    @IBOutlet weak var answerButtonButtonHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnReply: UIButton!
    
    //MARK:- Variables
    var tableView: UITableView?
    var isEditingEnable: Bool = true
    var model: QuestionResult? {
        didSet {
            populateUI()
        }
    }
    var buttonClosure: ((ButtonType, IndexPath)->(Void))? = nil
    var showHideButtonClosure: ((IndexPath, Bool)->(Void))? = nil
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        guard  let tableView = self.tableView else { return }
        switch sender {
        case editButton:
            if let index = tableViewIndexPath(tableView) {
                self.buttonClosure?(.edit, index)
            }
        case deleteButton:
            if let index = tableViewIndexPath(tableView) {
                self.buttonClosure?(.delete, index)
            }
        case replyButton:
            if let index = tableViewIndexPath(tableView) {
                self.buttonClosure?(.reply, index)
            }
        case showAnswerButton:
            if let index = tableViewIndexPath(tableView) {
                self.showHideButtonClosure?(index, !(self.model?.questionData?.isAnswerShown ?? false))
            }
        case btnReply:
            if let index = tableViewIndexPath(tableView) {
                self.buttonClosure?(.answerReply, index)
            }
        default:
            break
        }
    }
}

extension QuestionListingTableCell {
    
    private func populateUI() {
        guard let model = model else { return }
        /// Question
        userImage.sd_setImage(with: URL(string:(model.questionData?.userImage ?? "")), placeholderImage: #imageLiteral(resourceName: "Placeholder"), options: .highPriority)
        nameLabel.text = model.questionData?.userName
        dateLabel.text = model.questionData?.date ?? ""
        questionLabel.text = model.questionData?.question
        
//        /// Answer
//        answerUserImageView.sd_setImage(with: URL(string:(model.questionData?.answerData?.userImage ?? "")), placeholderImage: #imageLiteral(resourceName: "Placeholder"), options: .highPriority)
//        answerUserNameLabel.text = model.questionData?.answerData?.
//        answerDateLabel.text = model.questionData?.answerData?.date
//        answerLabel.text = model.questionData?.answerData?.answer
//
//        /// Hide/unhide the views
//        answerView.isHidden = !(model.questionData?.isAnswerShown ?? false)
//        showAnswerButton.isHidden = (model.questionData?.answerData?.answerId.isNil ?? true ||
//                                        model.questionData?.answerData?.answerId?.isEmpty ?? true)
//        if isEditingEnable {
//            replyButtonBackView.isHidden = !(model.questionData?.answerData?.answerId.isNil ?? true ||
//                                                model.questionData?.answerData?.answerId?.isEmpty ?? true)
//        }else {
//            answerViewAdjustLabel.isHidden = true
//            replyButtonBackView.isHidden = true
//            editButton.isHidden = true
//            deleteButton.isHidden = true
//        }  Happy
        
        /// Button Titile
        let title: String = answerView.isHidden ? "Show answer" : "Hide answer"
        showAnswerButton.setTitleForAllMode(title: title)
    }
}
