//
//  DocumentManager.swift
//  Tickt
//
//  Created by Vijay's Macbook  on 08/03/21.
//  Copyright © 2021 Tickt. All rights reserved.
//

import UIKit

class DocumentManager {
    
    static let sharedManager : DocumentManager = {
        let instance = DocumentManager()
        return instance
    }()
    
    func saveImageToDocuementDirectory(imageName: String, image: UIImage) {
        guard let directoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            return
        }
        let fileUrl = directoryUrl.appendingPathComponent("\(imageName).jpg")
        if let data = image.jpegData(compressionQuality: 0.6), !FileManager.default.fileExists(atPath: fileUrl.path) {
            do {
                try data.write(to: fileUrl)
            } catch let error {
                Console.log(error.localizedDescription)
            }
        }
    }
    
    func getImageFromDocumentDirectory(imageName: String) -> UIImage? {
        guard let directoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            return nil
        }
        let fileUrl = directoryUrl.appendingPathComponent("\(imageName).jpg")
        do {
            let data = try Data(contentsOf: fileUrl)
            if let image = UIImage(data: data) {
                return image
            }
        } catch let error {
            Console.log(error.localizedDescription)
        }
        return nil
    }
    
    func writeDataToLogFile(data: Data, name: String) {
        guard let directoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            return
        }
        let fileUrl = directoryUrl.appendingPathComponent("\(name).txt")
        if FileManager.default.fileExists(atPath: fileUrl.path) {
            if let fileHandle = FileHandle(forWritingAtPath: fileUrl.path) {
                fileHandle.seekToEndOfFile()
                fileHandle.write(data)
                fileHandle.closeFile()
            }
        } else {
            do {
                try data.write(to: fileUrl, options: .atomic)
            } catch let error {
                Console.log(error.localizedDescription)
            }
        }
    }
    
    func readData(name: String) -> Data? {
        let docsurl = try! FileManager.default.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("Tickt")
        let myurl = docsurl.appendingPathComponent(name)
        do {
            let data = try Data(contentsOf: myurl)
            return data
        } catch let error {
            Console.log(error.localizedDescription)
        }
        return nil
    }
    
    func clearFilesWithName(name:String) {
        let docsurl = try! FileManager.default.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        do {
            let fileNames = try FileManager.default.contentsOfDirectory(atPath: docsurl.path)
            for fileName in fileNames {
                if (fileName.hasSuffix(name)) {
                    try FileManager.default.removeItem(at: docsurl.appendingPathComponent(fileName))
                }
            }
        } catch let error {
            Console.log(error.localizedDescription)
        }
    }
}
