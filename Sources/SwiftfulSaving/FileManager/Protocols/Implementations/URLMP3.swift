//
//  URLTransformable+URL.swift
//  SwiftfulSaving
//
//  Created by Nick Sarno on 12/19/21.
//

import Foundation

// Note: URLs purposesly do NOT conform to DataTransformable.
// URLs saved to FileManager need to retain the FileManager URL. Most players, such as AVPlayer, will play from the url directly.

public extension URL {
    typealias MP3 = URLMP3
}

public struct URLMP3: URLTransformable {
    public let url: URL

    public static var fileExtension: FMFileExtension {
        .mp3
    }

    public func toData() -> Data? {
        try? Data(contentsOf: url)
    }

    public init?(url: URL) {
        self.url = url
    }
}
