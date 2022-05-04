//
//  File.swift
//  
//
//  Created by Nick Sarno on 5/3/22.
//

import Foundation

// Note: URLs purposesly do NOT conform to DataTransformable.
// URLs saved to FileManager need to retain the FileManager URL. Most players, such as AVPlayer, will play from the url directly.

public extension URL {
    typealias MP4 = URLMP4
}

public struct URLMP4: URLTransformable {
    public let url: URL
    
    public static var fileExtension: FMFileExtension {
        .mp4
    }

    public func toData() -> Data? {
        try? Data(contentsOf: url)
    }

    public init?(url: URL) {
        self.url = url
    }
}
