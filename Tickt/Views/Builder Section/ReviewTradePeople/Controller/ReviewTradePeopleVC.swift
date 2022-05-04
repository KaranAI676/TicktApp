//
//  ReviewTradePeopleVC.swift
//  Tickt
//
//  Created by S H U B H A M on 26/05/21.
//

import UIKit

protocol ReviewTradePeopleVCDelegate: AnyObject {
    func getRatedJob(id: String)
}

class ReviewTradePeopleVC: BaseVC {

    enum SectionTypes {
        case job
        case tradie
        case rating
        case comment
        ///
        var title: String {
            switch self {
            case .job:
                return "Job"
            case .tradie:
                return "Tradie"
            case .comment:
                return "Comment(optional)"
            case .rating:
                return CommonStrings.emptyString
            }
        }
        var height: CGFloat {
            switch self {
            case .job, .tradie, .comment:
                return 30
            case .rating:
                return CGFloat.leastNonzeroMagnitude
            }
        }
        
        var font: UIFont {
            switch self {
            case .comment:
                return UIFont.systemFont(ofSize: 14)
            default:
                return UIFont.kAppDefaultFontBold(ofSize: 16)
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .comment:
                return #colorLiteral(red: 0.1921568627, green: 0.2392156863, blue: 0.2823529412, alpha: 1)
            default:
                return #colorLiteral(red: 0.0862745098, green: 0.1137254902, blue: 0.2901960784, alpha: 1)
            }
        }
    }

//MARK:- IB Outlets
    /// Nav Bar
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    ///
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    //MARK:- Variables
    var viewModel = ReviewTradePeopleVM()
    var ratingModel: ReviewTradePeopleModel?
    weak var delegate: ReviewTradePeopleVCDelegate? = nil
    var sectionArray: [SectionTypes] = [.job, .tradie, .rating, .comment]
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.darkContent
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case backButton:
            self.pop()
        case continueButton:
            if validate() {
                if let model = ratingModel {
                    viewModel.reviewTradie(model: model)
                }
            }
        default:
            break
        }
    }
}

extension ReviewTradePeopleVC {
    
    private func initialSetup() {
        viewModel.delegate = self
        setupTableView()
    }
    
    private func setupTableView() {
        self.tableViewOutlet.delegate = self
        self.tableViewOutlet.dataSource = self
        ///
        self.tableViewOutlet.registerHeaderFooter(with: TitleHeaderTableView.self)
        self.tableViewOutlet.registerCell(with: CommonTextfieldTableCell.self)
        self.tableViewOutlet.registerCell(with: TradieInfoTableCell.self)
        self.tableViewOutlet.registerCell(with: JobDetailsTableCell.self)
        self.tableViewOutlet.registerCell(with: RatingTableCell.self)
    }
    
    private func goToSuccessVC() {
        let vc = AccountCreatedSuccessVC.instantiate(fromAppStoryboard: .registration)
        vc.screenType = .reviewPosted
        self.push(vc: vc)
    }
    
    private func goToDetailScreen() {
        let vc = CommonJobDetailsVC.instantiate(fromAppStoryboard: .commonJobDetails)
        vc.screenType = .pastJobsCompleted
        if let jobId = self.ratingModel?.jobData.jobId {
            vc.jobId = jobId
            self.push(vc: vc)
        }
    }
    
    private func goToTradieProfileVC() {
        let vc = TradieProfilefromBuilderVC.instantiate(fromAppStoryboard: .tradieProfilefromBuilder)
        if let jobId = self.ratingModel?.jobData.jobId, let tradieId = self.ratingModel?.tradieData.tradieId {
            vc.jobId = jobId
            vc.jobName = ratingModel?.jobData.jobName ?? ""
            vc.tradieId = tradieId
            self.push(vc: vc)
        }
    }
}

extension ReviewTradePeopleVC: TableDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sectionArray[indexPath.section] {
        case .job:
            let cell = tableView.dequeueCell(with: JobDetailsTableCell.self)
            cell.jobDetailModel = self.ratingModel?.jobData
            cell.buttonClosure = { [weak self] in
                guard let self = self else { return }
                self.goToDetailScreen()
            }
            return cell
        case .tradie:
            let cell = tableView.dequeueCell(with: TradieInfoTableCell.self)
            cell.tradieModel = ratingModel?.tradieData
            cell.buttonClosure = { [weak self] in
                guard let self = self else { return }
                self.goToTradieProfileVC()
            }
            return cell
        case .rating:
            let cell = tableView.dequeueCell(with: RatingTableCell.self)
            cell.updateRatingClosure = { [weak self] rating in
                guard let self = self else { return }
                self.ratingModel?.rating = rating
            }
            return cell
        case .comment:
            let cell = tableView.dequeueCell(with: CommonTextfieldTableCell.self)
            cell.commonTextFiled.placeholder = "Thanks..."
            cell.topConstraint.constant = 2
            cell.updateTextClosure = { [weak self] (text) in
                guard let self = self else { return }
                self.ratingModel?.review = text
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueHeaderFooter(with: TitleHeaderTableView.self)
        header.headerLabel.font = sectionArray[section].font
        header.headerLabel.textColor = sectionArray[section].textColor
        header.headerLabel.text = sectionArray[section].title
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionArray[section].height
    }
}

extension ReviewTradePeopleVC {
    
    private func validate() -> Bool {
        
        if !((ratingModel?.rating ?? 0.0) > 0) {
            CommonFunctions.showToastWithMessage("Please select the rating")
            return false
        }
        
        return true
    }
}

//MARK:- ReviewTradePeopleVM: Delegate
//====================================
extension ReviewTradePeopleVC: ReviewTradePeopleVMDelegate {
    
    func success(id: String) {
        delegate?.getRatedJob(id: id)
        goToSuccessVC()
    }
    
    func failure(message: String) {
        CommonFunctions.showToastWithMessage(message)
    }
}
