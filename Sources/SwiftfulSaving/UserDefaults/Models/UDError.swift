//
//  File.swift
//  
//
//  Created by Nick Sarno on 2/22/22.
//

import Foundation

enum UDError: LocalizedError {
    
    // Fail to retrieve object from UserDefaults
    case objectNotFound
    // Fail to convert saved object to requested type
    case invalidDataType
    
    var errorDescription: String {
        switch self {
        case .objectNotFound: return "Fail to retrieve object from UserDefaults."
        case .invalidDataType: return "Fail to convert saved object to requested type."
        }
    }
}
