//
//  File.swift
//  
//
//  Created by Nick Sarno on 2/23/22.
//

import Foundation

enum CDError: LocalizedError {

    // Fail to convert Entity back to object T(from: entity)
    case failedToConvertToObject
    
    var errorDescription: String {
        switch self {
        case .failedToConvertToObject: return "Fail to convert Entity back to object T(from: entity)."
        }
    }
}
