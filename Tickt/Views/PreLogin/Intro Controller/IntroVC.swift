//
//  IntroVC.swift
//  Tickt
//
//  Created by Vijay on 03/03/21.
//

import UIKit

class IntroVC: BaseVC {
        
    var currentPage = 0
    var imageArray: [(image: String, descp: String)] = [("", "")]
            
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var introCollectionView: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    private func initialSetup() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: kScreenWidth, height: kScreenHeight)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0        
        introCollectionView.setCollectionViewLayout(layout, animated: false)
        switch kUserDefaults.getUserType() {
        case 1:
            imageArray = [("introBlank_1", "Find quality work that grows your business"),
                          ("introBlank_2", "Choose work that suits your location, price and schedule"),
                          ("introBlank_3", "Job's milestones and scheduling ensures you are paid on time")]
        case 2:
            imageArray = [("introBlank_1", "Find quality tradespeople"),
                          ("introBlank_2", "Manage jobs and milestones in one spot"),
                          ("introBlank_3", "Streamline payments and get your projects done, easier")]
        default:
            break
        }
    }
    
    @IBAction func signupButtonAction(_ sender: UIButton) {
        switch sender {
        case backButton:
            self.pop()
        default:
            let signupVC = CreateAccountVC.instantiate(fromAppStoryboard: .registration)
            push(vc: signupVC)            
        }
        disableButton(sender)
    }
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        let loginVC = LoginVC.instantiate(fromAppStoryboard: .registration)
        push(vc: loginVC)
        disableButton(sender)
    }
}
