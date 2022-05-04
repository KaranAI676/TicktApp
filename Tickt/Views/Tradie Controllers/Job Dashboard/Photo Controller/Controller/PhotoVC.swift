//
//  PhotoVC.swift
//  Tickt
//
//  Created by Admin on 15/05/21.
//

import AVFoundation
import TagCellLayout

class PhotoVC: BaseVC {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var countLabel: CustomBoldLabel!
    @IBOutlet weak var jobNameLabel: CustomBoldLabel!
    @IBOutlet weak var submitPhotosButton: CustomBoldButton!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var descriptionTextView: CustomRomanTextView!
    
    var imageArray = [(image: UIImage, type: MediaTypes, videoUrl: URL?, finalUrl: String)]()
    var videoFileName: String = "/video.mp4"
  // var viewModel = CreateJobUploadMediaVM()
    var cellSize: CGSize = CGSize(width: 100 + 20, height: 100)
    var screenType: ScreenType = .creatingJob
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender {
        case backButton:
            pop()
        case submitPhotosButton:
            if validate() {
                MilestoneVC.milestoneData.photo = imageArray.map {$0.image}
                MilestoneVC.milestoneData.description = descriptionTextView.text.byRemovingLeadingTrailingWhiteSpaces
                let hourVC = HourVC.instantiate(fromAppStoryboard: .jobDashboard)
                push(vc: hourVC)
            }
        default:
            break
        }
        disableButton(sender)
    }
    
    private func setupCollectionView() {
        jobNameLabel.text = MilestoneVC.milestoneData.jobName
        descriptionTextView.applyLeftPadding(padding: 10)
        photoCollectionView.registerCell(with: PhotoCell.self)
        photoCollectionView.registerCell(with: ImageViewCollectionCell.self)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (photoCollectionView.width - 20)  / 3, height: ((photoCollectionView.width - 20) / 3) - 10)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        photoCollectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    func goToCommonPopupVC() {
        let vc = CommonButtonPopUpVC.instantiate(fromAppStoryboard: .registration)
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        vc.isAnimated = true
        vc.buttonTypeArray = [.photo, .gallery]
        mainQueue { [weak self] in
            self?.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
        
    private func getImages() -> [UIImage] {
        let imageArray = self.imageArray.map({ eachModel -> UIImage in
            return eachModel.image
        })
        return imageArray
    }
    
    private func validate() -> Bool {
        if imageArray.isEmpty {
            CommonFunctions.showToastWithMessage(Validation.errorPhotoEmpty)
            return false
        }
        
        if descriptionTextView.text.isEmpty {
            CommonFunctions.showToastWithMessage(Validation.errorEmptyDescription)
            return false
        }
        return true
    }
}
