//
//  DataTransformable.swift
//  SwiftfulSaving
//
//  Created by Nick Sarno on 12/19/21.
//

import Foundation

public protocol URLTransformable {
    
    /// Convert object to Data
    func toData() -> Data?
    
    /// File extension for URL
    static var fileExtension: FMFileExtension { get }
    
    /// Initialize object from URL
    init?(url: URL)
    
    /// Determines if object can be stored in NSCache
    static var canBeCached: Bool { get }
}
