//
//  ViewQuoteVC.swift
//  Tickt
//
//  Created by Vijay's Macbook on 06/09/21.
//

import UIKit

class ViewQuoteVC: BaseVC {
    
    var tradieId = kUserDefaults.getUserId()
    let viewModel = ViewQuoteVM()
    var jobObject: RecommmendedJob?
    var itemList: [ItemDetails] = []
    var sectionArray: [AddQuoteVC.CellType] = [.itemList]
    
    @IBOutlet weak var quoteTableView: UITableView!
    @IBOutlet weak var tradeImageView: UIImageView!
    @IBOutlet weak var totalPriceLabel: CustomBoldLabel!
    @IBOutlet weak var jobNameLabel: CustomRegularLabel!
    @IBOutlet weak var tradeNameLabel: CustomMediumLabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup() {
        quoteTableView.registerCell(with: AddItemCell.self)
        quoteTableView.registerCell(with: ItemListCell.self)
        quoteTableView.registerCell(with: TotalPriceCell.self)
        jobNameLabel.text = jobObject?.jobName
        tradeNameLabel.text = jobObject?.tradeName
        tradeImageView.sd_setImage(with: URL(string: jobObject?.tradeSelectedUrl ?? ""), placeholderImage: nil)
        viewModel.delegate = self
        viewModel.getQuoteDetail(jobId: jobObject?.jobId ?? "", tradieId: tradieId)
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        pop()
    }
    
    @IBAction func viewQuote(_ sender: UIButton) {
        let vc = AddQuoteVC.instantiate(fromAppStoryboard: .quotes)
        vc.delegate = self
        vc.isResubmitQuote = true
        let object = jobObject
//        let data = JobDetailsData(time: nil, isSaved: false, editJob: false, jobId: object?.jobId, quoteJob: true, quoteCount: 0, status: "", toDate: "", amount: "", isInvited: false, tradeId: object?.tradeId, details: "", jobName: object?.jobName, fromDate: "", distance: 0, duration: "", jobStatus: "", tradeName: object?.tradeName, postedBy: PostedBy(reviews: 0, ratings: 0, builderId: object?.builderId, builderName: object?.builderName, builderImage: object?.builderImage), questionsCount: 0, milestoneNumber: 0, totalMilestones: 0, locationName: "", jobType: nil, isChangeRequest: false, appliedStatus: "", photos: [], alreadyApplyQuote: true, applyButtonDisplay: true, tradeSelectedUrl: object?.tradeSelectedUrl, specializationId: object?.specializationId, isCancelJobRequest: false, specializationName: object?.specializationName, reasonForCancelJobRequest: 0, reasonForChangeRequest: [], changeRequestDeclineReason: "", reasonNoteForCancelJobRequest: "", changeRequestData: [], jobMilestonesData: [], specializationData: [], rejectReasonNoteForCancelJobRequest: "")
   //     vc.jobDetail = data   //Maa meri
        push(vc: vc)
    }
    
}


extension ViewQuoteVC: OpenQuotesJobsVCDelegate, SubmitQuoteDelegate {
    func didQuoteAccepted() {
        
    }
    
    func didQuoteSubmitted() {
    //    pullToRefresh()
    }

    func removedQuoteJob(jobId: String, status: AcceptDecline, index: IndexPath) {
      
    }
}
