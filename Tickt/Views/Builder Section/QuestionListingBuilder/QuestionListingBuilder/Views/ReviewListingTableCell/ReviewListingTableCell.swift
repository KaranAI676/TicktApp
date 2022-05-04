//
//  ReviewListingTableCell.swift
//  Tickt
//
//  Created by S H U B H A M on 19/06/21.
//

import UIKit
import Cosmos

class ReviewListingTableCell: UITableViewCell {
    
    enum ButtonType {
        case edit
        case reply
        case delete
    }
    
    //MARK:- IB Outlets
    @IBOutlet weak var mainContainerView: UIView!
    /// QuestionView
    @IBOutlet weak var reviewView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var reviewEditButton: UIButton!
    @IBOutlet weak var reviewDeleteButton: UIButton!
    @IBOutlet weak var showAnswerButton: UIButton!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var reviewAdjustLabel: UILabel!
    @IBOutlet weak var reviewEditOptionsStackView: UIStackView!
    /// AnswerView
    @IBOutlet weak var replyView: UIView!
    @IBOutlet weak var replyLabel: UILabel!
    @IBOutlet weak var replyEditButton: UIButton!
    @IBOutlet weak var replyDeleteButton: UIButton!
    @IBOutlet weak var replyUserImageView: UIImageView!
    @IBOutlet weak var replyUserNameLabel: UILabel!
    @IBOutlet weak var replyDateLabel: UILabel!
    @IBOutlet weak var replyAdjustLabel: UILabel!
    @IBOutlet weak var replyEditOptionsStackView: UIStackView!
    
    //MARK:- Variables
    var tableView: UITableView?
    var loggedInBuilder: Bool = false
    var model: ReviewBuilderDataModel? {
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
    
    //MARK:- IB Action
    @IBAction func buttobTapped(_ sender: UIButton) {
        guard  let tableView = self.tableView else { return }
        switch sender {
        case reviewEditButton, replyEditButton:
            if let index = tableViewIndexPath(tableView) {
                self.buttonClosure?(.edit, index)
            }
        case reviewDeleteButton, replyDeleteButton:
            if let index = tableViewIndexPath(tableView) {
                self.buttonClosure?(.delete, index)
            }
        case replyButton:
            if let index = tableViewIndexPath(tableView) {
                self.buttonClosure?(.reply, index)
            }
        case showAnswerButton:
            if let index = tableViewIndexPath(tableView) {
                self.showHideButtonClosure?(index, !(self.model?.isAnswerShown ?? false))
            }
        default:
            break
        }
    }
}


extension ReviewListingTableCell {
    
    private func populateUI() {
        ratingView.settings.fillMode = .half
        ratingView.settings.updateOnTouch = false
        guard let model = model else { return }
        /// Review View
        userImage.sd_setImage(with: URL(string: model.userImage), placeholderImage: #imageLiteral(resourceName: "Placeholder"), options: .highPriority)
        nameLabel.text = model.name
        dateLabel.text = model.date
        ratingView.rating = model.rating
        reviewLabel.attributedText = model.review.getFormattedReview()
        /// Reply View
        replyUserImageView.sd_setImage(with: URL(string: model.replyData.userImage ?? ""), placeholderImage: #imageLiteral(resourceName: "Placeholder"), options: .highPriority)
        replyUserNameLabel.text = model.replyData.name
        replyDateLabel.text = model.replyData.date
        replyLabel.text = model.replyData.reply
        
        if loggedInBuilder {
            /// Review View
            reviewEditButton.isHidden = true
            reviewDeleteButton.isHidden = true
            reviewEditOptionsStackView.isHidden = !(model.replyData.replyId ?? "").isEmpty
            showAnswerButton.isHidden = (model.replyData.replyId ?? "").isEmpty
            /// Reply View
            replyView.isHidden = !(model.isAnswerShown ?? false)
            replyEditButton.isHidden = !(model.replyData.isModifiable ?? false)
            replyDeleteButton.isHidden = !(model.replyData.isModifiable ?? false)
        }else {
            /// Review View
            replyButton.isHidden = true
            reviewEditOptionsStackView.isHidden = !model.isModifiable
            showAnswerButton.isHidden = (model.replyData.replyId ?? "").isEmpty
            /// Reply View
            replyView.isHidden = !(model.isAnswerShown ?? false)
            replyEditOptionsStackView.isHidden = !(model.replyData.isModifiable ?? false)
        }
        
        ///
        let title: String = replyView.isHidden ? "Show reply" : "Hide reply"
        showAnswerButton.setTitleForAllMode(title: title)
    }
}


//if loggedInBuilder {
//    /// Review View
//    replyButton.isHidden = !(model.replyData.replyId ?? "").isEmpty
//    reviewAdjustLabel.isHidden = !(model.replyData.replyId ?? "").isEmpty
//    reviewEditButton.isHidden = true
//    reviewDeleteButton.isHidden = true
//    showAnswerButton.isHidden = (model.replyData.replyId ?? "").isEmpty
//    /// Reply View
//    replyView.isHidden = !(model.isAnswerShown ?? false)
//    replyEditButton.isHidden = !(model.replyData.isModifiable ?? false)
//    replyDeleteButton.isHidden = !(model.replyData.isModifiable ?? false)
//}else {
//    /// Review View
//    replyButton.isHidden = true
//    reviewEditOptionsStackView.isHidden = !model.isModifiable
////            reviewEditButton.isHidden = !model.isModifiable
////            reviewDeleteButton.isHidden = !model.isModifiable
////            reviewAdjustLabel.isHidden = !model.isModifiable
//    showAnswerButton.isHidden = (model.replyData.replyId ?? "").isEmpty
//    /// Reply View
//    replyView.isHidden = !(model.isAnswerShown ?? false)
//    replyEditOptionsStackView.isHidden = !(model.replyData.isModifiable ?? false)
////            replyEditButton.isHidden = !(model.replyData.isModifiable ?? false)
////            replyDeleteButton.isHidden = !(model.replyData.isModifiable ?? false)
//}
