//
//  EditableOptionBuilderVC.swift
//  Tickt
//
//  Created by S H U B H A M on 28/06/21.
//

import UIKit

class EditableOptionBuilderVC: BaseVC {
    
    enum SectionArray: String {
        case topSection
        case about = "About Company"
        case aboutTradie = "About"
        case portfolio = "Portfolio"
        case addAboutButton
        case addAboutTradie
        case addPortfolio
        case specialization = "Area of specialisation"
        
        var height: CGFloat {
            switch self {
            case .about, .portfolio, .specialization, .aboutTradie, .addAboutTradie, .addPortfolio, .addAboutButton:
                return 30
            default:
                return CGFloat.leastNonzeroMagnitude
            }
        }
    }
    
    //MARK:- IB Outlets
    /// Nav Bar
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    ///
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var bottomButton: UIButton!
    
    //MARK:- Variables
    var photosArray: [(String?, UIImage?)] = []
    var sectionArray: [SectionArray] = []
    var viewModel = EditableOptionBuilderVM()
    var loggedInBuilderModel: BuilderProfileModel? = nil
    var tradieModel: TradieProfilefromBuilderModel?
    var currentIndexPortfolio: Int? = nil
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()        
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case backButton:
            pop()
            disableButton(sender)
        case bottomButton:
            if kUserDefaults.isTradie() {
                if let model = tradieModel?.result {
                    viewModel.editTradieProfile(model: model)
                }
            } else {
                if let model = loggedInBuilderModel?.result {
                    viewModel.editProfile(model: model)
                }
            }
        default:
            break
        }
    }
}

extension EditableOptionBuilderVC {
    
    private func initialSetup() {
        viewModel.delegate = self
        if kUserDefaults.isTradie() {
            viewModel.getTradieProfile()
        } else {
            photosArray = loggedInBuilderModel?.result.portfolio.map({ eachModel -> (String?, UIImage?) in
                return (eachModel.portfolioImage?.first ?? "", nil)
            }) ?? []
        }
        setupTableView()
    }
    
    private func setupTableView() {
        tableViewOutlet.registerHeaderFooter(with: TitleHeaderTableView.self)
        tableViewOutlet.registerCell(with: DescriptionTableCell.self)
        tableViewOutlet.registerCell(with: TradieProfileInfoTableCell.self)
        tableViewOutlet.registerCell(with: BottomButtonsTableCell.self)
        tableViewOutlet.registerCell(with: CommonCollectionViewTableCell.self)
        
        ///
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
        tableViewOutlet.layoutIfNeeded()
    }
    
    private func getSectionArray() -> [SectionArray] {
        guard let model = loggedInBuilderModel?.result else { return [] }
        ///
        var sectionArray: [SectionArray] = [.topSection]
        
        if !(model.aboutCompany ?? "").isEmpty {
            sectionArray.append(.about)
        } else {
            sectionArray.append(.addAboutButton)
        }
        
        if !model.portfolio.isEmpty {
            sectionArray.append(.portfolio)
        } else {
            sectionArray.append(.addPortfolio)
        }
        
        self.sectionArray = sectionArray
        return sectionArray
    }
    
    private func getSectionArrayForTradie() -> [SectionArray] {
        guard let model = tradieModel?.result else { return [] }
        ///
        var sectionArray: [SectionArray] = [.topSection]
        
        if !(model.about).isEmpty {
            sectionArray.append(.aboutTradie)
        } else {
            sectionArray.append(.addAboutTradie)
        }
        
        if !model.portfolio.isEmpty {
            sectionArray.append(.portfolio)
        } else {
            sectionArray.append(.addPortfolio)
        }
        
        if !model.areasOfSpecialization.specializationData.isEmpty {
            sectionArray.append(.specialization)
        }

        
        self.sectionArray = sectionArray
        return sectionArray
    }
    
    func goToPortFolioDetailVC(index: IndexPath) {
        let vc = PortfolioDetailsBuilderVC.instantiate(fromAppStoryboard: .portfolioDetailsBuilder)
        vc.isEdit = true
        vc.delegate = self
        if kUserDefaults.isTradie() {
            vc.model = tradieModel?.result.portfolio[index.row]
        } else {
            vc.loggedInBuilderPortfolio = loggedInBuilderModel?.result.portfolio[index.row]
        }
        
        push(vc: vc)
    }
    
    func gotoAddPortfolioVC(_ index: Int? = nil) {
        let vc = AddPortfolioBuilderVC.instantiate(fromAppStoryboard: .loggedInUserProfileBuilder)
        var model = AddPortfolioBuilderModel()
        if let index = index {
            if kUserDefaults.isTradie() {
                model.id = tradieModel?.result.portfolio[index].portfolioId ?? ""
                model.jobName = tradieModel?.result.portfolio[index].jobName ?? ""
                model.jobDescription = tradieModel?.result.portfolio[index].jobDescription ?? ""
                model.images = tradieModel?.result.portfolio[index].portfolioImage.map({ eachModel -> (String?, UIImage?) in
                    return (eachModel, nil)
                }) ?? []
            } else {
                model.id = loggedInBuilderModel?.result.portfolio[index].portfolioId ?? ""
                model.jobName = loggedInBuilderModel?.result.portfolio[index].jobName ?? ""
                model.jobDescription = loggedInBuilderModel?.result.portfolio[index].jobDescription ?? ""
                model.images = loggedInBuilderModel?.result.portfolio[index].portfolioImage?.map({ eachModel -> (String?, UIImage?) in
                    return (eachModel, nil)
                }) ?? []
            }
        }
        vc.model = model
        vc.delegate = self
        push(vc: vc)
    }
    
    func gotoAddAboutVC() {
        let vc = AddAboutBuilderVC.instantiate(fromAppStoryboard: .loggedInUserProfileBuilder)
        vc.delegate = self
        vc.about = kUserDefaults.isTradie() ? tradieModel?.result.about : loggedInBuilderModel?.result.aboutCompany
        push(vc: vc)
    }
    
    func goToEditDetailsVC() {
        let vc = EditProfileDetailsBuilderVC.instantiate(fromAppStoryboard: .loggedInUserProfileBuilder)
        push(vc: vc)
    }
    
    func goToCommonPopupVC() {
        let vc = CommonButtonPopUpVC.instantiate(fromAppStoryboard: .registration)
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        vc.isAnimated = true
        vc.buttonTypeArray = [.photo, .gallery]
        mainQueue { [weak self] in
            self?.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func editButtonAction(_ sender: UIButton) {
        switch sectionArray[sender.tag] {
        case .aboutTradie, .about:
            gotoAddAboutVC()
        case .specialization:
            viewModel.getTradeList()
        default:
            break
        }
    }
}

extension EditableOptionBuilderVC: TableDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if kUserDefaults.isTradie() {
            return getSectionArrayForTradie().count
        } else {
            return getSectionArray().count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sectionArray[indexPath.section] {
        case .topSection:
            let cell = tableView.dequeueCell(with: TradieProfileInfoTableCell.self)
            cell.rightConstraint.constant = 21
            cell.editButton.isHidden = false
            cell.editProfileButton.isHidden = false
            cell.messageButton.isHidden = true
            kUserDefaults.isTradie() ? (cell.model = tradieModel?.result) : (cell.loggedInModel = loggedInBuilderModel?.result)
            cell.editButtonClosure = { [weak self] in
                guard let self = self else { return }
                self.goToEditDetailsVC()
            }
            cell.editProfileClosure = { [weak self] in
                guard let self = self else { return }
                self.goToCommonPopupVC()
            }
            return cell
        case .about, .aboutTradie:
            let cell = tableView.dequeueCell(with: DescriptionTableCell.self)
            kUserDefaults.isTradie() ? (cell.descriptionText = tradieModel?.result.about ?? "") : (cell.descriptionText = loggedInBuilderModel?.result.aboutCompany ?? "")
            return cell
        case .portfolio:
            let cell = tableView.dequeueCell(with: CommonCollectionViewTableCell.self)
            cell.portfolioImageUrlWithAddMore = self.photosArray
            cell.maxMediaCanAllow = 6
            cell.showPencilIcon = true
            cell.layoutIfNeeded()
            cell.imageTapped = { [weak self] (type, index) in
                guard let self = self else { return }
                switch type {
                case .uploadImage:
                    self.currentIndexPortfolio = nil
                    self.gotoAddPortfolioVC()
                case .imageTapped:
                    self.currentIndexPortfolio = index.row
                    self.goToPortFolioDetailVC(index: index)
                default:
                    break
                }
            }
            return cell
        case .addAboutButton, .addAboutTradie:
            let cell = tableView.dequeueCell(with: BottomButtonsTableCell.self)
            cell.firstButton.isHidden = true
            cell.topConstraint.constant = 5
            cell.secondButton.setTitleForAllMode(title: "Add about you bio")
            cell.buttonClosure = { [weak self] (type) in
                guard let self = self else { return }
                if type == .secondButton {
                    self.gotoAddAboutVC()
                }
            }
            return cell
        case .addPortfolio:
            let cell = tableView.dequeueCell(with: BottomButtonsTableCell.self)
            cell.firstButton.isHidden = true
            cell.topConstraint.constant = 5
            cell.secondButton.setTitleForAllMode(title: "Add portfolio")
            cell.buttonClosure = { [weak self] (type) in
                guard let self = self else { return }
                if type == .secondButton {
                    self.currentIndexPortfolio = nil
                    self.gotoAddPortfolioVC()
                }
            }
            return cell
        case .specialization:
            let cell = tableView.dequeueCell(with: CommonCollectionViewTableCell.self)
            cell.model = tradieModel?.result
            cell.layoutIfNeeded()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueHeaderFooter(with: TitleHeaderTableView.self)
        header.headerLabel.font = UIFont.kAppDefaultFontBold(ofSize: 16)
        header.headerLabel.text = sectionArray[section].rawValue
        header.editButton.isHidden = true
        header.editButton.tag = section
        header.editButton.addTarget(self, action: #selector(editButtonAction(_:)), for: .touchUpInside)
        switch sectionArray[section] {
        case .aboutTradie:
            header.editButton.isHidden = false
            header.headerLabel.text = "About"
        case .addAboutTradie:
            header.headerLabel.text = "About"
        case .addAboutButton:
            header.headerLabel.text = "About Company"
        case .addPortfolio:
            header.headerLabel.text = "Portfolio"
        case .specialization:
            header.editButton.isHidden = false
        case .about:
            header.editButton.isHidden = false
        case .portfolio:
            header.headerLabel.text = "Portfolio  (\(photosArray.count) Jobs)"
        default:
            header.headerLabel.text = sectionArray[section].rawValue
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionArray[section].height
    }
}
