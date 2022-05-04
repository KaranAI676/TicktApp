//
//  CreatingJobPreviewVC.swift
//  Tickt
//
//  Created by S H U B H A M on 25/03/21.
//

import UIKit

class CreatingJobPreviewVC: BaseVC {
    
    enum CellTypes {
        case grid
        case photos
        case jobType
        case details
        case category
        case gridCell
        case applyJob
        case postedBy
        case question
        case viewQuotes
        case milestones
        case inviteAccept
        case bottomButton
        case changeRequest
        case cancelRequest
        case specialisation
    }
    
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var tableViewOutlet: UITableView!
    ///
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var editMilestoneButton: UIButton!
    
    lazy var refreshControl: UIRefreshControl = {
        $0.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return $0
    }(UIRefreshControl())
        
    var jobId = ""
    var tradeId = ""
    var specialisationId = ""
    var isJobRepublishing = false
    var changeRequestClosure: (()->())?
    var inviteAcceptDeclineClosure: (() -> ())?
    ///
    var model = CreateJobModel()
    var jobDetail: JobDetailsModel?
    var viewModel = CreatingJobPreviewVM()
    var openJobModel: OpenJobModel? = nil
    var screenType: ScreenType = .jobPreview
    var isquoteJobEdit = false
    var cellsArray: [CellTypes] = [.category, .grid, .jobType, .specialisation, .details, .question, .milestones, .photos, .bottomButton]
                
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.popUpView.popOut()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.popUpView.popOut()
        if screenType == .jobPreview {
            if let object = kAppDelegate.postJobModel {
                model = object
            }
            mainQueue { [weak self] in
                self?.tableViewOutlet.reloadData()
            }
        }
    }
       
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case backButton:
            pop()
            disableButton(sender)
        case editButton:
            let _ = self.popUpView.alpha == 0 ? self.popUpView.popIn() : self.popUpView.popOut()
        case editMilestoneButton:
            CommonFunctions.showToastWithMessage("Edit Milestone")
        case cancelButton:
            CommonFunctions.showToastWithMessage("Cancel button")
        case bookmarkButton:
            viewModel.saveJob(status: jobDetail?.result?.isSaved ?? false, jobId: jobId, tradeId: tradeId, specializationId: specialisationId)
        default:
            break
        }
    }
    
    private func initialSetup() {
        self.viewModel.delegate = self
        switch self.screenType {
        case .jobPreview:
            if let object = kAppDelegate.postJobModel {
                model = object
                tableViewOutlet.delegate = self
                tableViewOutlet.dataSource = self
            }
        case .openJobs:
            self.editButton.isHidden = false
            cellsArray = [.category, .grid, .jobType, .specialisation, .details, .question, .milestones, .postedBy]            
            self.viewModel.getOpenJobDetails(jobId: jobId, tradieId: tradeId, specialisationId: specialisationId)
            tableViewOutlet.delegate = self
            tableViewOutlet.dataSource = self
        default:
            if screenType == .activeJobDetail {
                cellsArray = [.category, .gridCell, .jobType, .specialisation, .details, .question, .milestones, .photos, .postedBy]
            } else {
                cellsArray = [.category, .gridCell, .jobType, .specialisation, .details, .question, .milestones, .photos, .postedBy, .applyJob]
            }            
            viewModel.getJobDetails(jobId: jobId,  tradeId: tradeId, specializationId: specialisationId, screenType: screenType)
            tableViewOutlet.addSubview(refreshControl)
        }
        popUpView.alpha = 0
        setupTableView()
    }
    
    private func setupTableView() {
        tableViewOutlet.contentInset.bottom = 20                     
        
        tableViewOutlet.registerCell(with: GridCell.self)
        tableViewOutlet.registerCell(with: ButtonCell.self)
        tableViewOutlet.registerCell(with: ApplyJobCell.self)
        tableViewOutlet.registerCell(with: PostedByCell.self)
        tableViewOutlet.registerCell(with: ChangeRequestCell.self)
        tableViewOutlet.registerCell(with: GridInfoTableCell.self)
        tableViewOutlet.registerCell(with: TitleLabelTableCell.self)
        tableViewOutlet.registerCell(with: BottomButtonTableCell.self)
        tableViewOutlet.registerCell(with: BottomButtonsTableCell.self)
        tableViewOutlet.registerCell(with: QuestionButtonTableCell.self)
        tableViewOutlet.registerCell(with: DetailsWithTitleTableCell.self)
        tableViewOutlet.registerCell(with: MilestoneListingTableCell.self)
        tableViewOutlet.registerCell(with: TradeWithDescriptionTableCell.self)
        tableViewOutlet.registerCell(with: DynamicHeightCollectionViewTableCell.self)
        tableViewOutlet.registerCell(with: CommonCollectionViewWithTitleTableCell.self)
        tableViewOutlet.reloadData()
    }
    
    @objc func refreshData() {
        if screenType == .jobDetail || screenType == .activeJobDetail {
            viewModel.getJobDetails(jobId: jobId, tradeId: tradeId, specializationId: specialisationId, screenType: screenType)
        }
    }
}
