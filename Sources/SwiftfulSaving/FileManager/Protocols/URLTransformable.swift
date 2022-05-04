//
//  DataTransformable.swift
//  SwiftfulSaving
//
//  Created by Nick Sarno on 12/19/21.
//

import Foundation

/// An object that conforms to URLTransformable can be transformed to Data and initialized from a URL. This is used to save/read objects from the FileManager.
public protocol URLTransformable {
    
    /// Convert object to Data
    func toData() -> Data?
    
    /// File extension for URL
    static var fileExtension: FMFileExtension { get }
    
    /// Initialize object from URL
    init?(url: URL)    
}
