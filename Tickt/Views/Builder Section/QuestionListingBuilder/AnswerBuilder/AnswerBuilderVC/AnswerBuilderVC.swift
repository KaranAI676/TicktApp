//
//  AnswerBuilderVC.swift
//  Tickt
//
//  Created by S H U B H A M on 12/06/21.
//

import UIKit
import Cosmos
import UITextView_Placeholder

protocol UpdateAnswerDelegate: class {
    func didReplyOnReview(replyModel: ReviewBuilderReplyData)
    func didEditReply(updatedReply: String)
    func didEditReview(updatedReview: String, rating: Double)
    func didEditedAnswer(updatedAnswer: String)
    func didAnswerAdded(answer: AnswerData)
}

class AnswerBuilderVC: BaseVC {
                
    //MARK:- IB Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nameLabel: CustomBoldLabel!
    @IBOutlet weak var countLabel: CustomBoldLabel!
    @IBOutlet weak var sendButton: CustomBoldButton!
    @IBOutlet weak var errorLabel: CustomMediumLabel!
    @IBOutlet weak var cancelButton: CustomBoldButton!
    @IBOutlet weak var questionTextView: CustomRomanTextView!
    @IBOutlet weak var textViewTitleLabel: CustomMediumLabel!
    @IBOutlet weak var ratingBackView: UIView!
    @IBOutlet weak var ratingView: CosmosView!
    
    //MARK:- Variables
    var jobId = ""
    var isEdit = false
    var questionId: String = ""
    var canReply: Bool = true
    var newbuilderId: String = ""
    var newtradieId: String = ""
    var screenType: QuestionListingBuilderVC.ScreenType = .questionAnswer
    var answerObject: AnswerData?
    var reviewObject: ReviewBuilderDataModel?
    var viewModel = AnswerBuilderVM()
    weak var delegate: UpdateAnswerDelegate?
    
    
    //MARK:- LifeCyce Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.darkContent
    }
    
    //MARK:- IB Actions
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender {
        case backButton, cancelButton:
            pop()
        case sendButton:
            if validate() {
                switch screenType {
                case .questionAnswer:
                    if isEdit {
                        viewModel.editAnswer(answerId: answerObject?._id ?? "", questionId: questionId, answer: questionTextView.text, jobId: jobId)
                    } else {
                        AppRouter.showAppAlertWithCompletion(vc: self, alertType: .bothButton, alertTitle: "Alert", alertMessage: "Are you sure you want to post a answer?", acceptButtonTitle: "Yes", declineButtonTitle: "No") {
                            //self.viewModel.answerOnQuestion(jobId: self.jobId, questionId: self.questionId, answer: self.questionTextView.text)//HAppy
                            self.viewModel.replyOnAnswer(builderId: self.newbuilderId, tradieId: self.newtradieId, questionId: self.questionId, answer: self.questionTextView.text)
                        } dismissCompletion: { }
                    }
                    
                case .answereReply:
                    AppRouter.showAppAlertWithCompletion(vc: self, alertType: .bothButton, alertTitle: "Alert", alertMessage: "Are you sure you want to reply a answer?", acceptButtonTitle: "Yes", declineButtonTitle: "No") {
                        self.viewModel.replyOnAnswer(builderId: self.newbuilderId, tradieId: self.newtradieId, questionId: self.questionId, answer: self.questionTextView.text)
                    } dismissCompletion: { }
                case .review:
                    isEdit ?
                        viewModel.editReview(reviewId: reviewObject?.reviewId ?? "", review: questionTextView.text.byRemovingLeadingTrailingWhiteSpaces, rating: reviewObject?.rating ?? 0.0) : ()
                case .reviewReply:
                    isEdit ?
                        (viewModel.editReply(reviewId: reviewObject?.reviewId ?? "", reply: questionTextView.text.byRemovingLeadingTrailingWhiteSpaces , replyId: reviewObject?.replyData.replyId ?? "")) :
                        (viewModel.replyReview(reviewId: reviewObject?.reviewId ?? "", reply: questionTextView.text.byRemovingLeadingTrailingWhiteSpaces))
                }
            }
        default:
            break
        }
    }
}


extension AnswerBuilderVC {
    
    private func initialSetup() {
        setupDefaultLabel()
        setupRatingView()
        self.viewModel.delegate = self
    }
    
    private func setupRatingView() {
        if let object = reviewObject, object.isModifiable {
            ratingBackView.isHidden = false
            ratingView.settings.fillMode = .half
            ratingView.didFinishTouchingCosmos = { [weak self] rating in
                guard let self = self else { return }
                self.reviewObject?.rating = rating
            }
            ratingView.rating = object.rating
        }
    }
    
    private func setupDefaultLabel() {
        switch screenType {
        case .questionAnswer,.answereReply:
            textViewTitleLabel.text = "Your answer"
            questionTextView.placeholder = "Your answer..."
            if isEdit {
                questionTextView.text = answerObject?.answer
                countLabel.text = "\(answerObject?.answer.count ?? 0)/500"
                nameLabel.text = "Edit a answer"
                sendButton.setTitle("Save", for: .normal)
            }else {
                nameLabel.text = "Reply on question"
            }
        case .review:
            nameLabel.text = "Edit the review"
            questionTextView.placeholder = "Your review..."
            textViewTitleLabel.text = "Your review"
            if isEdit {
                questionTextView.text = reviewObject?.review
                countLabel.text = "\(reviewObject?.review.count ?? 0)/500"
                sendButton.setTitle("Save", for: .normal)
            }
        case .reviewReply:
            nameLabel.text = "Reply on review"
            questionTextView.placeholder = "Your reply"
            textViewTitleLabel.text = "Your reply"
            if isEdit {
                nameLabel.text = "Edit your reply"
                questionTextView.text = reviewObject?.replyData.reply
                countLabel.text = "\((reviewObject?.replyData.reply ?? "").count)/500"
                sendButton.setTitle("Save", for: .normal)
            }
        }
    }
    
    private func validate() -> Bool {
        if questionTextView.text.byRemovingLeadingTrailingWhiteSpaces.isEmpty {
            errorLabel.text = (screenType == .questionAnswer) ? Validation.errorEmptyAnswer : Validation.errorEmptyReviewEdit
            return false
        }
        errorLabel.text = ""
        
        if let object = reviewObject, object.isModifiable, !(object.rating > 0) {
            CommonFunctions.showToastWithMessage("Please select the rating")
            return false
        }

        return true
    }
}

//MARK:- UITextViewDelegate
//=========================
extension AnswerBuilderVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText: String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        if updatedText.count <= 500 {
            countLabel.text = "\(currentText.count)/500"
        }
        return updatedText.count <= 500
    }
}

//MARK:- AnswerBuilderVMDelegate
//==============================
extension AnswerBuilderVC: AnswerBuilderVMDelegate {
    
    func didEditReplySuccess(reply: String) {
        delegate?.didEditReply(updatedReply: reply)
        pop()
    }
    
    
    func didReplyOnReview(replyModel: ReviewBuilderReplyData) {
        delegate?.didReplyOnReview(replyModel: replyModel)
        pop()
    }
    
    
    func didEditReviewSuccess(updatedReview: String, rating: Double) {
        delegate?.didEditReview(updatedReview: updatedReview, rating: rating)
        self.pop()
    }
    
    func didEditAnsawerSuccess(updatedAnswer: String) {
        self.delegate?.didEditedAnswer(updatedAnswer: updatedAnswer)
        self.pop()
    }
    
    func didAnswerSucces(model: AnswerDatasModel) {
     //   self.delegate?.didAnswerAdded(answer: model)
        self.pop()
    }
    
    func failure(message: String) {
        CommonFunctions.showToastWithMessage(message)
    }
}
