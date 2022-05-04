//
//  File.swift
//  
//
//  Created by Nick Sarno on 5/3/22.
//

import Foundation

/// An object that conforms to URLTransformable can be transformed to Data and initialized from Data. This is used to save/read objects from NSCache (via NSData).
public protocol DataTransformable {
    
    /// Convert object to Data
    func toData() -> Data?
        
    /// Initialize object from Data
    init?(data: Data)
}
