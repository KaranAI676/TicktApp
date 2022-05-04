//
//  JobListPopup.swift
//  Tickt
//
//  Created by Vijay's Macbook on 12/08/21.
//

import UIKit

protocol JobChatDelegate: AnyObject {
    func didJobSelected(jobDetail: JobListData)
}

class JobListPopup: UIView {
    
    var userId = ""
    var userType: String {
        get {
            return kUserDefaults.isTradie() ? "2" : "1"
        }
    }
    let viewModel = JobListVM()
    weak var delegate: JobChatDelegate?
        
    @IBOutlet weak var jobTableView: UITableView!
    @IBOutlet weak var cancelButton: CustomBoldButton!
    @IBOutlet weak var selectButton: CustomBoldButton!
    @IBOutlet weak var watermarkLabel: CustomBoldLabel!
        
    lazy var refreshControl: UIRefreshControl = {
        $0.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return $0
    }(UIRefreshControl())
    
    override func awakeFromNib() {
        super.awakeFromNib()
        jobTableView.refreshControl = refreshControl
        jobTableView.delegate = self
        jobTableView.dataSource = self
        jobTableView.registerCell(with: JobListPopupCell.self)
    }
            
    func initialSetup() {
        viewModel.delegate = self
        viewModel.getJobList(userId: userId, userType: userType, showLoader: true ,isPullToRefresh: false)
    }
    
    private func hitPaginationClosure() {        
        viewModel.hitPaginationClosure = { [weak self] in
            guard let self = self else { return }
            self.viewModel.getJobList(userId: self.userId, userType: self.userType, showLoader: false , isPullToRefresh: false)
        }
    }

    @objc func refreshData() {
        viewModel.getJobList(userId: userId, userType: userType, showLoader: false , isPullToRefresh: true)
    }
        
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender {
        case selectButton:
            break
        case cancelButton:
            popOut()
        default:
            break
        }
    }
}
