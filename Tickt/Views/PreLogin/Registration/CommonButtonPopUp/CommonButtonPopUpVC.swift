//
//  CommonButtonPopUpVC.swift
//  Tickt
//
//  Created by S H U B H A M on 09/03/21.
//

import UIKit

protocol CommonButtonDelegate: AnyObject {
    func selectDocument()
    func takeVideo()
    func takePhoto()
    func galleryButton()
    func selectDocumentFromDropbox()
}

extension CommonButtonDelegate {
    func takeVideo() {}
    func selectDocument() {}
    func selectDocumentFromDropbox() {}
}

class CommonButtonPopUpVC: BaseVC {
    
    enum ButtonType {
        case video
        case photo
        case gallery
        case document
        case dropbox
    }
    
    //MARK:- PROPERTIES
    //=================
    var uploadDocument: String = "Upload from files"
    var takeVideo: String = "Take a Video"
    var takePhoto: String = "Take a Photo"
    var gallery: String = "Upload from Gallery"
    var dropbox: String = "Upload from Dropbox"
    var isAnimated: Bool = false
    weak var delegate: CommonButtonDelegate?
    var buttonTypeArray: [ButtonType] = []
    private var buttonArray: [UIButton] = []
        
    //MARK:- IBOUTLETS
    //================
    @IBOutlet private weak var cornerRadiusBgView: UIView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var bottomBgView: UIView!
    @IBOutlet weak var takeVideoButton: UIButton!
    @IBOutlet weak var uploadDocumentButton: UIButton!
    @IBOutlet private weak var takePhotoButton: UIButton!
    @IBOutlet private weak var galleryButton: UIButton!
    @IBOutlet private weak var dismissButton: UIButton!
    @IBOutlet private weak var dropboxButton: UIButton!
}

//MARK:- VIEW LIFE CYCLE
//======================
extension CommonButtonPopUpVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

//MARK:- IBACTIONS
//================
extension CommonButtonPopUpVC {
    
    @IBAction func takeVideoTapped(_ sender: UIButton) {
        dismiss(animated: isAnimated) {
            self.delegate?.takeVideo()
            self.disableButton(sender)
        }
    }
    
    @IBAction func uploadDocTapped(_ sender: UIButton) {
        dismiss(animated: isAnimated) {
            self.delegate?.selectDocument()
            self.disableButton(sender)
        }
    }
    
    @IBAction func uploadFromDropboxBtnTapped(_ sender: UIButton) {
        dismiss(animated: isAnimated) {
            self.delegate?.selectDocumentFromDropbox()
            self.disableButton(sender)
        }
    }
    
    @IBAction func takePhotoTapped(_ sender: UIButton) {
        dismiss(animated: isAnimated) {
            self.delegate?.takePhoto()
        }
        disableButton(sender)
    }
    
    @IBAction func galleryTapped(_ sender: UIButton) {
        dismiss(animated: isAnimated) {
            self.delegate?.galleryButton()
        }
        disableButton(sender)
    }
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        dismiss(animated: isAnimated) {}
        disableButton(sender)
    }
}

//MARK:- PRIVATE FUNCTIONS
//========================
extension CommonButtonPopUpVC {
    
    private func initialSetup() {
        setupDefaultState()
        let _ = getButtonsArray().map({ eachButton in
            eachButton.isHidden = false
        })
        if let button = getButtonsArray().last, getButtonsArray().count > 1 {
            button.backgroundColor = AppColors.backViewGrey
        }
    }
    
    private func setupDefaultState() {
        takeVideoButton.isHidden = true
        uploadDocumentButton.isHidden = true
        takePhotoButton.isHidden = true
        galleryButton.isHidden = true
        ///
        takeVideoButton.setTitle(takeVideo, for: .normal)
        uploadDocumentButton.setTitle(uploadDocument, for: .normal)
        takePhotoButton.setTitle(takePhoto, for: .normal)
        galleryButton.setTitle(gallery, for: .normal)
        dropboxButton.setTitle(dropbox, for: .normal)
    }
    
    private func getButtonsArray() -> [UIButton] {
        let buttonArray = buttonTypeArray.map({ eachType -> UIButton in
            switch eachType {
            case .video:
                return takeVideoButton
            case .photo:
                return takePhotoButton
            case .gallery:
                return galleryButton
            case .document:
                return uploadDocumentButton
            case .dropbox:
                return dropboxButton
            }
        })
        return buttonArray
    }
}
