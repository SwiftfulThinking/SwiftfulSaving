//
//  FMFileExtension.swift
//  SwiftfulSaving
//
//  Created by Nick Sarno on 12/19/21.
//

import Foundation

public enum FMFileExtension: CaseIterable {
    /// Save jpg images with .jpg extension
    case jpg
    /// Save png images with .png
    case png
    /// Save mp4 urls with .mp4
    case mp4
    /// Save mp3 urls with .mp3
    case mp3
    /// Save codable types with .txt (Saved as a text document)
    case txt
    /// Save using a custom file extension. Only certain Strings can be used as a file extension. Use with caution.
    case other(ext: String)
    
    var fileExtension: String {
        switch self {
        case .jpg: return ".jpg"
        case .png: return ".png"
        case .mp4: return ".mp4"
        case .mp3: return ".mp3"
        case .txt: return ".txt"
        case .other(ext: let ext): return ext
        }
    }
    
    public static let allCases: [FMFileExtension] = [.jpg, .png, .mp4, .mp3, .txt]
}
