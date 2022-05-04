//
//  LeaveVouchBuilderVC+Delegates.swift
//  Tickt
//
//  Created by S H U B H A M on 20/06/21.
//

import Foundation
import MobileCoreServices

extension LeaveVouchBuilderVC: CommonButtonDelegate {
    
    func takePhoto() {}
    
    func galleryButton() {}
    
    func selectDocument() {
        openDocumentPicker()
    }
}

extension LeaveVouchBuilderVC: UIDocumentPickerDelegate {
    
    func openDocumentPicker() {
        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF), "com.microsoft.word.doc"], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let url = url
        let isSecuredURL = url.startAccessingSecurityScopedResource() == true
        let coordinator = NSFileCoordinator()
        var error: NSError? = nil
        
        coordinator.coordinate(readingItemAt: url, options: [], error: &error) { (url) -> Void in
            var tempURL = URL(fileURLWithPath: NSTemporaryDirectory())
            tempURL.appendPathComponent(url.lastPathComponent)
            do {
                if FileManager.default.fileExists(atPath: tempURL.path) {
                    try FileManager.default.removeItem(atPath: tempURL.path)
                }
                try FileManager.default.moveItem(atPath: url.path, toPath: tempURL.path)
                                
                let path = url.lastPathComponent
                let data = try Data(contentsOf: tempURL)
                
                if let range = path.range(of: ".") {
                    let type = path[range.upperBound...]
                    switch(type) {
                    case "txt":
                        self.model.recommendation = (image: #imageLiteral(resourceName: "TXT-1"), finalUrl: tempURL.absoluteString, data: data, type: .doc, mimeType: .textPlain)
                    case "doc":
                        self.model.recommendation = (image: #imageLiteral(resourceName: "DOC-1"), finalUrl: tempURL.absoluteString, data: data, type: .doc, mimeType: .msword)
                    case "pdf":
                        self.model.recommendation = (image: #imageLiteral(resourceName: "PDF-1"), finalUrl: tempURL.absoluteString, data: data, type: .pdf, mimeType: .pdf)
                    default:
                        self.model.recommendation = (image: #imageLiteral(resourceName: "RTF"), finalUrl: tempURL.absoluteString, data: data, type: .doc, mimeType: .rtf)
                    }
                }
                tableViewOutlet.reloadData()
            } catch {
                print(error.localizedDescription)
            }
          }
        if (isSecuredURL) {
            url.stopAccessingSecurityScopedResource()
        }
    }
    
    public func documentMenu(_ documentMenu: UIDocumentPickerViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        documentPicker.present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        controller.dismiss(animated: true, completion: nil)
    }
}

extension LeaveVouchBuilderVC: LeaveVoucheBuilderVMDelegate {
    
    func didGetJobsSuccess(model: JobListingBuilderModel) {
        jobModel = model.result
        tableViewOutlet.reloadData()
    }
    
    func success(model: VouchAddedModel) {
        delegate?.getNewlyAddedVouch(model: model.result)
        pop()
    }
    
    func failure(message: String) {
        CommonFunctions.showToastWithMessage(message)
    }
}
