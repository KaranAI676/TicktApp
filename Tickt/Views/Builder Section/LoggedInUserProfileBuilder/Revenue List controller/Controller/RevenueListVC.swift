//
//  RevenueListVC.swift
//  Tickt
//
//  Created by Vijay's Macbook on 13/07/21.
//

import UIKit

class RevenueListVC: BaseVC {
    
    @IBOutlet weak var activeView: UIView!
    @IBOutlet weak var completeView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var activeImageView: UIImageView!
    @IBOutlet weak var jobDateLabel: CustomRomanLabel!
    @IBOutlet weak var milestoneTableView: UITableView!
    @IBOutlet weak var completedImageView: UIImageView!
    @IBOutlet weak var activeAmoutLabel: CustomBoldLabel!
    @IBOutlet weak var completeJobLabel: CustomMediumLabel!
    @IBOutlet weak var completeAmountLabel: CustomBoldLabel!
    @IBOutlet weak var activeJobNameLabel: CustomMediumLabel!
   
    var jobId = ""
    var isActiveJob = false
    var completedMilestone = 0
    let viewModel = RevenueListVM()
    var detailModel: RevenueDetailModel?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup() {
        if isActiveJob {
            activeView.isHidden = false
            completeView.isHidden = true
        }
        milestoneTableView.registerCell(with: RevenueMilestoneCell.self)
        viewModel.delegate = self
        viewModel.getMilestoneList(jobId: jobId)
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        pop()
    }
}
