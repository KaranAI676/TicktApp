//
//  EditProfile+DocumentPicker.swift
//  Tickt
//
//  Created by Vijay's Macbook on 30/06/21.
//

import AVKit
import MobileCoreServices

extension EditProfileDetailsBuilderVC: UIDocumentPickerDelegate, UINavigationControllerDelegate {
            
    func openQualificationVC() {
        if let selecedTrade = kAppDelegate.tradeModel?.result?.trade?.filter({$0.id == kUserDefaults.getUserTrade()}) {
            if selecedTrade.count > 0 {
                kAppDelegate.signupModel.tradeList = selecedTrade
                let qualificationVC = AnyQualificationsVC.instantiate(fromAppStoryboard: .registration)
                qualificationVC.isEdit = true
                qualificationVC.docArrayClosure = { [weak self] docArray in
                    self?.updateQualification(docArray: docArray)
                }
                mainQueue { [weak self] in
                    self?.navigationController?.pushViewController(qualificationVC, animated: true)
                }
            }
        }
    }
    
    func updateQualification(docArray: [QualificationDoc]) {
        var existingDoc: [QualificationDoc] = []
        for document in model.qualificationDoc ?? [] {
            if !docArray.contains(where: { selectedDoc in
                selectedDoc.qualificationId == document.qualificationId
            }) {
                existingDoc.append(document)
            }
        }
        model.qualificationDoc = docArray
        for document in existingDoc.reversed() {
            model.qualificationDoc?.insert(document, at: 0)
        }
        tableViewOutlet.reloadData()
    }
    
    func goToCommonPopupVC() {
       let vc = CommonButtonPopUpVC.instantiate(fromAppStoryboard: .registration)
       vc.modalPresentationStyle = .overCurrentContext
       vc.delegate = self
       vc.isAnimated = true
       vc.buttonTypeArray = [.photo, .gallery, .document]
       mainQueue { [weak self] in
           self?.navigationController?.present(vc, animated: true, completion: nil)
       }
   }
    
    func openDocumentPicker() {
        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF), String(kUTTypePNG), String(kUTTypeRTF), String(kUTTypeJPEG), String(kUTTypeText)], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        present(importMenu, animated: true, completion: nil)
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
                var mimeType = ""
                
                if let range = path.range(of: ".") {
                    let type = path[range.upperBound...]
                    switch(type) {
                    case "jpeg":
                        mimeType = "image/jpeg"
                    case "jpg":
                        mimeType = "image/jpeg"
                    case "txt":
                        mimeType = "text/plain"
                    case "png":
                        mimeType = "image/png"
                    case "doc":
                        mimeType = "application/msword"
                    case "pdf":
                        mimeType = "application/pdf"
                    default:
                        mimeType = "application/rtf"
                    }
                }
                let data = try Data(contentsOf: tempURL)
                updateTableCell(imageUrl: url, docData: data, mimeType: mimeType)
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
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateTableCell(imageUrl: Any?, docData: Data, mimeType: String) {
        var documentName = ""
        if let url = imageUrl as? URL {
            documentName = url.lastPathComponent
        } else {
            documentName = "Document"
        }
        
        let index = selectedImages.firstIndex { (data, name, index, id, mimeType) -> Bool in
            return index == currentIndex
        }
        
        if let objectIndex = index {
            selectedImages[objectIndex] = (docData, documentName, currentIndex, model.qualificationDoc?[safe: objectIndex]?.qualificationId ?? "", mimeType)
        } else {
            selectedImages.append((docData, documentName, currentIndex, model.qualificationDoc?[safe: currentIndex]?.qualificationId ?? "", mimeType))
        }

        model.qualificationDoc?[currentIndex].isUploaded = true
        tableViewOutlet.reloadSections(IndexSet(arrayLiteral: 4), with: .automatic)
    }
}
