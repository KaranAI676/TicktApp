//
//  ReplyReviewVC.swift
//  Tickt
//
//  Created by Vijay's Macbook on 09/07/21.
//

import FloatRatingView

import UITextView_Placeholder

class ReplyReviewVC: BaseVC {
                
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var countLabel: CustomBoldLabel!
    @IBOutlet weak var sendButton: CustomBoldButton!
    @IBOutlet weak var errorLabel: CustomMediumLabel!
    @IBOutlet weak var starRatingView: FloatRatingView!
    @IBOutlet weak var replyTextView: CustomRomanTextView!
    @IBOutlet weak var starViewHeightConstraint: NSLayoutConstraint!
    
    var jobId = ""
    var review = ""
    var rating = 0.0
    var replyId = ""
    var reviewId = ""
    var isEdit = false
    var builderId = ""
    var viewModel = ReviewReplyVM()
    var isOtherProfileReview = false
    var updateReviewReplyHeader: (()->())?
    var updateReviewReply: ((_ replyData: ReplyResult)->())?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        kAppDelegate.setUpKeyboardSetup(status: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        kAppDelegate.setUpKeyboardSetup(status: true)
    }
    
    func initialSetup() {
        if isEdit {
            replyTextView.text = review
            countLabel.text = "\(review.count)/1000"
            sendButton.setTitle("Save", for: .normal)
        } else {
            sendButton.setTitle("Send", for: .normal)
        }
        if isOtherProfileReview {
            starRatingView.rating = rating
            starRatingView.type = .halfRatings
            starViewHeightConstraint.constant = 30
        }
        replyTextView.placeholder = "Reply builder"
        viewModel.delegate = self
    }
    
    func validate() -> Bool {
        if replyTextView.text.isEmpty {
            errorLabel.text = Validation.errorEmptyQuestion
            return false
        }
        errorLabel.text = ""
        return true
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender {
        case backButton:
            pop()
        case sendButton:
            if validate() {
                if isOtherProfileReview {
                    viewModel.reviewBuilder(builderId: builderId, jobId: jobId, review: review, rating: "\(rating)")
                } else {
                    if isEdit {
                        viewModel.reviewReply(reviewId: reviewId, isEdit: true, reply: replyTextView.text!, replyId: replyId)
                    } else {
                        
                        AppRouter.showAppAlertWithCompletion(vc: nil, alertType: .bothButton,
                                                             alertTitle: "Reply review",
                                                             alertMessage: "Are you sure you want to reply to the review?",
                                                             acceptButtonTitle: "Yes",
                                                             declineButtonTitle: "No") { [weak self] in
                            guard let self = self else { return }
                            self.viewModel.reviewReply(reviewId: self.reviewId, isEdit: false, reply: self.replyTextView.text!, replyId: self.replyId)
                        } dismissCompletion: { }
                    }
                }
            }
        default:
            pop()
        }
    }
}

extension ReplyReviewVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText: String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        if updatedText.count <= 1000 {
            countLabel.text = "\(currentText.count)/1000"
        }
        return updatedText.count <= 1000
    }
}

extension ReplyReviewVC: ReviewReplyDelegate {
            
    func didReviewAdded(reply: ReplyResult) {
        updateReviewReply?(reply)
        pop()
    }
    
    func didReviewUpdated() {
        updateReviewReplyHeader?()
        pop()
    }

    func failure(error: String) {
        CommonFunctions.showToastWithMessage(error)
    }
}
