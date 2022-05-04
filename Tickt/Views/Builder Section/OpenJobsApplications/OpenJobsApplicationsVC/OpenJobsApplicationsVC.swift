//
//  OpenJobsApplicationsVC.swift
//  Tickt
//
//  Created by S H U B H A M on 20/05/21.
//

import UIKit
import SDWebImage

struct BasicJobModel {
    
    var tradeName: String
    var jobName: String
    var tradeImage: String
    var jobFromDate: String
    var jobToDate: String?
    var jobId: String
    var quoteJob = false
    var quoteCount:Int
    
    init() {
        self.tradeName = ""
        self.jobName = ""
        self.jobFromDate = ""
        self.jobToDate = ""
        self.tradeImage = ""
        self.jobId = ""
        self.quoteJob = false
        self.quoteCount = 0
    }
}

protocol OpenJobsApplicationsVCDelegate: AnyObject {
    func removedEmptyJob(jobId: String, status: AcceptDecline)
}

class OpenJobsApplicationsVC: BaseVC {
    
    //MARK:- IB Outlets
    /// Nav Bar
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    ///
    @IBOutlet weak var placeHolderImage: UIImageView!
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var tableViewOutlet: UITableView!
    ///
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var tradeIconImageView: UIImageView!
    @IBOutlet weak var tradeNameLabel: UILabel!
    @IBOutlet weak var jobNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var forwardButton: UIButton!
    ///
    @IBOutlet weak var sortingView: UIView!
    @IBOutlet weak var sortingLabelName: UITextField!
    @IBOutlet weak var dropIconImageView: UIImageView!
    @IBOutlet weak var sortingButton: UIButton!
    ///
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var highestRatedButton: UIButton!
    @IBOutlet weak var closestToMeButton: UIButton!
    @IBOutlet weak var mostJobCompletedButton: UIButton!
    
    var isQuoteJob = false
    
    //MARK:- Variables
    var jobModel = BasicJobModel() {
        didSet {
            self.jobId = jobModel.jobId
        }
    }
    var sortType: SortingType = .highestRated {
        didSet {
            self.sortingLabelName.text = self.sortType.rawValue
        }
    }
    private var jobId: String = ""
    weak var delegate: OpenJobsApplicationsVCDelegate? = nil
    var currentCardSelectedIndex = 0
    var viewModel = OpenJobApplicationVM()
    var model: OpenJobApplicationModel? {
        didSet {
            self.tableViewOutlet.reloadData {
                self.tableViewOutlet.reloadData()
            }
        }
    }
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.darkContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupJobView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.closeDropDownList()
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case backButton:
//            if self.model?.result.isEmpty ?? true {
//                delegate?.removedEmptyJob(jobId: self.jobId)
//            }
            self.pop()
        case forwardButton:
            self.goToDetailVC()
        case sortingButton:
            self.dropIconImageView.transform = self.dropIconImageView.transform.rotated(by: CGFloat(Double.pi))
            let _ = self.popupView.alpha != 0 ? self.popupView.popOut() : self.popupView.popIn()
            self.popupView.alpha != 0 ? self.sortingView.makeRoundToCorner(cornerRadius: 6, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner]) : self.sortingView.makeRoundToCorner(cornerRadius: 6, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner])
        case highestRatedButton:
            self.popupView.popOut(completion: { [weak self] bool in
                guard let self = self else { return }
                self.sortType = .highestRated
                self.sortingView.makeRoundToCorner(cornerRadius: 6, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner])
                self.dropIconImageView.transform = self.dropIconImageView.transform.rotated(by: CGFloat(Double.pi))
                self.viewModel.getApplicationList(jobId: self.jobId, sortBy: self.sortType)
            })
        case closestToMeButton:
            self.popupView.popOut(completion: { [weak self] bool in
                guard let self = self else { return }
                self.sortType = .closestToMe
                self.sortingView.makeRoundToCorner(cornerRadius: 6, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner])
                self.dropIconImageView.transform = self.dropIconImageView.transform.rotated(by: CGFloat(Double.pi))
                self.viewModel.getApplicationList(jobId: self.jobId, sortBy: self.sortType)
            })
        case mostJobCompletedButton:
            self.popupView.popOut(completion: { [weak self] bool in
                guard let self = self else { return }
                self.sortType = .mostJobsCompleted
                self.sortingView.makeRoundToCorner(cornerRadius: 6, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner])
                self.dropIconImageView.transform = self.dropIconImageView.transform.rotated(by: CGFloat(Double.pi))
                self.viewModel.getApplicationList(jobId: self.jobId, sortBy: self.sortType)
            })
        default:
            break
        }
    }
}

extension OpenJobsApplicationsVC {
    
    private func initialSetup() {
        screenTitleLabel.text = !isQuoteJob ? "New applicants" : "Quotes"
        popupView.alpha = 0
        self.sortingView.makeRoundToCorner(cornerRadius: 6, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner])
        self.popupView.makeRoundToCorner(cornerRadius: 6, maskedCorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner])
        self.popupView.dropShadow(color: #colorLiteral(red: 0.7450980392, green: 0.7450980392, blue: 0.8078431373, alpha: 1), opacity: 0.5, offSet: CGSize(width: 10, height: 5), radius: 6, scale: true)
        setupTableView()
        viewModel.delegate = self
        viewModel.getApplicationList(jobId: self.jobModel.jobId, sortBy: self.sortType)
    }
    
    private func setupTableView() {
        self.tableViewOutlet.delegate = self
        self.tableViewOutlet.dataSource = self
        ///
        tableViewOutlet.registerCell(with: OpenJobApplicationTableCell.self)
    }
    
    private func setupJobView() {
        self.tradeNameLabel.text = jobModel.tradeName
        self.jobNameLabel.text = jobModel.jobName
        self.tradeIconImageView.sd_setImage(with: URL(string: self.jobModel.tradeImage), placeholderImage: nil)
        self.dateLabel.text = CommonFunctions.getFormattedDates(fromDate: jobModel.jobFromDate.convertToDateAllowsNil(), toDate: jobModel.jobToDate?.convertToDateAllowsNil())
    }
    
    private func closeDropDownList() {
        if self.popupView.alpha == 0 {
            return
        }
        self.popupView.popOut()
        self.sortingView.makeRoundToCorner(cornerRadius: 6, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner])
        self.dropIconImageView.transform = self.dropIconImageView.transform.rotated(by: CGFloat(Double.pi))
    }
    
    private func goToDetailVC() {
        let vc = CommonJobDetailsVC.instantiate(fromAppStoryboard: .commonJobDetails)
        vc.screenType = .openJobs
        vc.jobId = self.jobId
        self.push(vc: vc)
    }
    
    private func goToTradieProfileVC(jobId: String, tradieId: String, status: String) {
        let vc = TradieProfilefromBuilderVC.instantiate(fromAppStoryboard: .tradieProfilefromBuilder)
        vc.jobId = jobId
        vc.isOpenJob = true
        vc.tradieId = tradieId
        vc.jobName = jobModel.jobName
        vc.noOfTraidesCount = self.model?.result.count ?? 0
        let jobStatus = JobStatus(rawValue: status) ?? .cancelledJob
        vc.showSaveUnsaveButton = jobStatus != .cancelledJob
        vc.delegate = self
        self.push(vc: vc)
    }
}

extension OpenJobsApplicationsVC: TableDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model?.result.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: OpenJobApplicationTableCell.self)
        cell.tableView = tableView
        if let model = self.model?.result[indexPath.row] {
            cell.applicationModel = model
        }
        cell.buttonClosure = { [weak self] (index) in
            guard let self = self else { return }
            if let tradieId = self.model?.result[index.row].tradieId {
                self.currentCardSelectedIndex = indexPath.row
                self.goToTradieProfileVC(jobId: self.jobId, tradieId: tradieId, status: self.model?.result[index.row].status ?? "")
            }
        }
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.closeDropDownList()
    }
}

//MARK:- OpenJobApplicationVM: Delegate
//=====================================
extension OpenJobsApplicationsVC: OpenJobApplicationVMDelegate {
    
    func success(model: OpenJobApplicationModel) {
        self.model = model
    }
    
    func failure(message: String) {
        CommonFunctions.showToastWithMessage(message)
    }
}

extension OpenJobsApplicationsVC: TradieProfilefromBuilderDelegate {
    
    func getAcceptDeclineTradie(tradieId: String, status: AcceptDecline) {
        //Changed by Vijay
//        let index = self.model?.result.firstIndex(where: { eachModel -> Bool in
//            return eachModel.tradieId == tradieId
//        })
//        if let index = index {
//            self.model?.result.remove(at: index)
//            self.tableViewOutlet.reloadData()
//        }
        self.model?.result.remove(at: currentCardSelectedIndex)
        self.tableViewOutlet.reloadData()
        ///
        if self.model?.result.isEmpty ?? true {
            delegate?.removedEmptyJob(jobId: self.jobId, status: status)
            DispatchQueue.main.async {
                self.pop()
            }
        }
    }
}
