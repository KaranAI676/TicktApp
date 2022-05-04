//
//  AccountCreatedSuccessVC.swift
//  Tickt
//
//  Created by S H U B H A M on 09/03/21.
//

import UIKit

class AccountCreatedSuccessVC: BaseVC {
    
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var letsGoButton: UIButton!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var textContainerView: UIView!
    @IBOutlet weak var tickImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    
    var jobsCompleted = 1
    var screenType: ScreenType = .creatingJob
    var jobId=""
    var tradieId=""
    var republishModel: RepublishJobResult?
    var viewModel = CommonJobDetailsVM()
    var builderName:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tickImageView.transform = CGAffineTransform(scaleX: 0, y: 0)
        initialSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let nav = navigationController as? SwipeableNavigationController {
            nav.isSwipeEnabled = false
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        disableButton(sender)
        switch sender {
        case letsGoButton:
            letsGoButtonActions(sender)
        case bottomButton:
            bottomButtonActions(sender)
        default:
            break
        }
    }
}

extension AccountCreatedSuccessVC {
    
    private func letsGoButtonActions(_ sender: UIButton) {
        switch screenType {
        case .quoteSubmited:
            if let vc = navigationController?.viewControllers.first(where: { $0 is TabBarController || $0 is MapController }) {
                mainQueue { [weak self] in
                    self?.navigationController?.popToViewController(vc, animated: true)
                }
            }
        case .jobApplied:
            if let vc = navigationController?.viewControllers.first(where: { $0 is TabBarController || $0 is MapController }) {
                mainQueue { [weak self] in
                    self?.navigationController?.popToViewController(vc, animated: true)
                }
            }
        case .jobPosted:
            NotificationCenter.default.post(name: NotificationName.refreshBuilderJobDashboard, object: nil, userInfo: ["tab": JobDashboardTabs.open])
            dismiss(vc: self)
        case .saveTemplate:
            if let vc = navigationController?.viewControllers.first(where: { $0 is TemplatesListingVC }) {
                mainQueue { [weak self] in
                    self?.navigationController?.popToViewController(vc, animated: true)
                }
            } else if let vc = navigationController?.viewControllers.first(where: { $0 is MilestoneListingVC }) {
                mainQueue { [weak self] in
                    self?.navigationController?.popToViewController(vc, animated: true)
                }
            } else {
                pop()
            }
        case .completeJob:
            if let vc = navigationController?.viewControllers.first(where: { $0 is TabBarController }) {
                NotificationCenter.default.post(name: NotificationName.refreshActiveList, object: nil, userInfo: nil)
                NotificationCenter.default.post(name: NotificationName.switchJobTypesTab, object: nil, userInfo: ["tab": 1])
                mainQueue { [weak self] in
                    self?.navigationController?.popToViewController(vc, animated: true)
                }
            } else {
                pop()
            }
        case .completeMilestone, .completeMilestoneWithPhotoEvidence:
            showAnimation()
        case .lodgeDisputedTradie, .cancelJob:
            goBackFromMilestoneVC()
        case .reviewPosted, .supportChat:
            if let vc = navigationController?.viewControllers.first(where: { $0 is TabBarController }) {
                mainQueue { [weak self] in
                    self?.navigationController?.popToViewController(vc, animated: true)
                }
            } else {
                pop()
            }
        case .lodgeDisputedBuilder:
            if let vc = navigationController?.viewControllers.first(where: { $0 is CheckApproveBuilderVC }) {
                mainQueue { [weak self] in
                    self?.navigationController?.popToViewController(vc, animated: true)
                }
            } else {
                pop()
            }
        case .jobCancelled:
            if let vc = navigationController?.viewControllers.first(where: { $0 is NewApplicantsBuilderVC }) {
                mainQueue { [weak self] in
                    NotificationCenter.default.post(name: NotificationName.refreshNewApplicant, object: nil)
                    self?.navigationController?.popToViewController(vc, animated: true)
                }
            }
            else if let vc = navigationController?.viewControllers.first(where: { $0 is TabBarController }) {
                mainQueue { [weak self] in
                    NotificationCenter.default.post(name: NotificationName.refreshBuilderJobDashboard, object: nil, userInfo: ["tab": JobDashboardTabs.active])
                    self?.navigationController?.popToViewController(vc, animated: true)
                }
            } else {
                pop()
            }
        case .milestoneChangeRequest:
            if let vc = navigationController?.viewControllers.first(where: { $0 is CheckApproveBuilderVC }) {
                NotificationCenter.default.post(name: NotificationName.changeRequestBuilder, object: nil, userInfo: nil)
                mainQueue { [weak self] in
                    self?.navigationController?.popToViewController(vc, animated: true)
                }
            } else {
                pop()
            }
        case .invitedTradieFromBuilder:
            if let vc = navigationController?.viewControllers.first(where: { $0 is JobListingBuilderVC }) {
                NotificationCenter.default.post(name: NotificationName.refreshBuilderJobDashboard, object: nil, userInfo: ["tab": JobDashboardTabs.open])
                mainQueue { [weak self] in
                    self?.navigationController?.popToViewController(vc, animated: true)
                }
            } else if let vc = navigationController?.viewControllers.first(where: { $0 is TradieProfilefromBuilderVC }) {
                NotificationCenter.default.post(name: NotificationName.refreshBuilderJobDashboard, object: nil, userInfo: ["tab": JobDashboardTabs.open])
                mainQueue { [weak self] in
                    self?.navigationController?.popToViewController(vc, animated: true)
                }
            } else {
                pop()
            }
        case .milestonePaymentSuccess:
            if let remainingNonApprovedCount = kAppDelegate.totalMilestonesNonApproved {
                if remainingNonApprovedCount > 1 {
                    if let vc = navigationController?.viewControllers.first(where: { $0 is CheckApproveBuilderVC }) {
                        mainQueue { [weak self] in
                            self?.navigationController?.popToViewController(vc, animated: true)
                        }
                    } else {
                        pop()
                    }
                } else {
                    if let vc = navigationController?.viewControllers.first(where: { $0 is TabBarController }) {
                        mainQueue { [weak self] in
                            NotificationCenter.default.post(name: NotificationName.refreshBuilderJobDashboard, object: nil, userInfo: ["tab": JobDashboardTabs.active])
                            NotificationCenter.default.post(name: NotificationName.refreshBuilderJobDashboard, object: nil, userInfo: ["tab": JobDashboardTabs.past])
                            self?.navigationController?.popToViewController(vc, animated: true)
                        }
                    } else {
                        pop()
                    }
                }
            } else {
                pop()
            }
        case .milestonePaymentFailed:
            if let vc = navigationController?.viewControllers.first(where: { $0 is CheckApproveBuilderVC }) {
                mainQueue { [weak self] in
                    self?.navigationController?.popToViewController(vc, animated: true)
                }
            } else {
                pop()
            }
        case .milestoneDeclinedBuilder:
            if let remainingNonApprovedCount = kAppDelegate.totalMilestonesNonApproved {
                
                if remainingNonApprovedCount > 1 {
                    if let vc = navigationController?.viewControllers.first(where: { $0 is CheckApproveBuilderVC }) {
                        mainQueue { [weak self] in
                            self?.navigationController?.popToViewController(vc, animated: true)
                        }
                    }else {
                        pop()
                    }
                }else {
                    if let vc = navigationController?.viewControllers.first(where: { $0 is TabBarController }) {
                        mainQueue { [weak self] in
                            NotificationCenter.default.post(name: NotificationName.refreshBuilderJobDashboard, object: nil, userInfo: ["tab": JobDashboardTabs.active])
                            NotificationCenter.default.post(name: NotificationName.refreshBuilderJobDashboard, object: nil, userInfo: ["tab": JobDashboardTabs.past])
                            self?.navigationController?.popToViewController(vc, animated: true)
                        }
                    } else {
                        pop()
                    }
                }
            } else {
                pop()
            }
        case .republishJob:
            if let vc = navigationController?.viewControllers.first(where: { $0 is TabBarController }) {
                mainQueue { [weak self] in
                    NotificationCenter.default.post(name: NotificationName.refreshBuilderJobDashboard, object: nil, userInfo: ["tab": JobDashboardTabs.open])
                    NotificationCenter.default.post(name: NotificationName.refreshBuilderJobDashboard, object: nil, userInfo: ["tab": JobDashboardTabs.past])
                    self?.navigationController?.popToViewController(vc, animated: true)
                }
            } else {
                pop()
            }
        case .passwordChanged:
            AppRouter.launchApp()
        case .changeEmail:
            AppRouter.launchApp()
        case .quoteAccepted:
            if let vc = navigationController?.viewControllers.first(where: { $0 is TabBarController }) {
                NotificationCenter.default.post(name: NotificationName.refreshBuilderJobDashboard, object: nil, userInfo: ["tab": JobDashboardTabs.open])
                NotificationCenter.default.post(name: NotificationName.refreshActiveList, object: nil, userInfo: nil)
                NotificationCenter.default.post(name: NotificationName.switchJobTypesTab, object: nil, userInfo: ["tab": 1])
                mainQueue { [weak self] in
                    self?.navigationController?.popToViewController(vc, animated: true)
                }
            } else {
                pop()
            }
        case .quoteClose:
            viewModel.closeThejob(jobId: jobId,tradieID: tradieId)
        case .idConfirmation:
            if let vc = navigationController?.viewControllers.first(where: { $0 is PaymentDetailVC }) {
                mainQueue { [weak self] in
                    NotificationCenter.default.post(name: NotificationName.refreshBankDetails, object: nil)
                    self?.navigationController?.popToViewController(vc, animated: true)
                }
            } else {
                pop()
            }
        case .quotedecline:
            if let vc = navigationController?.viewControllers.first(where: { $0 is TabBarController }) {
                NotificationCenter.default.post(name: NotificationName.refreshBuilderJobDashboard, object: nil, userInfo: ["tab": JobDashboardTabs.active])
                NotificationCenter.default.post(name: NotificationName.refreshBuilderJobDashboard, object: nil, userInfo: ["tab": JobDashboardTabs.open])
                NotificationCenter.default.post(name: NotificationName.refreshBuilderJobDashboard, object: nil, userInfo: ["tab": JobDashboardTabs.past])

                mainQueue { [weak self] in
                    self?.navigationController?.popToViewController(vc, animated: true)
                }
            } else {
                pop()
            }
        default:
            AppRouter.launchApp()
        }
    }
        
    func showAnimation() {
        tickImageView.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.6, delay: 0.0, options: .curveEaseOut) { [weak self] in
            self?.letsGoButton.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        } completion: { [weak self] status in
            if status {
                UIView.animate(withDuration: 0.8, delay: 0.1, usingSpringWithDamping: CGFloat(0.5),
                               initialSpringVelocity: CGFloat(3.5), options: .curveEaseIn) { [weak self] in
                    self?.tickImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                } completion: {[weak self] status in
                    if status {
                        self?.goBackFromMilestoneVC()
                    }
                }
            }
        }
    }
    
    func goBackFromMilestoneVC() {
        if let vc = navigationController?.viewControllers.first(where: { $0 is MilestoneVC }) {
            NotificationCenter.default.post(name: NotificationName.refreshActiveList, object: nil, userInfo: nil)
            NotificationCenter.default.post(name: NotificationName.refreshMilestoneList, object: nil, userInfo: nil)
            mainQueue { [weak self] in
                self?.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    
    private func bottomButtonActions(_ sender: UIButton) {
        switch screenType {
        case .milestonePaymentSuccess:
            let vc = TransactionHistoryBuilder.instantiate(fromAppStoryboard: .loggedInUserProfileBuilder)
            push(vc: vc)
        case .milestonePaymentFailed:
            if let vc = navigationController?.viewControllers.first(where: { $0 is ConfirmAndPayPaymentBuilderVC }) {
                mainQueue { [weak self] in
                    self?.navigationController?.popToViewController(vc, animated: true)
                }
            } else {
                pop()
            }
        case .completeJob:
            if let vc = navigationController?.viewControllers.first(where: { $0 is TabBarController }) {
                NotificationCenter.default.post(name: NotificationName.refreshActiveList, object: nil, userInfo: nil)
                NotificationCenter.default.post(name: NotificationName.switchJobTypesTab, object: nil, userInfo: ["tab": 1])
                mainQueue { [weak self] in
                    self?.navigationController?.popToViewController(vc, animated: true)
                }
            } else {
                pop()
            }
            
        case .quoteClose:
            if let _ = republishModel {
                goToCreateJobVC()
//                viewModel.republishCloseJob(dataModel:model, jobID:jobId)
            } else {
                self.pop()
            }            
        default:
            break
        }
    }
}

extension AccountCreatedSuccessVC {
    
    private func initialSetup() {
        switch screenType {
        case .createAccount:
            
            bgImageView.image = #imageLiteral(resourceName: "accountCreateBg")
            titleLabel.text = "Nicely done!"
            
            switch kUserDefaults.getUserType() {
            case 2:
                descriptionLabel.text = "Your account has been created. Time to start getting projects done!"
            case 1:
                descriptionLabel.text = "Your account has been created. You are one step closer to growing your business."
            default:
                break
            }
        case .edit:
            bgImageView.image = #imageLiteral(resourceName: "changePasswordSussess")
            titleLabel.text = "Nice!"
            letsGoButton.setTitle("Log in", for: .normal)
            letsGoButton.setTitle("Log in", for: .selected)
            switch kUserDefaults.getUserType() {
            case 2:
                descriptionLabel.text = "You have created new password for your account."
            case 1:
                descriptionLabel.text = "You have updated the password for your account."
            default:
                break
            }
        case .saveTemplate:
            bgImageView.image = #imageLiteral(resourceName: "templateSavedSucccess")
            titleLabel.text = "Template saved!"
            descriptionLabel.text = "Your template is saved in your Milestone templates. You can choose it when posting new jobs - way to save time!"
            
            letsGoButton.setTitle("OK", for: .normal)
            letsGoButton.setTitle("OK", for: .selected)
        case .jobPosted:
            bgImageView.image = #imageLiteral(resourceName: "jobPosted")
            titleLabel.text = "Job posted!"
            descriptionLabel.text = "Your job will be sent to the most suitable candidates in your area. New applicants can be viewed on the Jobs tab."
            
            letsGoButton.setTitle("OK", for: .normal)
            letsGoButton.setTitle("OK", for: .selected)
            
        case .jobApplied:
            bgImageView.image = #imageLiteral(resourceName: "applyJob")
            titleLabel.text = "Application sent!"
            descriptionLabel.text = "We'll let you know if you've been selected for the job."
            letsGoButton.setTitle("OK", for: .normal)
            letsGoButton.setTitle("OK", for: .selected)
            
        case .completeJob:
            bgImageView.image = #imageLiteral(resourceName: "job")
            let lastDigit = jobsCompleted % 10
            var jobOrdinal = ""
            switch lastDigit {
            case 1:
                jobOrdinal = "\(jobsCompleted)st"
            case 2:
                jobOrdinal = "\(jobsCompleted)nd"
            case 3:
                jobOrdinal = "\(jobsCompleted)rd"
            default:
                jobOrdinal = "\(jobsCompleted)th"
            }
            titleLabel.text = "Your \(jobOrdinal) job is completed!"
            descriptionLabel.text = "You have completed your \(jobOrdinal) Job using Tickt! Click here to view your completed jobs or leave a review. You will be paid as soon as the builder signs off."
            
            letsGoButton.setTitle("OK", for: .normal)
            letsGoButton.setTitle("OK", for: .selected)
            bottomButton.isHidden = false
        case .completeMilestone, .completeMilestoneWithPhotoEvidence:
            titleLabel.text = "Milestone completed!"
            if screenType == .completeMilestone {
                bgImageView.image = #imageLiteral(resourceName: "milestone")
                descriptionLabel.text = "Nice one! We'll notify the builder right away."
            } else {
                bgImageView.image = #imageLiteral(resourceName: "photoEvidence")
                descriptionLabel.text = "Nice one! The builder will review any required photos and approve your milestone shortly."
            }
            
            letsGoButton.setTitle("OK", for: .normal)
            letsGoButton.setTitle("OK", for: .selected)
        case .reviewPosted:
            bgImageView.image = #imageLiteral(resourceName: "reviewPosted")
            titleLabel.text = "Thanks!"
            if kUserDefaults.isTradie() {
                descriptionLabel.text = "Your review will help other tradies find the highest quality builders and jobs on Tickt."
            } else {
                descriptionLabel.text = "Your review will help other builders find the highest quality tradespeople on Tickt."
            }            
            letsGoButton.setTitle("OK", for: .normal)
            letsGoButton.setTitle("OK", for: .selected)
        case .jobCancelled:
            bgImageView.image = #imageLiteral(resourceName: "CancelSuccess")
            titleLabel.text = "Got it!"
            descriptionLabel.text = "We’ll send it to your tradesperson. Why not check out new recommends on the homepage."
            letsGoButton.setTitle("OK", for: .normal)
            letsGoButton.setTitle("OK", for: .selected)
        case .lodgeDisputedBuilder:
            bgImageView.image = #imageLiteral(resourceName: "lodgeDesputeSuccess")
            titleLabel.text = "Got it!"
            descriptionLabel.text = "We’ll review and get in touch with your tradesperson."
            letsGoButton.setTitle("OK", for: .normal)
            letsGoButton.setTitle("OK", for: .selected)
        case .lodgeDisputedTradie:
            bgImageView.image = #imageLiteral(resourceName: "job")
            titleLabel.text = "Got it!"
            descriptionLabel.text = "We’ll review and get in touch with your builder."
            letsGoButton.setTitle("OK", for: .normal)
            letsGoButton.setTitle("OK", for: .selected)
        case .cancelJob:
            bgImageView.image = #imageLiteral(resourceName: "applyJob")
            titleLabel.text = "Got it!"
            descriptionLabel.text = "We’ll send it to your builder. Why not check out new recommended jobs on the homepage."
            letsGoButton.setTitle("OK", for: .normal)
            letsGoButton.setTitle("OK", for: .selected)
        case .milestoneChangeRequest:
            bgImageView.image = #imageLiteral(resourceName: "editMilestoneSuccess")
            titleLabel.text = "Request is sent"
            descriptionLabel.text = "Your milestone change request has been sent to the tradesperson."
            letsGoButton.setTitle("OK", for: .normal)
            letsGoButton.setTitle("OK", for: .selected)
        case .invitedTradieFromBuilder:
            bgImageView.image = #imageLiteral(resourceName: "inviteSuccess")
            titleLabel.text = "Thanks!"
            descriptionLabel.text = "We’ve sent this job to the tradie. You can find other recommended tradespeople in the search results."
            letsGoButton.setTitle("OK", for: .normal)
            letsGoButton.setTitle("OK", for: .selected)
        case .milestonePaymentSuccess:
            bgImageView.image = #imageLiteral(resourceName: "milestoneApprovedBuilder")
            titleLabel.text = "Payment sent!"
            descriptionLabel.text = "The payment is on the way! The tradesperson will receive payment shortly and can start the next milestone."
            letsGoButton.setTitle("Continue", for: .normal)
            letsGoButton.setTitle("Continue", for: .selected)
            bottomButton.isHidden = false
            bottomButton.setTitle("See your transactions", for: .normal)
            bottomButton.setTitle("See your transactions", for: .selected)
        case .milestoneDeclinedBuilder:
            bgImageView.image = #imageLiteral(resourceName: "milestoneDeclinedBuilder")
            titleLabel.text = "Got it!"
            descriptionLabel.text = "The tradesperson will review and get in touch with you."
            letsGoButton.setTitle("OK", for: .normal)
            letsGoButton.setTitle("OK", for: .selected)
        case .milestonePaymentFailed:
            bgImageView.image = #imageLiteral(resourceName: "jobPosted")
            titleLabel.text = "Please check again"
            descriptionLabel.text = "Sorry, we cannot complete your payment at this time. There was a problem with your payment  method. Please check and try again."
            letsGoButton.setTitle("OK", for: .normal)
            letsGoButton.setTitle("OK", for: .selected)
            bottomButton.isHidden = false
            bottomButton.setTitle("Change payment method ", for: .normal)
            bottomButton.setTitle("Change payment method ", for: .selected)
        case .republishJob:
            bgImageView.image = #imageLiteral(resourceName: "jobPosted")
            titleLabel.text = "Job posted!"
            descriptionLabel.text = "Your job will be sent to the most suitable candidates in your area."
            
            letsGoButton.setTitle("OK", for: .normal)
            letsGoButton.setTitle("OK", for: .selected)
        case .passwordChanged:
            bgImageView.image = #imageLiteral(resourceName: "changePasswordSussess")
            titleLabel.text = "Done!"
            descriptionLabel.text = "Your password has been updated. Now you can log in into Tickt with your new password."
            
            letsGoButton.setTitle("OK", for: .normal)
            letsGoButton.setTitle("OK", for: .selected)
        case .changeEmail:
            bgImageView.image = #imageLiteral(resourceName: "changePasswordSussess")
            titleLabel.text = "Thanks!"
            descriptionLabel.text = "Your have updated email for your account."
            
            letsGoButton.setTitle("Login", for: .normal)
            letsGoButton.setTitle("Login", for: .selected)
        case .supportChat:
            bgImageView.image = #imageLiteral(resourceName: "CancelSuccess")
            titleLabel.text = "Hang tight!"
            descriptionLabel.text = "Your message is on the way to the Tickt support crew and we’ll get back to you as soon as we can."
            
            letsGoButton.setTitle("OK", for: .normal)
            letsGoButton.setTitle("OK", for: .selected)
        case .quoteSubmited:
            bgImageView.image = #imageLiteral(resourceName: "changePasswordSussess")
            titleLabel.text = "Nice!"
            descriptionLabel.text = "Your quote has been sent to \(builderName)"//"You have submited your bid. You can view your bid in your applied jobs tab."
            
            letsGoButton.setTitle("OK", for: .normal)
            letsGoButton.setTitle("OK", for: .selected)
            
        case .quoteAccepted:
            bgImageView.image = #imageLiteral(resourceName: "jobPosted")
            titleLabel.text = "Quote accepted!"
            descriptionLabel.text = "You have accepted a quote. You will be find the job in your active jobs tab."
            
            letsGoButton.setTitle("OK", for: .normal)
            letsGoButton.setTitle("OK", for: .selected)
            
        case .quoteClose:
            viewModel.delegate = self
            viewModel.getRepublishJobDetails(jobId: jobId)
            bgImageView.image = #imageLiteral(resourceName: "jobPosted")
            titleLabel.text = "Job cancelled"
            descriptionLabel.text = "Your job for quoting has just being cancelled. Do you want to close the job or keep it open for new bidders?"
            
            letsGoButton.setTitle("Close the job", for: .normal)
            letsGoButton.setTitle("Close the job", for: .selected)
            bottomButton.isHidden = false
            bottomButton.setTitle("Keep the job open", for: .normal)
            bottomButton.setTitle("Keep the job open", for: .selected)
            bottomButton.backgroundColor = .white
            
        case .idConfirmation:
            bgImageView.image = #imageLiteral(resourceName: "CancelSuccess")
            titleLabel.text = "Thanks!"
            descriptionLabel.text = "If we need anything else, we'll \nreach out"
            
            letsGoButton.setTitle("OK", for: .normal)
            letsGoButton.setTitle("OK", for: .selected)
            
        case .quotedecline :
            bgImageView.image = #imageLiteral(resourceName: "jobPosted")
            titleLabel.text = "Quote declined!"
            descriptionLabel.text = "You declined a quote."
            
            letsGoButton.setTitle("OK", for: .normal)
            letsGoButton.setTitle("OK", for: .selected)
            
        default:
            break
        }
    }
}


//DELEGATES====
//==============
extension AccountCreatedSuccessVC: CommonJobDetailsVMDelegate {
    func deleteJob(status: Bool, index: IndexPath) {
        
    }
    
    func republishSuccess(model: RepublishJobResult) {
        republishModel = model        
    }
    
    private func goToCreateJobVC() {
        navigateToCreateJob()
    }
    
    func navigateToCreateJob() {
        let vc = CreateJobVC.instantiate(fromAppStoryboard: .jobPosting)
        vc.removeControllers = true
        if let model = republishModel {
            var createJobModel = CreateJobModel(model: model)
            createJobModel.jobId = jobId
            kAppDelegate.postJobModel = createJobModel
        }
        if screenType == .openJobs { //jobDetail?.result?.quoteJob ?? false{
            vc.screenType = .editQuoteJob
        } else {
            vc.screenType = .republishJob
        }
        push(vc: vc)
    }
    
    func cancelRequestSuccess(status: AcceptDecline) {
        
    }
    
    func openJobDetails(model: JobDetailsModel) {
    }
    
    func failure(error: String) {
        CommonFunctions.showToastWithMessage(error)
    }
    
    func closeJob(msg:String){
        CommonFunctions.showToastWithMessage(msg)
        
        if let vc = navigationController?.viewControllers.first(where: { $0 is NewApplicantsBuilderVC }) {
            mainQueue { [weak self] in
                NotificationCenter.default.post(name: NotificationName.refreshNewApplicant, object: nil)
                self?.navigationController?.popToViewController(vc, animated: true)
            }
        } else if let vc = navigationController?.viewControllers.first(where: { $0 is TabBarController }) {
            mainQueue { [weak self] in
                NotificationCenter.default.post(name: NotificationName.refreshBuilderJobDashboard, object: nil, userInfo: ["tab": JobDashboardTabs.active])
                NotificationCenter.default.post(name: NotificationName.refreshBuilderJobDashboard, object: nil, userInfo: ["tab": JobDashboardTabs.open])
                NotificationCenter.default.post(name: NotificationName.refreshBuilderJobDashboard, object: nil, userInfo: ["tab": JobDashboardTabs.past])
                self?.navigationController?.popToViewController(vc, animated: true)
            }
        } else {
            pop()
        }
    }
    
    func openJobSucess() {
        if let vc = navigationController?.viewControllers.first(where: { $0 is TabBarController }) {
            NotificationCenter.default.post(name: NotificationName.refreshActiveList, object: nil, userInfo: nil)
            NotificationCenter.default.post(name: NotificationName.switchJobTypesTab, object: nil, userInfo: ["tab": 1])
            mainQueue { [weak self] in
                self?.navigationController?.popToViewController(vc, animated: true)
            }
        } else {
            pop() 
        }
    }
    
    func goToDetailVC(_ jobId: String, screenType: ScreenType, status: String, republishModel: RepublishJobResult? = nil) {
        let vc = CommonJobDetailsVC.instantiate(fromAppStoryboard: .commonJobDetails)
        vc.screenType = .pastJobsExpired
        vc.jobId = jobId
        vc.pastJobStatus = JobStatus.expired.rawValue
        vc.republishModel = republishModel
        self.push(vc: vc)
    }

}

