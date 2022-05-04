//
//  Qualification+DocumentPicker.swift
//  Tickt
//
//  Created by Admin on 08/04/21.
//

import UIKit
import Foundation
import MobileCoreServices

extension AnyQualificationsVC: UIDocumentPickerDelegate, UINavigationControllerDelegate {
    
    func openDocumentPicker() {
        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF), String(kUTTypePNG), String(kUTTypeRTF), String(kUTTypeJPEG), String(kUTTypeText)], in: .import)
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
                updateCollectionCell(imageUrl: url, docData: data, mimeType: mimeType)
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
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
}

