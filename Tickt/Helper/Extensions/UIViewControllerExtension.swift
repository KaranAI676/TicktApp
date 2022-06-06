//
//  UIViewControllerExtension.swift
//  Tickt
//
//  Created by Admin on 01/12/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary
import AVFoundation
import Photos
import PhotosUI
import AVKit
import MobileCoreServices

extension UIViewController: NVActivityIndicatorViewable {
    
    enum NavBtnType {
        case none
        case close
        case back
        case menu
        case backWithTitle(title:String)
        case title(title: String , color : UIColor)
        case image(image: UIImage)
    }
    
    enum NavBG {
        case image(image: UIImage)
        case bgColor(value: UIColor)
        case imageName(value: String)
        case defaultImage
        case defaultColor
    }
    
    typealias ImagePickerDelegateController = (UIViewController & UIImagePickerControllerDelegate & UINavigationControllerDelegate)
    
    func captureImagePopUp(delegate controller: ImagePickerDelegateController,
                      photoGallery: Bool = true,
                      camera: Bool = true,
                      croppingEnabled:Bool = false,
                      mediaType : [String] = [kUTTypeImage as String],
                      openCamera : Bool) {
        
        if openCamera {
            self.checkAndOpenCamera(delegate: controller, croppingEnabled: croppingEnabled, mediaType: mediaType)
        } else {
            self.checkAndOpenLibrary(delegate: controller, croppingEnabled: croppingEnabled, mediaType: mediaType)
        }
    }
    
    func checkAndOpenLibrary(delegate controller: ImagePickerDelegateController,croppingEnabled:Bool = false,mediaType : [String] = [kUTTypeImage as String]) {
        
        let authStatus = PHPhotoLibrary.authorizationStatus()
        switch authStatus {
            
        case .notDetermined:
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = controller
            imagePicker.mediaTypes = mediaType
            let sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.sourceType = sourceType
            imagePicker.allowsEditing = croppingEnabled
            imagePicker.videoMaximumDuration = 15
            
            present(imagePicker, animated: true, completion: nil)
            
        case .restricted:
            alertPromptToAllowCameraAccessViaSetting("Restricted from using library")
            
        case .denied:
            alertPromptToAllowCameraAccessViaSetting("Change privacy setting and allow access to library")
            
        case .authorized:
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = controller
            let sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.sourceType = sourceType
            imagePicker.allowsEditing = croppingEnabled
            imagePicker.mediaTypes = mediaType
            imagePicker.videoMaximumDuration = 15
            
            present(imagePicker, animated: true, completion: nil)
        default:
            printDebug("Defautl case")
        }
    }
    
    
    func checkAndOpenCamera(delegate controller: ImagePickerDelegateController, croppingEnabled:Bool = false, mediaType : [String] = [kUTTypeImage as String]) {
        
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        
        case .authorized:
                                                
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = controller
            imagePicker.mediaTypes = mediaType
            imagePicker.videoMaximumDuration = 15
            let sourceType = UIImagePickerController.SourceType.camera
            if UIImagePickerController.isSourceTypeAvailable(sourceType) {
                imagePicker.sourceType = sourceType
                imagePicker.allowsEditing = croppingEnabled
                if imagePicker.sourceType == .camera {
                    imagePicker.showsCameraControls = true
                }
                controller.present(imagePicker, animated: true, completion: nil)
            } else {
                let cameraNotAvailableText = "Camera not available"
                CommonFunctions.showToastWithMessage(cameraNotAvailableText)
            }
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { granted in
                
                if granted {
                    
                    DispatchQueue.main.async {
                        let imagePicker = UIImagePickerController()
                        imagePicker.delegate = controller
                        imagePicker.mediaTypes = mediaType
                        imagePicker.videoMaximumDuration = 15
                        
                        let sourceType = UIImagePickerController.SourceType.camera
                        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
                            
                            imagePicker.sourceType = sourceType
                            if imagePicker.sourceType == .camera {
                                imagePicker.allowsEditing = croppingEnabled
                                imagePicker.showsCameraControls = true
                            }
                            controller.present(imagePicker, animated: true, completion: nil)
                        } else {
                            let cameraNotAvailableText = "Camera not available"
                            CommonFunctions.showToastWithMessage(cameraNotAvailableText)
                        }
                    }
                }
            })
        case .restricted:
            alertPromptToAllowCameraAccessViaSetting("Restricted using camera")
            
        case .denied:
            alertPromptToAllowCameraAccessViaSetting("Change Privacy Setting And Allow Access To Camera")
        @unknown default:
            print("Unknown Cases")
        }
    }
    
    func alertPromptToAllowCameraAccessViaSetting(_ message: String,cancelHandler:(()->())? = nil,successHandler:(()->())? = nil) {
        
        let alertText = "Alert"
        let cancelText = "Cancel"
        let settingsText = "Settings"
        
        let alert = UIAlertController(title: alertText, message: message, preferredStyle: .alert)
        
        
        let settingsAction = UIAlertAction(title: settingsText, style: .default, handler: { (action) in
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
            }
            alert.dismiss(animated: true, completion: nil)
            successHandler?()
        })
        
        let cancelAction = UIAlertAction(title: cancelText, style: .cancel, handler: { (cancelAction) in
            cancelHandler?()
        })
        
        alert.addAction(cancelAction)
        alert.addAction(settingsAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    ///Adds Child View Controller to Parent View Controller
    func add(childViewController:UIViewController){
        
        self.addChild(childViewController)
        childViewController.view.frame = self.view.bounds
        self.view.addSubview(childViewController.view)
        childViewController.didMove(toParent: self)
    }
    
    ///Removes Child View Controller From Parent View Controller
    var removeFromParent:Void{
        
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    func playTheVideo(videoUrl: URL) {
        let player = AVPlayer(url: videoUrl)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
          playerViewController.player?.play()
        }
    }
    
    ///Updates navigation bar according to given values
    func updateNavigationBar(withTitle title:String? = nil, leftButton:UIBarButtonItem? = nil, rightButton:UIBarButtonItem? = nil, tintColor:UIColor? = nil, barTintColor:UIColor? = nil, titleTextAttributes: [NSAttributedString.Key : Any]? = nil){
        
        self.navigationController?.isNavigationBarHidden = false
        if let tColor = barTintColor{
            self.navigationController?.navigationBar.barTintColor = tColor
        }
        if let tColor = tintColor{
            self.navigationController?.navigationBar.tintColor = tColor
        }
        if let button = leftButton{
            self.navigationItem.leftBarButtonItem = button;
        }
        if let button = rightButton{
            self.navigationItem.rightBarButtonItem = button;
        }
        if let ttle = title{
            self.title = ttle
        }
        if let ttleTextAttributes = titleTextAttributes{
            self.navigationController?.navigationBar.titleTextAttributes =   ttleTextAttributes
        }
    }
    
    func setNavigationBar(withLogo isLogoShown: Bool = true,
                          andLeftButton leftBtnType: NavBtnType = .none,
                          andRightButton rightBtnType: NavBtnType = .none,
                          withBg bg: NavBG = .defaultColor) {
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.isNavigationBarHidden = false
        
        if isLogoShown {
            let logo = UIImage(named: "nav_bar_logo")
            let imageView = UIImageView(image:logo)
            self.navigationItem.titleView = imageView
        }
        
        //Set Navigation bar background color
        switch bg {
        case let .image(image: image):
            navigationController?.navigationBar.setBackgroundImage(image, for: .default)
            
        case let .bgColor(value: color):
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.tintColor = UIColor.clear
            navigationController?.navigationBar.barTintColor = color
            navigationController?.view.backgroundColor = UIColor.clear
            navigationController?.view.tintColor = UIColor.clear
            navigationController?.navigationBar.isTranslucent = (color == UIColor.clear)
            
        case let .imageName(value: imageName):
            navigationController?.navigationBar.setBackgroundImage(UIImage(named: imageName), for: .default)
            
        case .defaultColor:
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.tintColor = UIColor(hex: "#333333")
            navigationController?.navigationBar.barTintColor = UIColor.white
            
        case .defaultImage:
            navigationController?.navigationBar.setBackgroundImage(UIImage(named: ""), for: .default)
        }
        
        let navBarLeftButtons: [UIBarButtonItem]? = getNavBtn(btnType: leftBtnType)
        let navBarRightButtons: [UIBarButtonItem]? = getNavBtn(btnType: rightBtnType)
        
        navigationItem.leftBarButtonItems = navBarLeftButtons
        navigationItem.rightBarButtonItems = navBarRightButtons
    }
    
    func getNavBtn(btnType: NavBtnType) -> [UIBarButtonItem]? {
        
        var navBarButtons: [UIBarButtonItem]?
        
        let backButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named:"ic_back"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(backAction(sender:)))
        backButton.imageInsets = UIEdgeInsets.init(top: backButton.imageInsets.top, left: backButton.imageInsets.left - 5, bottom: backButton.imageInsets.bottom, right: backButton.imageInsets.right)
        
        let closeButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named:"ic_back"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(closeAction(sender:)))
        closeButton.imageInsets = UIEdgeInsets.init(top: closeButton.imageInsets.top, left: closeButton.imageInsets.left - 5, bottom: closeButton.imageInsets.bottom, right: closeButton.imageInsets.right)
        
        
        let imageButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_list"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(imageBtnAction(sender:)))
        imageButton.imageInsets = UIEdgeInsets.init(top: imageButton.imageInsets.top, left: imageButton.imageInsets.left - 5, bottom: imageButton.imageInsets.bottom, right: imageButton.imageInsets.right)
        
        let titleButton: UIBarButtonItem = UIBarButtonItem(title: nil, style: .done, target: self, action:  #selector(titleBtnAction(sender:)))
        
        let customButton = UIButton(type: .custom)
        customButton.setImage(UIImage(named:"ic_back"), for: .normal)
        customButton.addTarget(self, action: #selector(backAction(sender:)), for: .touchUpInside)
        customButton.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 20.0)
        customButton.setTitleColor(UIColor(hex: "#333333"), for: .normal)
        customButton.frame = CGRect(x: 0, y: 0, width: 300, height: 44.0)
        customButton.titleEdgeInsets = UIEdgeInsets.init(top: customButton.titleEdgeInsets.top, left: customButton.titleEdgeInsets.left + 16, bottom: customButton.titleEdgeInsets.bottom, right: customButton.titleEdgeInsets.right)
        customButton.contentHorizontalAlignment = .left
        let backButtonWithTitle = UIBarButtonItem(customView: customButton)
        
        switch btnType {
        case .back:
            navBarButtons = [backButton]
            
        case .close:
            navBarButtons = [closeButton]
            
        case .backWithTitle(let title):
            customButton.setTitle(title, for: .normal)
            navBarButtons = [backButtonWithTitle]
            
        case .image(let image):

            let imageSetting = UIImageView(image: image)
            imageSetting.image = imageSetting.image!.withRenderingMode(.alwaysOriginal)
            imageSetting.tintColor = UIColor.clear
            
            imageButton.image = imageSetting.image
            navBarButtons = [imageButton]
            
        case .title(let title, let color):
            titleButton.title = title
            titleButton.tintColor = color
            navBarButtons = [titleButton]
            
        default:
            navBarButtons?.removeAll()
        }
        
        return navBarButtons
    }
    
    @objc func backAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func closeAction(sender: UIButton) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func imageBtnAction(sender: UIButton) {
        //Defination will be in child class
    }
    
    @objc func titleBtnAction(sender: UIButton) {
        //Defination will be in child class
    }
    
    //function to pop the target from navigation Stack
    @objc func pop(animated:Bool = true) {
        _ = self.navigationController?.popViewController(animated: animated)
    }
    
    func popToSpecificViewController(atIndex index:Int, animated:Bool = true) {
        
        if let navVc = self.navigationController, navVc.viewControllers.count > index{
            
            _ = self.navigationController?.popToViewController(navVc.viewControllers[index], animated: animated)
        }
    }
    
//    func showAlert( title : String = "", msg : String,_ completion : (()->())? = nil) {
//        
//        let alertViewController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
//        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { (action : UIAlertAction) -> Void in
//            
//            alertViewController.dismiss(animated: true, completion: nil)
//            completion?()
//        }
//        okAction.setValue(AppColors.themeBlue, forKey: "titleTextColor")
//        alertViewController.addAction(okAction)
//        
//        self.present(alertViewController, animated: true, completion: nil)
//    }
        
    func showAlert(alert:String, msg: String , done:String, cancel:String,animated : Bool = true , success: @escaping (Bool)->Void){
        let alertController = UIAlertController (title: alert, message: msg, preferredStyle: .alert)
        let doneAction = UIAlertAction(title:done, style: .default) { (_) -> Void in
            success(true)
        }
        let cancelAction = UIAlertAction(title: cancel, style: .destructive) { (_) in
            success(false)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(doneAction)
        self.present(alertController, animated: animated, completion: nil);
    }
    
    func showAlert(_ title: String = "", message: String?, style: UIAlertController.Style = .alert, withOk showOk: Bool = true, withCancel showCancel: Bool = true, withAnimation animated: Bool = true, withCustomAction alertActions: [UIAlertAction] = [UIAlertAction]()) -> Void {
        
        guard let message = message else {
            return
        }
        
        let alert = UIAlertController(title:title, message: message, preferredStyle: style)
        for alertAction in alertActions {
            alert.addAction(alertAction)
        }
        
        if style == .alert {
            
            if showOk {
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            }
        }
        else {
            if showCancel {
                alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: nil))
            }
        }
        
        self.present(alert, animated: animated, completion: nil);
    }
    
    func add(childViewController: UIViewController, containerView: UIView? = nil) {
        let mainView: UIView = containerView ?? self.view
        self.addChild(childViewController)
        childViewController.view.frame = mainView.bounds
        mainView.addSubview(childViewController.view)
        childViewController.didMove(toParent: self)
    }
    
    /// Start Loader
    func startNYLoader() {
        startAnimating(CGSize(width: 50, height: 50), type: NVActivityIndicatorType.ballRotateChase, color: AppColors.themeYellow, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5))
    }
    
    
    func showSettingsAlert(message:String?,completion:((_ response:Bool)->Void)?){
        
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        
        let alertActionSettings = UIAlertAction(title:  "Settings", style: UIAlertAction.Style.default) { (action:UIAlertAction) in
            UIApplication.openSettingsApp
        }
        let alertActionCancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) { (action:UIAlertAction) in
            
            completion?(false)
        }
        alertController.addAction(alertActionCancel)
        alertController.addAction(alertActionSettings)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func visibleViewController() -> UIViewController {
        
        if let presented = self.presentedViewController {
            return presented.visibleViewController()
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.visibleViewController() ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.visibleViewController() ?? tab
        }
        
        return self
    }
    
    func isModal() -> Bool {
           if((self.presentingViewController) != nil) {
               return true
           }
           
           if(self.presentingViewController?.presentedViewController == self) {
               return true
           }
           
           if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController {
               return true
           }
           if self.tabBarController?.presentingViewController is UITabBarController {
               return true
           }
           return false
       }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}


// MARK: - UInavigationViewController Extension
//======================================================
//extension UINavigationController {
//    public func hasViewController(ofKind kind: AnyClass) -> UIViewController? {
//        return self.viewControllers.first(where: {$0.isKind(of: kind)})
//    }
//}
