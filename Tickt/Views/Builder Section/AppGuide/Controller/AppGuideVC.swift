//
//  AppGuideVC.swift
//  Tickt
//
//  Created by S H U B H A M on 15/07/21.
//

import UIKit

class AppGuideVC: BaseVC {
    
    enum TutorialActions {
        case previousPage
        case nextPage
    }
    
    //MARK:- IB Outlets
    @IBOutlet weak var badgeView: UIView!
    @IBOutlet weak var badgeLabel: UILabel!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    //
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    
    //MARK:- Variables
    var homeVC: TradieHomeVC? = nil
    var currentTabBar: TabBarIndex? = nil
    ///
    var currentIndex = -1
    var tabbarArray: [TabBarIndex] = []
    var coachmarksArray: [[UIView]] = []
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let index = currentTabBar?.tabValue {
            kAppDelegate.tabBarController?.selectedIndex = index
        }
        kUserDefaults.set(true, forKey: UserDefaultKeys.kTutorialPlayed)
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case previousButton:
            playCoachMarks(.previousPage)
        case nextButton:
            playCoachMarks(.nextPage)
        case yesButton:
            alertView.isHidden = true
            nextButton.isUserInteractionEnabled = true
            previousButton.isUserInteractionEnabled = true
            playCoachMarks(.nextPage)
        case noButton:
            dismiss(animated: false)
        default:
            if sender.tag == 1 {
                dismiss(animated: false)
                return
            }
        }
    }
}

extension AppGuideVC {
    
    private func initialSetup() {
        tabbarArray = kUserDefaults.isTradie() ? [.home, .jobs, .chat, .profile] : [.home, .jobs, .create, .chat, .profile]
        self.view.applyGradient(colours: [#colorLiteral(red: 0.0862745098, green: 0.1137254902, blue: 0.2901960784, alpha: 1).withAlphaComponent(0.2), #colorLiteral(red: 0.0862745098, green: 0.1137254902, blue: 0.2901960784, alpha: 1).withAlphaComponent(0.75)])
        badgeView.makeCircular()
        setupCoachData()
//        askToPlay()
        alertView.isHidden = true
        playCoachMarks(.nextPage)
    }
    
    private func askToPlay() {
        alertView.isHidden = false
        nextButton.isUserInteractionEnabled = false
        previousButton.isUserInteractionEnabled = false
    }
    
    private func playCoachMarks(_ move: TutorialActions) {
        coachmarksArray.forEach({$0.forEach({$0.alpha = 0.0})})
        switch move {
        case .nextPage:
            currentIndex += 1
        case .previousPage:
            if currentIndex > 0 { currentIndex -= 1 }
        }
        if currentIndex < coachmarksArray.count {
            coachmarksArray[currentIndex].forEach({$0.alpha = 1.0})
        } else {
            self.dismiss(animated: false)
        }
    }    
}
