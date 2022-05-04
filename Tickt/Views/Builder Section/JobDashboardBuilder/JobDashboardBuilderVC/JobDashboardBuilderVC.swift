//
//  JobDashboardBuilderVC.swift
//  Tickt
//
//  Created by S H U B H A M on 05/05/21.
//

import UIKit

class JobDashboardBuilderVC: BaseVC {

    //MARK:- IB Outlets
    @IBOutlet weak var screenTitleLabel: UILabel!
    ///
    @IBOutlet weak var newApplicantView: UIView!
    @IBOutlet weak var newApplicantLabel: UILabel!
    @IBOutlet weak var newApplicantCountLabel: UILabel!
    @IBOutlet weak var newApplicantButton: UIButton!
    ///
    @IBOutlet weak var needApprovalView: UIView!
    @IBOutlet weak var newApplicantsCountBackView: UIView!
    @IBOutlet weak var newApprovalLabel: UILabel!
    @IBOutlet weak var needApprovalCountBackView: UIView!
    @IBOutlet weak var newApprovalCountLabel: UILabel!
    @IBOutlet weak var newApprovalButton: UIButton!
    ///
    @IBOutlet weak var activeButton: UIButton!
    @IBOutlet weak var openButton: UIButton!
    @IBOutlet weak var pastButton: UIButton!
    ///
    @IBOutlet weak var subViewContainerView: UIView!
    
    //MARK:- Variables
    private var newApplicantCount: Int = 0 {
        didSet {
            self.newApplicantsCountBackView.isHidden = newApplicantCount < 1
            self.newApplicantCountLabel.text = "\(newApplicantCount)"
            
        }
    }
    private var needApprovalCount: Int = 0 {
        didSet {
            self.needApprovalCountBackView.isHidden = needApprovalCount < 1
            self.newApprovalCountLabel.text = "\(needApprovalCount)"
        }
    }
    var buttonsArray = [UIButton]()
    var pageViewController: EMPageViewController?
    
    lazy private var activeJobVC: ActiveJobsVC = {
        let vc = ActiveJobsVC.instantiate(fromAppStoryboard: .jobDashboardBuilder)
        vc.view.backgroundColor = .clear
        return vc
    }()
    lazy private var openJobVC: OpenJobsVC = {
        let vc = OpenJobsVC.instantiate(fromAppStoryboard: .jobDashboardBuilder)
        vc.view.backgroundColor = .clear
        return vc
    }()
    lazy private var pastJobVC: PastJobsVC = {
        let vc = PastJobsVC.instantiate(fromAppStoryboard: .jobDashboardBuilder)
        vc.view.backgroundColor = .clear
        return vc
    }()
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        self.pageViewControllerSetUp()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let heightFromMainContainerView = self.subViewContainerView.bounds.height
        self.pageViewController?.view.frame.size = CGSize(width: kScreenWidth, height: heightFromMainContainerView)
        ///
        self.activeJobVC.view.frame.size = CGSize(width: UIDevice.width, height: heightFromMainContainerView)
        self.openJobVC
            .view.frame.size = CGSize(width: UIDevice.width, height: heightFromMainContainerView)
        self.pastJobVC.view.frame.size = CGSize(width: UIDevice.width, height: heightFromMainContainerView)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case newApplicantButton:
            self.goToNewApplicants(.newApplicatants)
        case newApprovalButton:
            self.goToNewApplicants(.needApproval)
        case activeButton:
            self.activeBtnAction(goToVC: true)
        case openButton:
            self.openBtnAction(goToVC: true)
        case pastButton:
            self.pastBtnAction(goToVC: true)
        default:
            break
        }
        self.disableButtons(sender: sender)
    }
}

extension JobDashboardBuilderVC {
    
    private func initialSetup() {
        self.subViewContainerView.backgroundColor = .clear
        self.setupView()
        self.buttonsArray = [self.activeButton, self.openButton, self.pastButton]
        self.updateDashBoardJobsCOunt()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTabs(_:)), name: NotificationName.refreshBuilderJobDashboard, object: nil)
    }
    
    private func setupView() {
        self.newApplicantLabel.text = "New applicants"
        self.newApprovalLabel.text = "Needs approval"
        self.newApplicantLabel.font = UIFont.kAppDefaultFontBold(ofSize: 15)
        self.newApprovalLabel.font = UIFont.kAppDefaultFontBold(ofSize: 15)
    }
    
    private func setupTheButtonsState(sender: UIButton) {
        let _ = self.buttonsArray.map({ eachButton in
            if eachButton === sender {
                eachButton.tintColor = .white
                eachButton.titleLabel?.font = UIFont.kAppDefaultFontMedium(ofSize: 18)
            }else {
                eachButton.tintColor = #colorLiteral(red: 0.8745098039, green: 0.8980392157, blue: 0.937254902, alpha: 0.5)
                eachButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            }
        })
    }
    
    private func goToNewApplicants(_ screenType: ScreenType) {
        let vc = NewApplicantsBuilderVC.instantiate(fromAppStoryboard: .newApplicantsBuilder)
        vc.screenType = screenType
        vc.delegate = self
        self.push(vc: vc)
    }
    
    private func updateDashBoardJobsCOunt() {
        self.openJobVC.updateNewApplicantRemovedJob = { [weak self] in
            guard let self = self else { return }
            self.newApplicantCount -= 1
        }
        self.openJobVC.updateDashBoardCount = { [weak self] (new, need) in
            guard let self = self else { return }
            self.newApplicantCount = new
            self.needApprovalCount = need
        }
        self.activeJobVC.updateDashBoardCount = { [weak self] (new, need) in
            guard let self = self else { return }
            self.newApplicantCount = new
            self.needApprovalCount = need
        }
        self.pastJobVC.updateDashBoardCount = { [weak self] (new, need) in
            guard let self = self else { return }
            self.newApplicantCount = new
            self.needApprovalCount = need
        }
    }
    
    private func pageViewControllerSetUp() {
        
        let pageViewController = EMPageViewController()
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        let currentViewController = self.activeJobVC
        pageViewController.selectViewController(currentViewController, direction: .forward, animated: false, completion: nil)
        
        // Add EMPageViewController to the root view controller
        let heightFromMainContainerView = self.subViewContainerView.bounds.height
        pageViewController.view.frame = CGRect(x: 0, y: 0, width: UIDevice.width, height: heightFromMainContainerView)
        pageViewController.willMove(toParent: self)
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        self.subViewContainerView.addSubview(pageViewController.view)
                
        self.pageViewController = pageViewController
        self.activeBtnAction()
    }
    
    private func activeBtnAction(goToVC: Bool = false) {
        self.setupTheButtonsState(sender: self.activeButton)
        if goToVC {
            if self.pageViewController?.selectedViewController === self.activeJobVC { return }
            self.pageViewController?.selectViewController(self.activeJobVC, direction: .reverse, animated: true, completion: nil)
        }
    }
    
    private func openBtnAction(goToVC: Bool = false) {
        self.setupTheButtonsState(sender: self.openButton)
        if goToVC {
            if self.pageViewController?.selectedViewController === self.openJobVC { return }
            self.pageViewController?.selectViewController(self.openJobVC, direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func pastBtnAction(goToVC: Bool = false) {
        self.setupTheButtonsState(sender: self.pastButton)
        if goToVC {
            if self.pageViewController?.selectedViewController === self.pastJobVC { return }
            self.pageViewController?.selectViewController(self.pastJobVC, direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func disableButtons(sender: UIButton) {
        sender.isUserInteractionEnabled = false
        CommonFunctions.delay(delay: 0.5, closure: {
            sender.isUserInteractionEnabled = true
        })
    }
    
    @objc func refreshTabs(_ notification: Notification) {
        if let userInfo = notification.userInfo, let status = userInfo["tab"] as? JobDashboardTabs {
            switch status {
            case .active:
                if (self.pageViewController?.selectedViewController === self.activeJobVC) {
                    activeJobVC.viewModel.getJobs(status: .active, showLoader: true, isPullToRefresh: true)
                }else {
                    activeJobVC.pullToRefresh()
                }
            case .open:
                if (self.pageViewController?.selectedViewController === self.openJobVC) {
                    openJobVC.viewModel.getJobs(status: .open, showLoader: true, isPullToRefresh: true)
                }else {
                    openJobVC.pullToRefresh()
                }
            case .past:
                if (self.pageViewController?.selectedViewController === self.pastJobVC) {
                    pastJobVC.viewModel.getJobs(status: .past, showLoader: true, isPullToRefresh: true)
                }else {
                    pastJobVC.pullToRefresh()
                }
            }
        }
    }
}

// MARK:- EMPageViewControllerDataSource, EMPageViewControllerDelegate
//====================================================================
extension JobDashboardBuilderVC: EMPageViewControllerDataSource {
    
    func em_pageViewController(_ pageViewController: EMPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if let selectedVc = pageViewController.selectedViewController {
            switch selectedVc {
            case self.activeJobVC:
                return nil
            case self.openJobVC:
                return self.activeJobVC
            case self.pastJobVC:
                return self.openJobVC
            default:
                return nil
            }
        }
        printDebug("\(#function) returns nil")
        return nil
    }
    
    func em_pageViewController(_ pageViewController: EMPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if let selectedVc = pageViewController.selectedViewController {
            switch selectedVc {
            case self.activeJobVC:
                return self.openJobVC
            case self.openJobVC:
                return self.pastJobVC
            case pastJobVC:
                return nil
            default:
                return nil
            }
        }
        printDebug("\(#function) returns nil")
        return nil
    }
}


// MARK:- EMPageViewControllerDelegate
//====================================
extension JobDashboardBuilderVC: EMPageViewControllerDelegate {
    
    // MARK: - EMPageViewController Delegate
    func em_pageViewController(_ pageViewController: EMPageViewController, willStartScrollingFrom startViewController: UIViewController, destinationViewController: UIViewController) {        
    }
    
    func em_pageViewController(_ pageViewController: EMPageViewController, isScrollingFrom startViewController: UIViewController, destinationViewController: UIViewController, progress: CGFloat) {
    }
    
    func em_pageViewController(_ pageViewController: EMPageViewController, didFinishScrollingFrom startViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) {
        if pageViewController.selectedViewController === startViewController {
            return
        }
        
        switch destinationViewController {
        case self.activeJobVC:
            self.activeBtnAction()
        case self.openJobVC:
            self.openBtnAction()
        case self.pastJobVC:
            self.pastBtnAction()
        default:
            break
        }
    }
}

extension JobDashboardBuilderVC: NewApplicantsBuilderVCDelegate {
    
    func getNewApplicantCount(count: Int) {
        newApplicantCount = count
    }
}
