//
//  TemplatesListingVC.swift
//  Tickt
//
//  Created by S H U B H A M on 02/04/21.
//

protocol TemplatesListingVCDelegate {
    func getMilestones(milestonesArray: [MilestonesModel])
}

class TemplatesListingVC: BaseVC {

    //MARK:- IB Outlets
    /// Nav Bar
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    ///
    @IBOutlet weak var placeHolderImage: UIImageView!
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    //MARK:- Variables
    var delegate: TemplatesListingVCDelegate? = nil
    var viewModel = TemplatesListingVM()
    var screenType: ScreenType = .editTemplates
    var currentIndex: IndexPath? = nil
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
        viewModel.delegate = self
        viewModel.tableViewOutlet = tableViewOutlet
        self.viewModel.getTemplatesList()
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

extension TemplatesListingVC {
    
    private func initialSetup() {
        self.setupTableView()
    }
    
    private func setupTableView() {
        self.tableViewOutlet.registerCell(with: TemplateListingTableCell.self)
        self.tableViewOutlet.delegate = self
        self.tableViewOutlet.dataSource = self
        self.tableViewOutlet.refreshControl = refresher
    }
    
    private func setPlaceholder() {
        self.placeHolderImage.isHidden = ((self.viewModel.model?.result.count ?? 0) > 0)
        self.tableViewOutlet.isHidden = !self.placeHolderImage.isHidden
    }
    
    private func goToMilestoneListingVC(model: MilestoneListModel) {
        let vc = MilestoneListingVC.instantiate(fromAppStoryboard: .jobPosting)
        vc.screenType = .editTemplates
        vc.templateId = model.result.tempId
        vc.templateName = model.result.templateName
        vc.milestonesArray = model.result.milestones.map({ eachModel -> MilestoneModel in
            return MilestoneModel(eachModel)
        })
        vc.constantMilestoneArray = vc.milestonesArray
        vc.delegate = self
        push(vc: vc)
    }
    
    func deleteTemplate(indexPath: IndexPath, tableView: UITableView, completion: @escaping (Bool)-> Void) {
        
        AppRouter.showAppAlertWithCompletion(vc: self, alertMessage: "Are you sure, want to delete the template?", acceptButtonTitle: "Delete", declineButtonTitle: "Cancel", completion: {
            if let templateId = self.viewModel.model?.result[indexPath.row].templateId {
                self.viewModel.deleteTemplate(templateId: templateId, indexPath: indexPath)
            }
            completion(true)
        }, dismissCompletion: {
            completion(false)
        })
    }
}

extension TemplatesListingVC: TableDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        setPlaceholder()
        return self.viewModel.model?.result.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewOutlet.dequeueCell(with: TemplateListingTableCell.self)
        viewModel.hitPagination(index: indexPath.row)
        if let model = self.viewModel.model?.result {
            cell.populateUI(name: model[indexPath.row].templateName, count: "\(model[indexPath.row].milestoneCount)")
            return cell
        }else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentIndex = indexPath
        self.viewModel.getMilestonesList(templateId: self.viewModel.model?.result[indexPath.row].templateId ?? "")
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
        -> UISwipeActionsConfiguration? {
            ///
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            self.deleteTemplate(indexPath: indexPath, tableView: tableView, completion: { bool in
                completionHandler(bool)
            })
        }
        ///
        let image = #imageLiteral(resourceName: "delete")
        let size = CGSize(width: image.size.width, height: image.size.height + 16)
        deleteAction.image = UIGraphicsImageRenderer(size: size).image { context in
        var centralizedRect = CGRect(origin: .zero, size: image.size)
            centralizedRect.origin.y = centralizedRect.origin.y + 16
            image.draw(in: centralizedRect)
        }
        deleteAction.backgroundColor = .white
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}

//MARK:- Selector Methods
extension TemplatesListingVC {
    
    @objc func pullToRefresh() {
        self.viewModel.getTemplatesList(showLoader: false, isPullToRefresh: true)
    }
}

//MARK:- TemplatesListingVM: Delegate
extension TemplatesListingVC: TemplatesListingVMDelegate {
    
    func deleteSuccess(indexPath: IndexPath) {
        self.viewModel.model?.result.remove(at: indexPath.row)
        tableViewOutlet.deleteRows(at: [indexPath], with: .fade)
    }
    
    func success(data: MilestoneListModel) {
        switch screenType {
        case .creatingJob:
            self.delegate?.getMilestones(milestonesArray: data.result.milestones)
            self.pop()
        case .editTemplates:
            goToMilestoneListingVC(model: data)
        default:
            break
        }
    }
    
    func successDidGetTemplate() {
        self.tableViewOutlet.reloadData()
        self.refresher.endRefreshing()
    }
    
    func failure(error: String) {
        CommonFunctions.showToastWithMessage(error)
        self.refresher.endRefreshing()
    }
}

extension TemplatesListingVC: MilestoneListingVCDelegate {
    
    func updatedTemplates(milestoneCount: Int) {
        if let index = currentIndex {
            self.viewModel.model?.result[index.row].milestoneCount = milestoneCount
            self.tableViewOutlet.reloadData()
        }
    }
}

//        self.showAlert(title: "Alert", msg: "Are you sure, want to delete the template?", cancelTitle: "Cancel", actionTitle: "Delete", actioncompletion: {
//            if let templateId = self.viewModel.model?.result[indexPath.row].templateId {
//                self.viewModel.deleteTemplate(templateId: templateId, indexPath: indexPath)
//            }
//            completion(true)
//        }, cancelcompletion: {
//            completion(false)
//        })
