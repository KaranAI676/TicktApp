//
//  QuestionVC.swift
//  Tickt
//
//  Created by Admin on 04/05/21.
//

import UIKit

class QuestionVC: BaseVC {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var questionTableView: UITableView!
    @IBOutlet weak var questionButton: CustomBoldButton!
    @IBOutlet weak var watermarkLabel: CustomMediumLabel!
    @IBOutlet weak var categoryNameLabel: CustomBoldLabel!
    @IBOutlet weak var questionCountLabel: CustomRomanLabel!
    
    var jobId = ""
    var tradeId = ""
    var jobName = ""
    var editIndex = -1
    var builderId = ""
    var builderName = ""
    var isPastJob = false
    var specializationId = ""
    var viewModel = QuestionVM()
    var questionModel: QuestionModel?
    var updateQuestionCountAction: ((_ count: Int)->())?
    var currentIndexPath: IndexPath? = nil
    
    lazy var refreshControl: UIRefreshControl = {
        $0.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return $0
    }(UIRefreshControl())
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getQuestions(page: 1, jobId: jobId)
    }
    
    @objc func refreshData() {
        viewModel.getQuestions(page: 1, jobId: jobId)
    }
    
    func initialSetup() {
        viewModel.delegate = self
        categoryNameLabel.text = jobName
        questionCountLabel.text = "0 question(s)"
        questionTableView.addSubview(refreshControl)
        questionTableView.estimatedSectionHeaderHeight = 300
        questionTableView.sectionHeaderHeight = UITableView.automaticDimension
        questionTableView.register(UINib(nibName: AnswerCell.defaultReuseIdentifier, bundle: Bundle.main), forCellReuseIdentifier: AnswerCell.defaultReuseIdentifier)
        questionTableView.register(UINib(nibName: QuestionView.defaultReuseIdentifier, bundle: .main), forHeaderFooterViewReuseIdentifier: QuestionView.defaultReuseIdentifier)
        questionTableView.registerCell(with: QuestionListingAnswerTblCell.self)
        questionTableView.registerCell(with: QuestionListingHeaderTblCell.self)
        questionTableView.sectionHeaderHeight = UITableView.automaticDimension
        questionTableView.estimatedSectionHeaderHeight = 38
        
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender {
        case backButton:
            updateQuestionCountAction?(questionModel?.result.list.count ?? 0)
            pop()
        default:
            goToAskQuestion(isEdit: false, index: 0)
        }
    }
    
    func goToAskQuestion(isEdit: Bool, index: Int) {
        if !isPastJob {
            let askQuestionVC = AskQuestionVC.instantiate(fromAppStoryboard: .search)
            askQuestionVC.jobId = jobId
            if isEdit {
                askQuestionVC.question = self.questionModel?.result.list[index].question
                askQuestionVC.questionId = self.questionModel?.result.list[index]._id
            }
            askQuestionVC.tradeId = tradeId
            askQuestionVC.specializationId = specializationId
            askQuestionVC.isEdit = isEdit
            askQuestionVC.builderId = builderId
            askQuestionVC.builderName = builderName
            askQuestionVC.delegate = self
            push(vc: askQuestionVC)
        } else {
            CommonFunctions.showToastWithMessage("You cannot ask a question on past jobs")
        }
    }
    
    func goToAskQuestionVC(isEdit: Bool = false,type : QuestionListingBuilderVC.ScreenType) {
        let vc = AnswerBuilderVC.instantiate(fromAppStoryboard: .questionListingBuilder)
        vc.jobId = self.jobId
        vc.isEdit = isEdit
        vc.newbuilderId = self.builderId
        vc.newtradieId = self.tradeId
        if let index = currentIndexPath {
            switch type {
            case .questionAnswer:
                vc.answerObject = questionModel?.result.list[index.section].answers[index.row]
                vc.questionId = questionModel?.result.list[index.section]._id ?? ""
            case .answereReply:
                vc.screenType = .answereReply
                vc.answerObject = questionModel?.result.list[index.section].answers[index.row]
                vc.questionId = questionModel?.result.list[index.section]._id ?? ""
            default :
                break
            }
        }
        vc.delegate = self
        push(vc: vc)
    }
}


extension QuestionVC : UpdateAnswerDelegate {
    func didReplyOnReview(replyModel: ReviewBuilderReplyData) {
        self.viewModel.getQuestions(page: 1, jobId: jobId)
    }
    
    func didEditReply(updatedReply: String) {
        self.viewModel.getQuestions(page: 1, jobId: jobId)
    }
    
    func didEditReview(updatedReview: String, rating: Double) {
        self.viewModel.getQuestions(page: 1, jobId: jobId)
    }
    
    func didEditedAnswer(updatedAnswer: String) {
        self.viewModel.getQuestions(page: 1, jobId: jobId)
    }
    
    func didAnswerAdded(answer: AnswerData) {
        self.viewModel.getQuestions(page: 1, jobId: jobId)
    }
}
