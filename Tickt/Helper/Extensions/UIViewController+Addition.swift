//
//  UIViewController+Extension.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 15/11/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//

import UIKit
import PDFKit

extension UIViewController {
    
    class var storyboardID : String {
        return "\(self)"
    }
    
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
    
    func delay(time:TimeInterval,completionHandler: @escaping ()->()) {
        let when = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: when) {
            completionHandler()
        }
    }
    
    func handleSuccess<T: Decodable> (data: Any) -> T? {
        if let dataObject = data as? [String : Any] {
            do {
                let data = try JSONSerialization.data(withJSONObject: dataObject, options: .prettyPrinted)
                let decoder = JSONDecoder()                
                do {
                    let data = try decoder.decode(T.self, from: data)
                    return data
                } catch let DecodingError.typeMismatch(type, context) {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.keyNotFound(key, context){
                    print("mismatch:", context.debugDescription)
                    print("key:", key)
                } catch {
                    Console.log("Parsing Error \(error)")
                }
                
            } catch {
                Console.log(error.localizedDescription)
                CommonFunctions.showToastWithMessage(error.localizedDescription)
            }
        } else {
            CommonFunctions.showToastWithMessage("Something went wrong")
        }
        return nil
    }
    
    func handleFailure(error: Error?) {
        if let error = error {
            mainQueue {
                CommonFunctions.showToastWithMessage(error.localizedDescription)
            }
        }
    }
    
    func endEditing() {
        mainQueue { [weak self] in
            self?.view.endEditing(true)
        }
    }

    func loadView<T: UIView>() -> T? {
        if let view = Bundle.main.loadNibNamed("\(T.classForCoder())", owner: self, options: nil)?.first as? T {
            return view
        }
        return nil
    }
    
    func showAlertWithOneAction(title: String?, message: String, firstAction: String, secondAction: String = "Cancel", preferredStyle: UIAlertController.Style ,completionHandler:@escaping (_ status: Bool)->()) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let action = UIAlertAction(title: firstAction, style: .default) { (action) in
            completionHandler(true)
        }
        let cancelAction = UIAlertAction(title: secondAction.localized(), style: .cancel) { (action) in
            completionHandler(false)
        }
        alertController.addAction(action)
        alertController.addAction(cancelAction)
        DispatchQueue.main.async { [weak self] in
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showDefaultAlert(title: String, message: String, preferredStyle: UIAlertController.Style) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let cancelAction = UIAlertAction(title: "Ok".localized(), style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        DispatchQueue.main.async { [weak self] in
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func mainQueue(completion: @escaping ()->()) {
        DispatchQueue.main.async {
            completion()
        }
    }
    
    func disableButton(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        delay(time: 1.0) {
            sender.isUserInteractionEnabled = true
        }
    }
    
    func openShareSheet(shareContent: String, title: String) {
        let activityViewController = UIActivityViewController(activityItems: [shareContent], applicationActivities: [])
        activityViewController.popoverPresentationController?.sourceView = view
        activityViewController.setValue(title, forKey: "subject")
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop]
        mainQueue { [weak self] in
            self?.present(activityViewController, animated: true)
        }
    }
}

extension UIViewController {

    func generatePdfThumbnail(of thumbnailSize: CGSize , for documentUrl: URL, atPage pageIndex: Int) -> UIImage {
        let pdfDocument = PDFDocument(url: documentUrl)
        let pdfDocumentPage = pdfDocument?.page(at: pageIndex)
        return pdfDocumentPage?.thumbnail(of: thumbnailSize, for: PDFDisplayBox.trimBox) ?? #imageLiteral(resourceName: "PDF")
    }
}
