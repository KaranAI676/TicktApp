//
//  ReviewBuilderVC.swift
//  Tickt
//
//  Created by Vijay's Macbook on 28/05/21.
//

import FloatRatingView

class ReviewBuilderVC: BaseVC {
    
    var jobData: RecommmendedJob?
    let viewModel = ReviewBuilderVM()
                
    @IBOutlet weak var rateView: UIView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var titleLabel: CustomBoldLabel!
    @IBOutlet weak var dateLabel: CustomRegularLabel!
    @IBOutlet weak var builderImageView: UIImageView!
    @IBOutlet weak var jobNameLabel: CustomBoldLabel!
    @IBOutlet weak var starRatingView: FloatRatingView!
    @IBOutlet weak var continueButton: CustomBoldButton!
    @IBOutlet weak var noteTextView: CustomRomanTextView!
    @IBOutlet weak var categoryNameLabel: CustomBoldLabel!
    @IBOutlet weak var jobDescriptionLabel: CustomRegularLabel!
       
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup() {
        starRatingView.type = .halfRatings
        noteTextView.applyLeftPadding(padding: 12)
        jobNameLabel.text = jobData?.jobName
        categoryNameLabel.text = jobData?.tradeName
        jobDescriptionLabel.text = jobData?.jobDescription
        builderImageView.sd_setImage(with: URL(string: jobData?.builderData?.builderImage ?? ""), placeholderImage: #imageLiteral(resourceName: "Placeholder"))
        dateLabel.text = CommonFunctions.getFormattedDates(fromDate: jobData?.fromDate?.convertToDateAllowsNil(), toDate: jobData?.toDate?.convertToDateAllowsNil())
    }
        
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender {
        case backButton:
            if rateView.isHidden {
                continueButton.setTitle("Continue", for: .normal)
                rateView.isHidden = false
                commentView.isHidden = true
                UIView.animate(withDuration: 0.35) { [weak self] in
                    self?.view.layoutIfNeeded()
                }
            } else {
                pop()
            }
        case continueButton:
            if validate() {
                if rateView.isHidden {
                    viewModel.delegate = self
                    viewModel.reviewBuilder(jobData: jobData, review: noteTextView.text, rating: "\(starRatingView.rating)")
                } else {
                    rateView.isHidden = true
                    continueButton.setTitle("Leave review", for: .normal)
                    commentView.isHidden = false
                    UIView.animate(withDuration: 0.35) { [weak self] in
                        self?.view.layoutIfNeeded()
                    }
                }
            }
        default:
            let profileVC = BuilderProfileVC.instantiate(fromAppStoryboard: .profile)
            profileVC.jobId = jobData?.jobId ?? ""
            profileVC.jobName = jobData?.jobName ?? ""
            profileVC.builderId = jobData?.builderData?.builderId ?? ""
            push(vc: profileVC)
        }
    }
    
    func validate() -> Bool {
        if rateView.isHidden { //Review
            if noteTextView.text.isEmpty {
                CommonFunctions.showToastWithMessage(Validation.errorEmptyReview)
                return false
            }
        } else { //Rating
            if starRatingView.rating == 0.0 {
                CommonFunctions.showToastWithMessage(Validation.errorEmptyRating)                
                return false
            }
        }
        return true
    }
}
