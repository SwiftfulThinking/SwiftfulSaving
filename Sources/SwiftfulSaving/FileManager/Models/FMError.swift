//
//  FMError.swift
//  SwiftfulSaving
//
//  Created by Nick Sarno on 12/19/21.
//

import Foundation

enum FMError: LocalizedError {
    
    // Fail to retrieve object from NSCache
    case objectNotFoundInCache
    // Fail to retrieve file from URL
    case fileNotFound
    // Fail to retrieve directory from URL
    case directoryNotFound
    // Fail to create URL for path
    case invalidURL
    // Fail to convert file to Data
    case noData
    // Attempt to save a value type that is not supported
    case notSupported
    // Fail to create cache space for object
    case failedToCleanCache(directory: URL, maximumLimit: Int, availableSize: Int, sizeRequested: Int, urlsDeleted: [URL], urlsUnableToDelete: [URL])
    // File larger than cache's max limit
    case fileTooLarge(maximumLimit: Int, sizeRequested: Int)
    
    var errorDescription: String {
        switch self {
        case .objectNotFoundInCache: return "Fail to retrieve object from NSCache"
        case .fileNotFound: return "Fail to retrieve file from URL."
        case .directoryNotFound: return "Fail to retrieve directory from URL."
        case .invalidURL: return "Fail to create URL for path."
        case .noData: return "Fail to convert file to Data."
        case .notSupported: return "Attempt to save a value type that is not supported"
        case .failedToCleanCache(directory: let directory, maximumLimit: let max, availableSize: let available, sizeRequested: let requested, urlsDeleted: let deleted, urlsUnableToDelete: let unableToDelete): return
            """
            ** WARNING **
            
                There was a severe problem managing the size of the DreamCacher.
                - Directory: \(directory.path)
                - Maximum Limit: \(max)
                - Available Limit: \(available)
                - Requested Limit: \(requested)
                - URLs successfully deleted at:
                    \(deleted)
                - URLs failed to delete at:
                    \(unableToDelete)
                                
            ** WARNING **
            """
        case .fileTooLarge(maximumLimit: let max, sizeRequested: let requested):
            return "File size (\(max)) is larger than the cache's maximum limit (\(requested))"
        }
    }
}
