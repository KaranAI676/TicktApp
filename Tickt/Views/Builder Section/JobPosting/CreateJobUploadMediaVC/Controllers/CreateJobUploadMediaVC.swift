//
//  CreateJobUploadMediaVC.swift
//  Tickt
//
//  Created by S H U B H A M on 26/03/21.
//

import UIKit
import AVKit
import AVFoundation
import TagCellLayout
import MobileCoreServices
import SwiftyDropbox

class CreateJobUploadMediaVC: BaseVC {
    
    //MARK:- IB Outlets
    /// Nav Bar
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    ///
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var collectionViewOutlet: UICollectionView!
    /// Buttons
    @IBOutlet weak var continueButton: UIButton!
    
    //MARK:- Variables
    var maxMediaLimit: Int = 8
    var maxImagesLimit: Int = 6
    var maxVideosLimit: Int = 2
    ///
    var imageArray = [UploadMediaObject]()
    var viewModel = CreateJobUploadMediaVM()
    var cellSize: CGSize = CGSize(width: 112 + 20, height: 112)
    var screenType: ScreenType = .creatingJob
    ///
    var thumbnailImages: [UIImage] = []
    var finalVideoUrl = ""
    var exportSession: AVAssetExportSession!
//    let client = DropboxClientsManager.authorizedClient
//    let client = DropboxClient(accessToken: "sl.BBl_Arm50F2uXzlV0JFlVaaqeiHMDvKxk_ufOD-_i91teZ3uoxxw_F2B79UUijeJ4FS4AMhLAv6opLm0DgzMjPXlzluY0qTqV1_mR4u4JDU-8BJ4s244cHaRUF5tEl42nm4SNAk")
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Loader.hide()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.darkContent
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case backButton:
            self.pop()
        case continueButton:
            if validate() {
                self.viewModel.uploadImages(imagesArray: self.imageArray)
            }else {
                self.screenType == .edit ? self.pop() : self.goToPreviewVC()
            }
        default:
            break
        }
        disableButton(sender)
    }
}

//MARK:- Private Methods
extension CreateJobUploadMediaVC {
    
    private func initialSetup() {
        maxMediaLimit = maxImagesLimit + maxVideosLimit
        self.viewModel.delegate = self
        if screenType == .edit || screenType == .republishJob || screenType == .editQuoteJob {
            self.imageArray = kAppDelegate.postJobModel?.mediaImages ?? []
            self.collectionViewOutlet.reloadData()
        }
        self.setupCollectionView()
//        NotificationCenter.default.addObserver(self, selector: #selector(openDocumentViewer(_:)), name: NotificationName.openDocumentViewer, object: nil)
    }
    
    private func setupCollectionView() {
        self.collectionViewOutlet.registerCell(with: ImageViewCollectionCell.self)
        self.collectionViewOutlet.delegate = self
        self.collectionViewOutlet.dataSource = self
        self.collectionViewOutlet.showsVerticalScrollIndicator = false
        self.collectionViewOutlet.showsHorizontalScrollIndicator = false
        self.setupFlowLayout()
    }
    
    func setupFlowLayout() {
        let layout = imageArray.isEmpty ? TagCellLayout(alignment: .center, delegate: self) : TagCellLayout(alignment: .left, delegate: self)
        collectionViewOutlet.collectionViewLayout = layout
    }
    
    private func goToCommonPopupVC() {
        let vc = CommonButtonPopUpVC.instantiate(fromAppStoryboard: .registration)
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        vc.isAnimated = true
        var buttonArray: [CommonButtonPopUpVC.ButtonType] = []
        if getMediaCount().video {               //1
            buttonArray.append(.video)
        }
        if getMediaCount().images {              //2
            buttonArray.append(.photo)
        }
        buttonArray.append(.gallery)             //3
        if getMediaCount().images {
            buttonArray.append(.document)        //4
        }
        vc.buttonTypeArray = buttonArray
        mainQueue { [weak self] in
            self?.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    func getMediaCount() -> (images: Bool, video: Bool) {
        let videoCount = imageArray.filter({$0.type == .video}).count
        let imageCount = abs(imageArray.count - videoCount)
        return (imageCount < maxImagesLimit, videoCount < maxVideosLimit)
    }
    
    private func getMediaType() -> [String] {
        var mediaType: [String] = []
        if getMediaCount().images {
            mediaType.append(kUTTypeImage as String)
        }
        if getMediaCount().video {
            mediaType.append(kUTTypeMovie as String)
        }
        return mediaType
    }
    
    private func goToPreviewVC() {
        let vc = CreatingJobPreviewVC.instantiate(fromAppStoryboard: .jobPosting)
        if ((kAppDelegate.postJobModel?.isQuoteJob) != nil){
            if screenType == .editQuoteJob{
                vc.isJobRepublishing = screenType == .editQuoteJob
                vc.isquoteJobEdit = true
            }else{            }
        }else{
            vc.isJobRepublishing = screenType == .republishJob
        }
        self.push(vc: vc)
    }
    
    @objc func openDocumentViewer(_ notification: Notification) {
//        openDocumentPicker()
    }
}


//MARK:- CollectionView: Delagates
extension CreateJobUploadMediaVC: CollectionDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count == 0 ? 1 : (imageArray.count < maxMediaLimit ? imageArray.count + 1 : imageArray.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: ImageViewCollectionCell.self, indexPath: indexPath)
        
        if imageArray.isEmpty || indexPath.row == imageArray.count {
            cell.collectionView = collectionView
            cell.imageViewOutlet.image = #imageLiteral(resourceName: "importPlaceholder")
            cell.crossButton.isHidden = true
            cell.playButton.isHidden = true
        }
        else /*if screenType == .republishJob*/ {
            cell.collectionView = collectionView
            cell.crossButton.isHidden = false
            cell.playButton.isHidden = !(imageArray[indexPath.row].type == .video)
            
            switch imageArray[indexPath.row].type {
            case .image:
                if let url = imageArray[indexPath.row].genericUrl {
                    cell.imageViewOutlet.sd_setImage(with: URL(string: url), placeholderImage: nil, options: .highPriority)
                }else {
                    cell.imageViewOutlet.image = imageArray[indexPath.row].image
                }
            case .video:
                if let url = imageArray[indexPath.row].genericThumbnail {
                    cell.imageViewOutlet.sd_setImage(with: URL(string: url), placeholderImage: nil, options: .highPriority)
                }else {
                    cell.imageViewOutlet.image = imageArray[indexPath.row].image
                }
            case .doc, .pdf:
                cell.imageViewOutlet.image = imageArray[indexPath.row].image
            }
        }
//        else {
//            cell.collectionView = collectionView
//            cell.crossButton.isHidden = false
//            cell.playButton.isHidden = !(imageArray[indexPath.row].type == .video)
//            cell.imageViewOutlet.image = imageArray[indexPath.row].image
//        }
        ///
        cell.crossButtonClosure = { [weak self] (index) in
            guard let self = self else { return }
            self.imageArray.remove(at: index.row)
            self.setupFlowLayout()
            collectionView.reloadData()
        }
        cell.playButtonClosure = { [weak self] (index) in
            guard let self = self else { return }
            if self.imageArray[index.row].videoUrl.isNotNil, let videoUrl = self.imageArray[index.row].videoUrl {
                self.playTheVideo(videoUrl:  videoUrl)
            }else if self.imageArray[index.row].genericUrl.isNotNil, let urlString = self.imageArray[index.row].genericUrl, let url = URL(string: urlString) {
                self.playTheVideo(videoUrl: url)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if imageArray.isEmpty || indexPath.row == imageArray.count {
            self.goToCommonPopupVC()
            return
        }else {
            CommonFunctions.openMedia(self, mediaTypes: imageArray[indexPath.row].type, url: imageArray[indexPath.row].finalUrl, image: imageArray[indexPath.row].image, genericUrl: imageArray[indexPath.row].genericUrl)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return imageArray.count == 0 ? CGSize(width: self.cellSize.width, height: self.cellSize.height+10) : self.cellSize
    }
}

extension CreateJobUploadMediaVC: CommonButtonDelegate {
    
    func takeVideo() {
        captureImagePopUp(delegate: self, croppingEnabled: false, mediaType: [kUTTypeMovie as String], openCamera: true)
    }
    
    func takePhoto() {
        captureImagePopUp(delegate: self, croppingEnabled: false, openCamera: true)
    }
    
    func galleryButton() {
        captureImagePopUp(delegate: self, croppingEnabled: false, mediaType: getMediaType(), openCamera: false)
    }
    
    func selectDocument() {
        openDocumentPicker()
    }
    
    func selectDocumentFromDropbox() {
        
        //account_info.read //files.content.read
        let scopeRequest = ScopeRequest(scopeType: .user, scopes: ["account_info.read"], includeGrantedScopes: false)
        DropboxClientsManager.authorizeFromControllerV2(
            UIApplication.shared,
            controller: self,
            loadingStatusDelegate: nil,
            openURL: { (url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil) },
            scopeRequest: scopeRequest
        )

    }
    
//    func downloadUrlFromDropbox() {
//        let fileManager = FileManager.default
//        let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let destURL = directoryURL.appendingPathComponent("myTestFile")
//        let destination: (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
//            return destURL
//        }
//        client.files.download(path: "/test/path/in/Dropbox/account", overwrite: true, destination: destination)
//            .response { response, error in
//                if let response = response {
//                    print(response)
//                } else if let error = error {
//                    print(error)
//                }
//            }
//            .progress { progressData in
//                print(progressData)
//            }
//    }
}



extension CreateJobUploadMediaVC: TagCellLayoutDelegate {

    func tagCellLayoutTagSize(layout: TagCellLayout, atIndex index: Int) -> CGSize {
        return CGSize(width: self.cellSize.width, height: self.cellSize.height)
    }
    
    func textSize(text: String, font: UIFont, collectionView: UICollectionView) -> CGSize {

        return self.cellSize
    }
}

//MARK:- Validate
extension CreateJobUploadMediaVC {
    
    private func validate() -> Bool {
        if imageArray.isEmpty {
            kAppDelegate.postJobModel?.mediaImages = []
            kAppDelegate.postJobModel?.mediaUrls = []
            return false
        }
        return true
    }
}

extension CreateJobUploadMediaVC: CreateJobUploadMediaDelegate {
    
    func success(urls: [MediaUploadableObject]) {
        CommonFunctions.hideActivityLoader()
        ///
        kAppDelegate.postJobModel?.mediaUrls = urls
        kAppDelegate.postJobModel?.mediaImages = imageArray
        if screenType == .edit {
            self.pop()
            return
        }
        self.goToPreviewVC()
    }
    
    func failure(error: String) {
        CommonFunctions.hideActivityLoader()
        CommonFunctions.showToastWithMessage(error)
    }
}
