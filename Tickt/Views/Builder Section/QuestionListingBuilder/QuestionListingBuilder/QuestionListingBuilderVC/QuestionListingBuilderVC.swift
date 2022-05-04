//
//  QuestionListingBuilderVC.swift
//  Tickt
//
//  Created by S H U B H A M on 12/05/21.
//

import UIKit

protocol QuestionListingBuilderVCDelegate: AnyObject {
    func getDeletedReview(id: String)
    func getEditReply(reviewId: String, model: ReviewListBuilderResultModel)
    func getEditReview(id: String, editReview: String, rating: Double)
}

class QuestionListingBuilderVC: BaseVC {
    
    enum ScreenType {
        case questionAnswer
        case review
        case reviewReply
        case answereReply
    }
    
    //MARK:- IB Outlets
    /// Nav Bar
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    ///
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var countLabel: UILabel!
    
    //MARK:- Variables
    var jobId: String = ""
    var jobName: String = ""
    var tradieId: String = ""
    var newbuilderId: String = ""
    var newtradieId: String = ""
    //    var loggedInBuilder: Bool = false
    var isJobExpired: Bool = false
    var viewModel = QuestionListingBuilderVM()
    var screenType: ScreenType = .questionAnswer
    var delegate: QuestionListingBuilderVCDelegate? = nil
    var currentIndexPath: IndexPath? = nil
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = AppColors.themeBlue
        refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hitAPI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.darkContent
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        self.pop()
    }
}

//MARK:- Private Methods
//======================
extension QuestionListingBuilderVC {
    
    private func initialSetup() {
        viewModel.delegate = self
        self.tableViewOutlet.estimatedRowHeight = 30
        viewModel.tableViewOutlet = tableViewOutlet
        hitPagination()
        countLabel.isHidden = true
        screenTitleLabel.text = jobName
        setupTableView()
    }
    
    func hitAPI(pullToRefresh: Bool =  false) {
        switch screenType {
        case .questionAnswer,.answereReply:
            viewModel.getQuestions(jobId: self.jobId, showLoader: !pullToRefresh, pullToRefresh: pullToRefresh)
        case .review, .reviewReply:
            viewModel.getReviews(tradieId: tradieId, showLoader: !pullToRefresh, pullToRefresh: pullToRefresh)
        }
    }
    
    private func setupTableView() {
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
        tableViewOutlet.contentInset.bottom = 20
        tableViewOutlet.refreshControl = self.refresher
        tableViewOutlet.registerCell(with: QuestionListingHeaderTblCell.self)
        tableViewOutlet.registerCell(with: ReviewListingTableCell.self)
        tableViewOutlet.registerCell(with: QuestionListingAnswerTblCell.self)
        tableViewOutlet.registerCell(with: ReviewListingTableCell.self)
        tableViewOutlet.sectionHeaderHeight = UITableView.automaticDimension
        tableViewOutlet.estimatedSectionHeaderHeight = 38
    }
    
    private func goToAskQuestionVC(isEdit: Bool = false) {
        let vc = AnswerBuilderVC.instantiate(fromAppStoryboard: .questionListingBuilder)
        vc.jobId = self.jobId
        vc.isEdit = isEdit
        vc.screenType = screenType
        vc.newbuilderId = newbuilderId
        vc.newtradieId = newtradieId
        if let index = currentIndexPath {
            switch screenType {
            case .questionAnswer:
                if isEdit {
                    vc.answerObject = self.viewModel.questionmodel?.result.list[index.section].answers[index.row]
                }
                // vc.answerObject = self.viewModel.questionmodel?.result.list[index.section].answers[index.row]
                vc.questionId = self.viewModel.questionmodel?.result.list[index.section]._id ?? ""
            case .review:
                vc.reviewObject = viewModel.reviewModel?.result.list[index.row].reviewData
            case .reviewReply:
                vc.reviewObject = viewModel.reviewModel?.result.list[index.row].reviewData
            case .answereReply:
                vc.screenType = .answereReply
                vc.answerObject = self.viewModel.questionmodel?.result.list[index.section].answers[index.row]
                vc.questionId = self.viewModel.questionmodel?.result.list[index.section]._id ?? ""
            }
        }
        vc.delegate = self
        push(vc: vc)
    }
    
    private func setupCount(count: Int) {
        switch screenType {
        case .questionAnswer:
            self.countLabel.isHidden = count == 0
            self.countLabel.text = "\(count) \(count > 1 ? "question(s)" : "question(s)")"
            count == 0 ? showWaterMarkLabel(message: "No questions found") : hideWaterMarkLabel()
        case .review, .reviewReply:
            self.screenTitleLabel.text = "\(count)  \(count > 1 ? "review(s)" : "review(s)")"
        case .answereReply:
            break // ARsh
        }
    }
    
    func hitPagination() {
        viewModel.hitPagination = {
            switch self.screenType {
            case .questionAnswer:
                break
            //   self.viewModel.getQuestions(jobId: self.jobId, showLoader: false)
            case .review, .reviewReply:
                self.viewModel.getReviews(tradieId: self.tradieId, showLoader: false)
            case .answereReply:
                break
            }
        }
    }
    
    @objc func pullToRefresh() {
        hitAPI(pullToRefresh: true)
    }
}

//MARK:- UITableView: Delegate
//============================
extension QuestionListingBuilderVC: TableDelegate {

    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch screenType {
        case .questionAnswer,.answereReply:
            return self.viewModel.questionmodel?.result.list.count ?? 0 
        case .review, .reviewReply:
            return viewModel.reviewModel?.result.list.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch screenType {
        case .questionAnswer,.answereReply:
            if let questions = self.viewModel.questionmodel?.result.list , section < questions.count {
                let question = questions[section]
                if question.isShowAll {
                    return question.answers.count
                }else{
                    return (question.answers.count) > 3 ? 3 : question.answers.count
                    
                }
            }
            return 0
        case .review, .reviewReply:
            return viewModel.reviewModel?.result.list.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch screenType {
        case .questionAnswer,.answereReply:
            let cell = tableView.dequeueCell(with: QuestionListingHeaderTblCell.self)
            if let data = self.viewModel.questionmodel?.result.list[section] {
                cell.populateUI(index: section, question: data)
            }
            cell.delegate = self
            return cell
        case .review, .reviewReply:
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch screenType {
        case .questionAnswer,.answereReply:
            return UITableView.automaticDimension
        case .review, .reviewReply:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch screenType {
        case .questionAnswer, .answereReply :
            let cell = tableView.dequeueCell(with: QuestionListingAnswerTblCell.self)
            let totalAnswer = self.viewModel.questionmodel?.result.list[indexPath.section].answers.count ?? 0
            if let data = self.viewModel.questionmodel?.result.list[indexPath.section].answers[indexPath.row] {
                cell.populateUI(indexPath: indexPath, answer: data, count: totalAnswer, showAll: self.viewModel.questionmodel?.result.list[indexPath.section].isShowAll ?? false)
            }
            cell.delegate = self
            return cell
        //            let cell = tableView.dequeueCell(with: QuestionListingTableCell.self)
        //            cell.tableView = tableView
        //            cell.isEditingEnable = !isJobExpired
        //            cell.model = self.viewModel.questionmodel?.result.list[indexPath.row]
        //            viewModel.hitPagination(index: indexPath.row, screenType: screenType)
        //            cell.buttonClosure = { [weak self] (buttonType, index) in
        //                guard let self = self else { return }
        //                switch buttonType {
        //                case .reply:
        //                    self.screenType = .questionAnswer
        //                    self.currentIndexPath = index
        //                    self.goToAskQuestionVC()
        //                case .edit:
        //                    self.screenType = .questionAnswer
        //                    self.currentIndexPath = index
        //                    self.goToAskQuestionVC(isEdit: true)
        //                case .delete:
        //                    self.currentIndexPath = index
        //                    AppRouter.showAppAlertWithCompletion(vc: self, alertType: .bothButton, alertTitle: "Alert", alertMessage: "Are you sure you want to delete a answer?", acceptButtonTitle: "Yes", declineButtonTitle: "No") {
        //                        self.viewModel.deleteAnswer(questionId: self.viewModel.questionmodel?.result.list[index.section]._id ?? "", answerId: self.viewModel.questionmodel?.result.list[index.section].answers[index.row]._id ?? "")
        //                    } dismissCompletion: { }
        //                case .answerReply:
        //                    self.screenType = .answereReply
        //                    self.currentIndexPath = index
        //                    self.goToAskQuestionVC()
        //                }
        //            }
        //            cell.showHideButtonClosure = { [weak self] (index, bool) in
        //                guard let self = self else { return }
        //                self.currentIndexPath = index
        //                self.viewModel.questionmodel?.result.list[index.row].questionData?.isAnswerShown = bool
        //                self.tableViewOutlet.reloadRows(at: [index], with: .automatic)
        //            }
        //            return cell
        case .review, .reviewReply:
            let cell = tableView.dequeueCell(with: ReviewListingTableCell.self)
            cell.tableView = tableView
            cell.loggedInBuilder = screenType == .reviewReply
            cell.model = viewModel.reviewModel?.result.list[indexPath.row].reviewData
            viewModel.hitPagination(index: indexPath.row, screenType: screenType)
            cell.buttonClosure = { [weak self] (buttonType, index) in
                guard let self = self else { return }
                switch buttonType {
                case .reply:
                    self.currentIndexPath = index
                    self.goToAskQuestionVC()
                case .edit:
                    self.currentIndexPath = index
                    self.goToAskQuestionVC(isEdit: true)
                case .delete:
                    self.currentIndexPath = index
                    switch self.screenType {
                    case .review:
                        AppRouter.showAppAlertWithCompletion(vc: self, alertType: .bothButton, alertTitle: "Alert", alertMessage: "Are you sure you want to delete a review?", acceptButtonTitle: "Yes", declineButtonTitle: "No") {
                            self.viewModel.deleteReview(reviewId: self.viewModel.reviewModel?.result.list[index.row].reviewData.reviewId ?? "")
                        } dismissCompletion: { }
                    case .reviewReply:
                        AppRouter.showAppAlertWithCompletion(vc: self, alertType: .bothButton, alertTitle: "Alert", alertMessage: "Are you sure you want to delete a reply?", acceptButtonTitle: "Yes", declineButtonTitle: "No") {
                            self.viewModel.deleteReply(reviewId: self.viewModel.reviewModel?.result.list[index.row].reviewData.reviewId ?? "", replyId: self.viewModel.reviewModel?.result.list[index.row].reviewData.replyData.replyId ?? "")
                        } dismissCompletion: { }
                    default:
                        break
                    }
                }
            }
            
            cell.showHideButtonClosure = { [weak self] (index, bool) in
                guard let self = self else { return }
                self.currentIndexPath = index
                self.viewModel.reviewModel?.result.list[index.row].reviewData.isAnswerShown = bool
                self.tableViewOutlet.reloadRows(at: [index], with: .automatic)
            }
            return cell
        }
    }
}

//MARK:- QuestionListingBuilderVM: Delegate
//=========================================
extension QuestionListingBuilderVC: QuestionListingBuilderVMDelegate {
    
    func didGetQuestions(model: QuestionModel) {
        self.viewModel.questionmodel = model
        setupCount(count: model.result.questionCount)
        refresher.endRefreshing()
        tableViewOutlet.reloadData()
    }
    
    
    func didReplyOnReview(replyModel: ReviewBuilderReplyData) {
        if let index = currentIndexPath {
            viewModel.reviewModel?.result.list[index.row].reviewData.replyData = replyModel
            viewModel.reviewModel?.result.list[index.row].reviewData.replyData.isModifiable = true
            tableViewOutlet.reloadData()
        }
    }
    
    func successDeleteReply() {
        if let index = currentIndexPath {
            viewModel.reviewModel?.result.list[index.row].reviewData.replyData = ReviewBuilderReplyData()
            viewModel.reviewModel?.result.list[index.row].reviewData.isAnswerShown = false
            tableViewOutlet.reloadData()
        }
    }
    
    func successDeleteReview() {
        if let index = currentIndexPath {
            delegate?.getDeletedReview(id: viewModel.reviewModel?.result.list[index.row].reviewData.reviewId ?? "")
            viewModel.reviewModel?.result.list.remove(at: index.row)
            setupCount(count: viewModel.reviewModel?.result.reviewCount ?? 0)
            tableViewOutlet.reloadData()
        }
    }
    
    func successGettingReviews() {
        setupCount(count: viewModel.reviewModel?.result.reviewCount ?? 0)
        refresher.endRefreshing()
        tableViewOutlet.reloadData()
    }
    
    func successDeleteAnswer() {
        if let index = currentIndexPath {
            viewModel.questionmodel?.result.list[index.section].answers.remove(at: index.row)
            //  viewModel.questionmodel?.result.list[index.section].questionData?.isAnswerShown = false Happy
            tableViewOutlet.reloadData()
        }
    }
    
    func successGettingQuestions() {
        setupCount(count: self.viewModel.questionmodel?.result.questionCount ?? 0)
        refresher.endRefreshing()
        tableViewOutlet.reloadData()
    }
    
    func failure(message: String) {
        CommonFunctions.showToastWithMessage(message)
        refresher.endRefreshing()
    }
}

//MARK:- UpdateAnswer: Delegate
//=============================
extension QuestionListingBuilderVC: UpdateAnswerDelegate {
    
    func didEditReply(updatedReply: String) {
        if let index = currentIndexPath {
            viewModel.reviewModel?.result.list[index.row].reviewData.replyData.reply = updatedReply
            if let model = viewModel.reviewModel?.result.list[index.row] {
                delegate?.getEditReply(reviewId: viewModel.reviewModel?.result.list[index.row].reviewData.reviewId ?? "", model: model)
            }
            self.tableViewOutlet.reloadData()
        }
    }
    
    
    func didEditReview(updatedReview: String, rating: Double) {
        if let index = currentIndexPath {
            viewModel.reviewModel?.result.list[index.row].reviewData.review = updatedReview
            viewModel.reviewModel?.result.list[index.row].reviewData.rating = rating
            delegate?.getEditReview(id: viewModel.reviewModel?.result.list[index.row].reviewData.reviewId ?? "", editReview: updatedReview, rating: rating)
            self.tableViewOutlet.reloadData()
        }
    }
    
    func didEditedAnswer(updatedAnswer: String) {
        if let index = currentIndexPath {
            //     self.viewModel.questionmodel?.result.list[index.row].questionData?.answerData?.answer = updatedAnswer
            self.tableViewOutlet.reloadData()
        }
    }
    
    func didAnswerAdded(answer: AnswerData) {
        if let index = currentIndexPath {
            // Arsh      self.viewModel.questionmodel?.result.list[index.row].questionData?.answerData? = answer
            self.tableViewOutlet.reloadData()
        }
    }
}


extension QuestionListingBuilderVC : QuestionListingAnswerTblCellDelegate {
    func moreTapped(index:IndexPath) {
        let curentStatus = self.viewModel.questionmodel?.result.list[index.section].isShowAll ?? false
        self.viewModel.questionmodel?.result.list[index.section].isShowAll = !curentStatus
        self.tableViewOutlet.reloadData()
    }
    
    
    func editTapped(index: IndexPath) {
        self.screenType = .questionAnswer
        self.currentIndexPath = index
        self.goToAskQuestionVC(isEdit: true)
        
    }
    
    func deleteTapped(index: IndexPath) {
        self.currentIndexPath = index
        AppRouter.showAppAlertWithCompletion(vc: self, alertType: .bothButton, alertTitle: "Alert", alertMessage: "Are you sure you want to delete a answer?", acceptButtonTitle: "Yes", declineButtonTitle: "No") {
            self.viewModel.deleteAnswer(questionId: self.viewModel.questionmodel?.result.list[index.section]._id ?? "", answerId: self.viewModel.questionmodel?.result.list[index.section].answers[index.row]._id ?? "")
        } dismissCompletion: { }
    }
    
    func replyTapped(index: IndexPath) {
        self.screenType = .answereReply
        self.currentIndexPath = index
        if let data = self.viewModel.questionmodel?.result.list[index.section] {
            self.newbuilderId = data.builderId
            self.newtradieId = data.tradieId
        }
        self.goToAskQuestionVC()
    }
}



extension QuestionListingBuilderVC : QuestionListingHeaderTblCellDelegate {
    func anwereTapped(section: Int) {
        currentIndexPath = IndexPath(row: 0, section: section)
        if let data = self.viewModel.questionmodel?.result.list[section] {
            self.newbuilderId = data.builderId
            self.newtradieId = data.tradieId
        }
        self.goToAskQuestionVC(isEdit: false)
    }
    
    func showAll(section: Int) {
        let curentStatus = self.viewModel.questionmodel?.result.list[section].isShowAll ?? false
        self.viewModel.questionmodel?.result.list[section].isShowAll = !curentStatus
        self.tableViewOutlet.reloadData()
    }
    
    
}
