//
//  CreatingJobPreviewVC.swift
//  Tickt
//
//  Created by S H U B H A M on 25/03/21.
//

import UIKit

class CreatingJobPreviewVC: BaseVC {
    
    enum CellTypes {
        case category
        case grid
        case jobType
        case specialisation
        case details
        case question
        case milestones
        case photos
        case bottomButton
    }
    
    //MARK:- IB Outlets
    /// Nav Bar
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    ///
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    //MARK:- Variables
    var model = CreateJobModel()
    var viewModel = CreatingJobPreviewVM()
    var cellsArray: [CellTypes] = [.category, .grid, .jobType, .specialisation, .details, .question, .milestones, .photos, .bottomButton]
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let model = CreateJobVC.postJobModel {
            self.model = model
        }
        self.tableViewOutlet.reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.darkContent
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        self.pop()
        disableButton(sender)
    }
}

//MARK:- Private Methods
//======================
extension CreatingJobPreviewVC {
    
    private func initialSetup() {
        if let model = CreateJobVC.postJobModel {
            self.model = model
        }
        self.setupTableView()
        viewModel.delegate = self
    }
    
    private func setupTableView() {
        ///
        self.tableViewOutlet.delegate = self
        self.tableViewOutlet.dataSource = self
        ///
        self.tableViewOutlet.registerCell(with: GridInfoTableCell.self)
        self.tableViewOutlet.registerCell(with: BottomButtonTableCell.self)
        self.tableViewOutlet.registerCell(with: QuestionButtonTableCell.self)
        self.tableViewOutlet.registerCell(with: DetailsWithTitleTableCell.self)
        self.tableViewOutlet.registerCell(with: TitleLabelTableCell.self)
        self.tableViewOutlet.registerCell(with: TradeWithDescriptionTableCell.self)
        self.tableViewOutlet.registerCell(with: MilestoneListingTableCell.self)
        self.tableViewOutlet.registerCell(with: CommonCollectionViewWithTitleTableCell.self)
        self.tableViewOutlet.registerCell(with: DynamicHeightCollectionViewTableCell.self)
    }
    
    private func goToSuccessScreen() {
        let vc = AccountCreatedSuccessVC.instantiate(fromAppStoryboard: .registration)
        vc.screenType = .jobPosted
        self.push(vc: vc)
    }
    
    private func goToCreateJobVC() {
        let vc = CreateJobVC.instantiate(fromAppStoryboard: .jobPosting)
        vc.screenType = .edit
        self.push(vc: vc)
    }
    
    private func goToJobDetailsVC() {
        let vc = JobDescriptionVC.instantiate(fromAppStoryboard: .jobPosting)
        vc.screenType = .edit
        self.push(vc: vc)
    }
    
    private func goToMilestoneListingVC() {
        let vc = MilestoneListingVC.instantiate(fromAppStoryboard: .jobPosting)
        vc.screenType = .edit
        self.push(vc: vc)
    }
    
    private func goToAddMediaVC() {
        let vc = CreateJobUploadMediaVC.instantiate(fromAppStoryboard: .jobPosting)
        vc.screenType = .edit
        self.push(vc: vc)
    }
}

//MARK:- TableDelegate
//====================
extension CreatingJobPreviewVC: TableDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellsArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch cellsArray[section] {
        case .category, .grid, .jobType, .specialisation, .details, .question, .photos, .bottomButton:
            return 1
        case .milestones:
            return self.model.milestones.count + 1 /// One extra for title
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch cellsArray[indexPath.section] {
        case .category:
            let cell = tableView.dequeueCell(with: TradeWithDescriptionTableCell.self)
            ///
            cell.populateUI(title: self.model.categories?.tradeName ?? "NA", description: self.model.jobName, image: self.model.categories?.selectedUrl ?? "")
            ///
            cell.editButtonClosure = { [weak self] in
                guard let self = self else { return }
                self.goToCreateJobVC()
            }
            return cell
        case .grid:
            let cell = tableViewOutlet.dequeueCell(with: GridInfoTableCell.self)
            let first = "\((self.model.fromDate.date ?? Date()).daysFrom(Date())) days"
            let second = "\(self.model.paymentAmount) \(self.model.paymentType.tag)"
            let third = self.model.jobLocation.locationName
            cell.populateUI(text: [first, second, third])
            return cell
        case .jobType:
            let cell = tableView.dequeueCell(with: DynamicHeightCollectionViewTableCell.self)
            /// Populate UI
            cell.titleLabel.textColor = AppColors.themeBlue
            cell.stackView.spacing = 0
            cell.isSelectionEnable = false
            cell.titleLabelFont = UIFont.kAppDefaultFontBold(ofSize: 16)
            cell.extraCellSize = CGSize(width: (36 + 6 + 12 + 15), height: 26)
            cell.cellFont = UIFont.kAppDefaultFontMedium(ofSize: 12.0)
            cell.populateUI(title: "Job types", dataArray: self.model.jobType, cellType: .jobType)
            cell.editBackView.isHidden = false
            ///
            cell.editButtonClosure = { [weak self] in
                guard let self = self else { return }
                self.goToCreateJobVC()
            }
            cell.layoutIfNeeded()
            return cell
        case .specialisation:
            let cell = tableView.dequeueCell(with: DynamicHeightCollectionViewTableCell.self)
            /// Populate UI
            cell.topConstraint.constant = 36
            cell.isSelectionEnable = false
            cell.titleLabel.textColor = AppColors.themeBlue
             
            cell.titleLabelFont = UIFont.kAppDefaultFontBold(ofSize: 16)
            cell.extraCellSize = CGSize(width: 25, height: 25)
            cell.cellFont = UIFont.kAppDefaultFontMedium(ofSize: 12.0)
            cell.editBackView.isHidden = false
            if let model = self.model.specialisation {
                cell.populateUI(title: "Specialisations needed", dataArray: model, cellType: .specialisation)
            }
            ///
            cell.editButtonClosure = { [weak self] in
                guard let self = self else { return }
                self.goToCreateJobVC()
            }
            cell.layoutIfNeeded()
            return cell
        case .details:
            let cell = tableViewOutlet.dequeueCell(with: DetailsWithTitleTableCell.self)
            cell.edeitBackView.isHidden = false
            cell.populateUI(title: "Details", desc: self.model.jobDescription)
            ///
            cell.editButtonClosure = { [weak self] in
                guard let self = self else { return }
                self.goToJobDetailsVC()
            }
            return cell
        case .question:
            let cell = tableViewOutlet.dequeueCell(with: QuestionButtonTableCell.self)
            ///
            cell.actionButtonClosure = { [weak self] in
                guard let _ = self else { return }
            }
            return cell
        case .milestones:
            if indexPath.row == 0 {
                let cell = tableView.dequeueCell(with: TitleLabelTableCell.self)
                cell.editBackView.isHidden = false
                cell.titleLabel.text = "Job milestones"
                ///
                cell.editButtonClosure = { [weak self] in
                    guard let self = self else { return }
                    self.goToMilestoneListingVC()
                }
                return cell
            }else {
                let cell = tableView.dequeueCell(with: MilestoneListingTableCell.self)
                cell.countLabel.text = "\(indexPath.row)."
                cell.milestoneNameLabel.text = self.model.milestones[indexPath.row-1].milestoneName
                cell.milestoneDatesLabel.text = self.model.milestones[indexPath.row-1].displayDateFormat
                return cell
            }
        case .photos:
            let cell = tableViewOutlet.dequeueCell(with: CommonCollectionViewWithTitleTableCell.self)
            cell.editBackView.isHidden = false
            cell.titleLabel.font = UIFont.kAppDefaultFontBold(ofSize: 16)
            cell.editButtonClosure = { [weak self] in
                guard let self = self else { return }
                self.goToAddMediaVC()
            }
            let imagesArray = self.model.mediaImages.map({ eachModel -> (UIImage, MediaTypes) in
                return (eachModel.0, eachModel.1)
            })
            cell.populateUI(title: "Photos", dataArray: imagesArray)
            return cell
        case .bottomButton:
            let cell = tableViewOutlet.dequeueCell(with: BottomButtonTableCell.self)
            cell.setTitle(title: "Post  job")
            ///
            cell.actionButtonClosure = { [weak self] in
                guard let self = self else { return }
                self.viewModel.postJobApi()
            }
            return cell
        }
    }
}

//MARK:- CreatingJobPreviewVMDelegate
extension CreatingJobPreviewVC: CreatingJobPreviewVMDelegate {
    
    func success() {
        CreateJobVC.postJobModel = nil
        CreateJobVC.jobTypeGlobalModel = JobTypeModel()
        CreateJobVC.tradeGlobalModel = nil
        goToSuccessScreen()
    }
    
    func failure(error: String) {
        CommonFunctions.showToastWithMessage(error)
    }
}
