//
//  JobMilestoneCell.swift
//  Tickt
//
//  Created by Admin on 14/05/21.
//

import UIKit

class JobMilestoneCell: UITableViewCell {
        
    @IBOutlet weak var dashView: DashView!
    @IBOutlet weak var dashView2: DashView!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var dateLabel: CustomRomanLabel!
    @IBOutlet weak var declineContainerView: UIView!
    @IBOutlet weak var nameLabel: CustomMediumLabel!
    @IBOutlet weak var reasonLabel: CustomRomanLabel!
    @IBOutlet weak var completeContainerView: UIView!
    @IBOutlet weak var completeButton: CustomBoldButton!
    @IBOutlet weak var photoEvidenceLabel: CustomRomanLabel!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var photosHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewBottomContraint: NSLayoutConstraint!
    
    var imageArray: [String]? {
        didSet {
            photoCollectionView.reloadData()
        }
    }
        
    var completeButtonAction: (()->())?
    var selectMilestoneAction: (()->())?
    var openImageAction: ((_ url: String)->())?
    
    var milestone: MilestoneData? {
        didSet {
            imageArray = milestone?.declinedReason?.url
            declineContainerView.isHidden = true
            completeContainerView.isHidden = true
            stackViewBottomContraint.constant = 20
            nameLabel.text = milestone?.milestoneName
            selectButton.isUserInteractionEnabled = false
            completeButton.isUserInteractionEnabled = false
            reasonLabel.text = milestone?.declinedReason?.reason
            photoEvidenceLabel.isHidden = !(milestone?.isPhotoevidence ?? false)
            photoEvidenceLabel.text = (milestone?.isPhotoevidence ?? false) ?  "Photo evidence required" : ""
            dateLabel.text = CommonFunctions.getFormattedDates(fromDate: milestone?.fromDate?.convertToDateAllowsNil(), toDate: milestone?.toDate?.convertToDateAllowsNil())
            photosHeightConstraint.constant = 0
            let status = milestone?.status ?? 0
            if let miletsoneStatus = MilestoneStatus(rawValue: status) {
                switch miletsoneStatus {
                case .notComplete, .changeRequest, .changeRequestAccepted:
                    selectButton.isUserInteractionEnabled = true
                    completeButton.setTitle("Mark Complete", for: .normal)
                    if milestone?.isMilestoneSelected ?? false { //Locally Selected
                        completeButton.alpha = 1.0
                        completeContainerView.isHidden = false
                        selectButton.setImage(#imageLiteral(resourceName: "bulletSelection"), for: .normal)
                        completeButton.isUserInteractionEnabled = true
                    } else {
                        completeButton.alpha = 0.3
                        completeContainerView.isHidden = true
                        selectButton.setImage(#imageLiteral(resourceName: "checkBoxUnselected"), for: .normal)
                        completeButton.isUserInteractionEnabled = false
                    }
                case .completed:
                    selectButton.setImage(#imageLiteral(resourceName: "bulletSelection"), for: .normal)
                case .approved:
                    selectButton.setImage(#imageLiteral(resourceName: "icCheck"), for: .normal)
                case .declined:
                    stackViewBottomContraint.constant = 45
                    selectButton.setImage(#imageLiteral(resourceName: "exclamationSmall"), for: .normal)
                    selectButton.isUserInteractionEnabled = true
                    completeButton.setTitle("Remark as Complete", for: .normal)
                    if milestone?.isMilestoneSelected ?? false { //Locally Selected
                        completeButton.alpha = 1.0
                        declineContainerView.isHidden = false
                        completeContainerView.isHidden = false
                        completeButton.isUserInteractionEnabled = true
                    } else {
                        completeButton.alpha = 0.3
                        declineContainerView.isHidden = true
                        completeContainerView.isHidden = true
                        completeButton.isUserInteractionEnabled = false
                    }
                    if imageArray.isNil {
                        photosHeightConstraint.constant = 0
                    } else {
                        photosHeightConstraint.constant = 120
                    }
                    photoCollectionView.reloadData()
                    layoutIfNeeded()
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }
    
    func initialSetup() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 120)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        photoCollectionView.setCollectionViewLayout(layout, animated: false)
        photoCollectionView.registerCell(with: PhotoCollectionCell.self)
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
    }
    
    @IBAction func selectButton(_ sender: UIButton) {
        let status = milestone?.status ?? 0
        if let milestoneStatus = MilestoneStatus(rawValue: status) {
            switch milestoneStatus {
            case .notComplete, .declined, .changeRequest, .changeRequestAccepted:
                if sender == completeButton {
                    if milestone?.isMilestoneSelected ?? false {
                        completeButtonAction?()
                    }
                } else {
                    selectMilestoneAction?()
                }
            default:
                break
            }
        }
    }
    
    func setDashView(color: UIColor, isShow: Bool) {
        dashView.isHidden = !isShow
        (dashView.layer.sublayers?.first as? CAShapeLayer)?.strokeColor = color.cgColor
    }
    
    func setDashView1(isShow: Bool) {
        if milestone?.isMilestoneSelected ?? false {
            dashView2.isHidden = !isShow
        } else {
            dashView2.isHidden = true
        }
        (dashView2.layer.sublayers?.first as? CAShapeLayer)?.strokeColor = AppColors.themeBlue.cgColor
    }
    
    func setFontColor(status: Bool) {
        if status { //Fade
            dateLabel.textColor = UIColor(hex: "#748092")
            nameLabel.textColor = UIColor(hex: "#748092")
            photoEvidenceLabel.textColor = UIColor(hex: "#748092")
        } else { //Original
            dateLabel.textColor = UIColor(hex: "#313D48")
            nameLabel.textColor = UIColor(hex: "#161D4A")
            photoEvidenceLabel.textColor = UIColor(hex: "#313D48")
        }
    }
}


extension JobMilestoneCell: CollectionDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: PhotoCollectionCell.self, indexPath: indexPath)
        cell.urlString = imageArray![indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        openImageAction?(imageArray![indexPath.item])
    }
}
