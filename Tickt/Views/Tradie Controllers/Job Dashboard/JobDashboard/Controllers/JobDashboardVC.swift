//
//  JobDashboardBuilderVC.swift
//  Tickt
//
//  Created by S H U B H A M on 05/05/21.
//

import UIKit

class JobDashboardVC: BaseVC {
            
    @IBOutlet weak var openButton: UIButton!
    @IBOutlet weak var pastButton: UIButton!
    @IBOutlet weak var activeButton: UIButton!
    @IBOutlet weak var newJobsButton: UIButton!
    @IBOutlet weak var milestoneButton: UIButton!
    @IBOutlet weak var newJobsCountLabel: UILabel!
    @IBOutlet weak var milestoneCountLabel: UILabel!
    @IBOutlet weak var subViewContainerView: UIView!
    
    var buttonsArray = [UIButton]()
    var pageViewController: EMPageViewController?
    
    lazy var activeJobVC: ActiveJobsVC = {
        let vc = ActiveJobsVC.instantiate(fromAppStoryboard: .jobDashboardBuilder)
        vc.view.backgroundColor = .clear
        return vc
    }()
    
    lazy var openJobVC: OpenJobsVC = {
        let vc = OpenJobsVC.instantiate(fromAppStoryboard: .jobDashboardBuilder)
        vc.view.backgroundColor = .clear
        return vc
    }()
    
    lazy var pastJobVC: PastJobsVC = {
        let vc = PastJobsVC.instantiate(fromAppStoryboard: .jobDashboardBuilder)
        vc.view.backgroundColor = .clear
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        pageViewControllerSetUp()
        NotificationCenter.default.addObserver(self, selector: #selector(switchJobTab(_:)), name: NotificationName.switchJobTypesTab, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshJobCount(_:)), name: NotificationName.refreshJobCount, object: nil)
    }
    
    @objc func refreshJobCount(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let jobCount = userInfo[ApiKeys.jobCount] as? Int {
                newJobsCountLabel.text = "\(jobCount)"
            }
            
            if let milestoneCount = userInfo[ApiKeys.milestoneCount] as? Int {
                milestoneCountLabel.text = "\(milestoneCount)"
            }
        }
    }

    @objc func switchJobTab(_ notification: Notification) {
        if let userInfo = notification.userInfo, let status = userInfo["tab"] as? Int {
            switch status {
            case 1:
                activeBtnAction(goToVC: true)
            case 2:
                openBtnAction(goToVC: true)
            case 3:
                pastBtnAction(goToVC: true)
            default:
                break
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let heightFromMainContainerView = subViewContainerView.bounds.height //kScreenHeight// - navBehindView.height - 50
        pageViewController?.view.frame.size = CGSize(width: kScreenWidth, height: heightFromMainContainerView)
        activeJobVC.view.frame.size = CGSize(width: kScreenWidth, height: heightFromMainContainerView)
        openJobVC.view.frame.size = CGSize(width: kScreenWidth, height: heightFromMainContainerView)
        pastJobVC.view.frame.size = CGSize(width: kScreenWidth, height: heightFromMainContainerView)
    }
        
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case newJobsButton:
            let jobListing = JobListingVC.instantiate(fromAppStoryboard: .jobDashboard)
            jobListing.screenType = .newJob
            push(vc: jobListing)
        case milestoneButton:
            let milestoneListingVC = JobListingVC.instantiate(fromAppStoryboard: .jobDashboard)
            milestoneListingVC.screenType = .newMilestone
            push(vc: milestoneListingVC)
        case activeButton:
            activeBtnAction(goToVC: true)
        case openButton:
            openBtnAction(goToVC: true)
        case pastButton:
            pastBtnAction(goToVC: true)
        default:
            break
        }
        disableButton(sender)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension JobDashboardVC {
    
    private func initialSetup() {
        subViewContainerView.backgroundColor = .clear
        buttonsArray = [activeButton, openButton, pastButton]
    }
    
    private func pageViewControllerSetUp() {
        
        let pageViewController = EMPageViewController()
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        let currentViewController = activeJobVC
        pageViewController.selectViewController(currentViewController, direction: .forward, animated: false, completion: nil)
        
        // Add EMPageViewController to the root view controller
        let heightFromMainContainerView = subViewContainerView.bounds.height
        pageViewController.view.frame = CGRect(x: 0, y: 0, width: UIDevice.width, height: heightFromMainContainerView)
        pageViewController.willMove(toParent: self)
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        subViewContainerView.addSubview(pageViewController.view)                
        self.pageViewController = pageViewController
        activeBtnAction()
    }
}
