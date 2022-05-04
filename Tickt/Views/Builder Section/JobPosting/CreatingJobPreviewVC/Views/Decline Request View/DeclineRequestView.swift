//
//  DeclineRequestView.swift
//  Tickt
//
//  Created by Vijay's Macbook on 02/07/21.
//

import UIKit

class DeclineRequestView: BaseVC {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var doneButton: CustomBoldButton!
    @IBOutlet weak var cancelButton: CustomBoldButton!
    @IBOutlet weak var reasonTextView: CustomRomanTextView!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    var declineRequestClosure: ((_ note: String) -> ())?
    var imageArray = [(image: UIImage, type: MediaTypes, videoUrl: URL?, finalUrl: String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        reasonTextView.applyLeftPadding(padding: 8)
        photoCollectionView.registerCell(with: PhotoCell.self)
        photoCollectionView.registerCell(with: ImageViewCollectionCell.self)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: (photoCollectionView.width - 20)  / 3, height: ((photoCollectionView.width - 20) / 3) - 10)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        photoCollectionView.setCollectionViewLayout(layout, animated: false)
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
    }
    
    func goToCommonPopupVC() {
        let vc = CommonButtonPopUpVC.instantiate(fromAppStoryboard: .registration)
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        vc.isAnimated = true
        vc.buttonTypeArray = [.photo, .gallery]
        mainQueue { [weak self] in
            self?.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender {
        case doneButton:
            if validate() {
                declineRequestClosure?(reasonTextView.text.byRemovingLeadingTrailingWhiteSpaces)
                dismiss(animated: true, completion: nil)
            }
        default:
            dismiss(animated: true, completion: nil)
        }
    }
    
    func validate() -> Bool {
        if reasonTextView.text.byRemovingLeadingTrailingWhiteSpaces.isEmpty {
            CommonFunctions.showToastWithMessage(Validation.errorEmptyNote)
            return false
        }
        return true
    }
}
