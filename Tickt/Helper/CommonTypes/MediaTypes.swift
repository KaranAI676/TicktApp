//
//  MediaTypes.swift
//  Tickt
//
//  Created by S H U B H A M on 26/07/21.
//

import Foundation

enum MediaTypes: Int {
    case image = 1
    case video = 2
    case doc = 3
    case pdf = 4
}

enum MimeTypes: String {
    
    case imageJpeg = "image/jpeg"
    case videoMp4 = "video/mp4"
    case msword = "application/msword"
    case pdf = "application/pdf"
    case textPlain = "text/plain"
    case rtf = "application/rtf"
    
    var _extension: String {
        switch self {
        case .imageJpeg:
            return ".jpeg"
        case .videoMp4:
            return ".mp4"
        case .msword:
            return ".doc"
        case .pdf:
            return ".pdf"
        case .textPlain:
            return ".txt"
        case .rtf:
            return ".rtf"
        }
    }
}
