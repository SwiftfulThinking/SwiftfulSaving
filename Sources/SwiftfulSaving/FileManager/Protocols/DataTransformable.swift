//
//  DataTransformable.swift
//  SwiftfulSaving
//
//  Created by Nick Sarno on 12/19/21.
//

import Foundation

public protocol DataTransformable {
    
    // Convert object to Data
    func toData() -> Data?
    
    // File extension for URL
    static var fileExtension: FMFileExtension { get }
    
    // Initialize object from Data
    init?(data: Data)
}

