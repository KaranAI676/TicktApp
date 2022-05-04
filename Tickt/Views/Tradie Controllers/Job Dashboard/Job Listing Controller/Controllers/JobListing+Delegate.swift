//
//  JobListing+Delegate.swift
//  Tickt
//
//  Created by Vijay's Macbook on 15/05/21.
//

extension JobListingVC: JobListingDelegate {

    func didGetAllReviews() {
        refreshControl.endRefreshing()
        titleLabel.text = "\(viewModel.reviewModel?.result?.count ?? (viewModel.reviewModel?.result?.list?.count ?? 0)) reviews"
        if (viewModel.reviewModel?.result?.list?.count ?? 0) == 0 {
            showWaterMarkLabel(message: "No reviews found!")
        } else {
            hideWaterMarkLabel()
        }
        mainQueue { [weak self] in
            self?.jobTableView.reloadData()
        }
    }
    
    func didGetMilestone() {
        refreshControl.endRefreshing()
        if (viewModel.milestoneModel?.result?.count ?? 0) == 0 {
            showWaterMarkLabel(message: "No approved milestone found!")
        } else {
            hideWaterMarkLabel()
        }
        mainQueue { [weak self] in
            self?.jobTableView.reloadData()
        }
    }
        
    func didReplyDeletedHeader(index: Int) {
        //Workarround, get index
        viewModel.getBuildersReviews(showLoader: false, isPullToRefresh: false, builderId: builderId)
        mainQueue { [weak self] in
            self?.jobTableView.reloadData()
        }
    }
    
    func didReplyDeleted(index: Int) {
        viewModel.reviewModel?.result?.list?[index].reviewData?.replyData = ReplyData(userImage: nil, reply: nil, date: nil, reviewId: nil, replyId: nil, name: nil, isModifiable: nil)
        mainQueue { [weak self] in
            self?.jobTableView.reloadData()
        }
    }    
    
    func success(model: RepublishJobResult, jobId: String, status: String) {
        goToDetailVC(jobId, screenType: .pastJobsExpired, status: status, republishModel: model)
    }
        
    func didGetNewJobs() {
        refreshControl.endRefreshing()
        if (viewModel.jobModel?.result?.count ?? 0) == 0 {
            if screenType == .savedjobs {
                showWaterMarkLabel(message: "No saved jobs yet!")
            } else {
                showWaterMarkLabel(message: "No new jobs has been found!")
            }
        } else {
            hideWaterMarkLabel()
        }
        mainQueue { [weak self] in
            self?.jobTableView.reloadData()
        }
    }
    
    func failure(error: String) {
        refreshControl.endRefreshing()
    }
}
