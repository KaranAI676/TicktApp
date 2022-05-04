//
//  AskQuestionVC.swift
//  Tickt
//
//  Created by Admin on 04/05/21.
//

import UITextView_Placeholder

class AskQuestionVC: BaseVC {
                
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nameLabel: CustomBoldLabel!
    @IBOutlet weak var countLabel: CustomBoldLabel!
    @IBOutlet weak var sendButton: CustomBoldButton!
    @IBOutlet weak var errorLabel: CustomMediumLabel!
    @IBOutlet weak var cancelButton: CustomBoldButton!
    @IBOutlet weak var questionTextView: CustomRomanTextView!
    
    var jobId = ""
    var tradeId = ""
    var isEdit = false
    var builderId = ""
    var builderName = ""
    var specializationId = ""
    var question: String?
    var questionId : String?
    var viewModel = AskQuestionVM()
    weak var delegate: UpdateQuestionDelegate?
    
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
            questionTextView.text = question ?? ""
            countLabel.text = "\(question?.count ?? 0)/500"
            nameLabel.text = "Edit a question"
            sendButton.setTitle("Save", for: .normal)
        } else {
            nameLabel.text = "Ask \(builderName) a question"            
            sendButton.setTitle("Send", for: .normal)
        }
        questionTextView.placeholder = "Ask \(builderName) what you want to know.."
        viewModel.delegate = self
    }
    
    func validate() -> Bool {
        if questionTextView.text.isEmpty {
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
                if isEdit {
                    viewModel.editQuestion(questionId: questionId ?? "", question: questionTextView.text!)
                } else {
                    
                    AppRouter.showAppAlertWithCompletion(vc: nil, alertType: .bothButton,
                                                         alertTitle: "Ask Question",
                                                         alertMessage: "Are you sure you want to ask a question?",
                                                         acceptButtonTitle: "Yes",
                                                         declineButtonTitle: "No") { [weak self] in
                        guard let self = self else { return }
                        self.viewModel.askQuestion(jobId: self.jobId, question: self.questionTextView.text.byRemovingLeadingTrailingWhiteSpaces, builderId: self.builderId, tradeId: self.tradeId, specializationId: self.specializationId)
                    } dismissCompletion: { }
                }
            }
        default:
            pop()
        }
    }
    
    func showAlert() {
        
    }
}

extension AskQuestionVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText: String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        if updatedText.count <= 500 {
            countLabel.text = "\(currentText.count)/500"
        }
        return updatedText.count <= 500
    }
}

extension AskQuestionVC: AskQuestionDelegate {
    func didQuestionPosted(question: QuestionData) {
        if isEdit {
            delegate?.didEditedQuestion(question: question)
        } else {
            delegate?.didQuestionAdded(question: question)
        }
        pop()
    }
    
    func didQuestionPosted() {
        
    }
    
    func failure(error: String) {
        CommonFunctions.showToastWithMessage(error)
    }
}
