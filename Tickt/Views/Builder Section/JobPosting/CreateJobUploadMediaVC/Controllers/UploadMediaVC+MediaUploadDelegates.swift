//
//  UploadMediaVC+DocumentDelegates.swift
//  Tickt
//
//  Created by S H U B H A M on 01/06/21.
//

import Foundation
import AVFoundation
import MobileCoreServices

extension CreateJobUploadMediaVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imageArray.append((image, .image, nil, "", .imageJpeg, nil, nil))
            self.setupFlowLayout()
            self.collectionViewOutlet.reloadData()
        }
        ///
        if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL, UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoUrl.path) {
            if let thumbnailImage = generateThumbnail(path: videoUrl, time: CMTimeMake(value: 0, timescale: 1)) {
                DispatchQueue.main.async {[weak self] in
                    guard let self = self else { return }
                    self.encodeVideo(videoURL: videoUrl, thumbnail: thumbnailImage)
                }
            }
        }
    }
}

extension CreateJobUploadMediaVC: UIDocumentPickerDelegate {
    
    func openDocumentPicker() {
        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF), String(kUTTypePNG), String(kUTTypeJPEG), "com.microsoft.word.doc"], in: .import)
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
                    case "jpeg", "jpg", "png":
                        if let image = UIImage(data: data) {
                            self.imageArray.append((image, .image, nil, "", .imageJpeg, nil, nil))
                        }else {
                            CommonFunctions.showToastWithMessage("Something went wrong")
                        }
                    case "txt":
                        self.imageArray.append((#imageLiteral(resourceName: "TXT-1"), .doc, nil, tempURL.absoluteString, .textPlain, nil, nil))
                    case "doc":
                        self.imageArray.append((#imageLiteral(resourceName: "DOC-1"), .doc, nil, tempURL.absoluteString, .msword, nil, nil))
                    case "pdf":
                        self.imageArray.append((#imageLiteral(resourceName: "PDF-1"), .pdf, nil, tempURL.absoluteString, .pdf, nil, nil))
                    default:
                        self.imageArray.append((#imageLiteral(resourceName: "RTF"), .doc, nil, tempURL.absoluteString, .rtf, nil, nil))
                    }
                }
                self.setupFlowLayout()
                self.collectionViewOutlet.reloadData()
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

extension CreateJobUploadMediaVC {
    
    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
        debugPrint(error?.localizedDescription ?? "")
    }
    
    func generateThumbnail(path: URL, time: CMTime) -> UIImage? {
        do {
            let asset = AVURLAsset(url: path, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error {
            debugPrint("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
    
    func encodeVideo(videoURL: URL, thumbnail: UIImage)  {
        let avAsset = AVURLAsset(url: videoURL, options: nil)
        let startDate = NSDate()
        //Create Export session
        exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetPassthrough)
        // exportSession = AVAssetExportSession(asset: composition, presetName: mp4Quality)
        //Creating temp path to save the converted video
        
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let myDocumentPath = URL(fileURLWithPath: documentsDirectory).appendingPathComponent("temp.mp4").absoluteString
        
        let documentsDirectory2 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
        let filePath = documentsDirectory2.appendingPathComponent("\(Date().toTimestamp)rendered-Video.mp4")
        deleteFile(filePath: filePath)
        
        //Check if the file already exists then remove the previous file
        if FileManager.default.fileExists(atPath: myDocumentPath) {
            do {
                try FileManager.default.removeItem(atPath: myDocumentPath)
            }
            catch let error {
                print(error)
            }
        }
        
        exportSession!.outputURL = filePath
        exportSession!.outputFileType = AVFileType.mp4
        exportSession!.shouldOptimizeForNetworkUse = true
        let start = CMTimeMakeWithSeconds(0.0, preferredTimescale: 0)
        let range = CMTimeRangeMake(start: start, duration: avAsset.duration)
        exportSession.timeRange = range
        exportSession!.exportAsynchronously(completionHandler: {() -> Void in
            switch self.exportSession!.status {
            case .failed:
                debugPrint(self.exportSession.error ?? "")
            case .cancelled:
                debugPrint("Export canceled")
            case .completed:
                let endDate = NSDate()
                let time = endDate.timeIntervalSince(startDate as Date)
                debugPrint(time)
                debugPrint("Successful!")
                debugPrint(self.exportSession.outputURL ?? "")
                let finalVideoUrl = self.exportSession.outputURL?.absoluteString ?? ""
                self.imageArray.append((thumbnail, .video, videoURL, finalVideoUrl, .videoMp4, nil, nil))
                self.mainQueue {
                    self.setupFlowLayout()
                    self.collectionViewOutlet.reloadData()
                }
            default:
                break
            }
        })
    }
    
    func deleteFile(filePath: URL) {
        guard FileManager.default.fileExists(atPath: filePath.path) else {
            return
        }
        do {
            try FileManager.default.removeItem(atPath: filePath.path)
        } catch {
            fatalError("Unable to delete file: \(error) : \(#function).")
        }
    }
}
//            UISaveVideoAtPathToSavedPhotosAlbum(videoUrl.path, self, #selector(video(_:didFinishSavingWithError:contextInfo:)), nil)
