//
//  URLTransformable+URL.swift
//  SwiftfulSaving
//
//  Created by Nick Sarno on 12/19/21.
//

import Foundation

// MARK: URL

public extension URL {
    
    typealias MP3 = UrlMP3
    typealias MP4 = UrlMP4

}

// MARK: CONVENIENCE

//public extension URL {
//    
//    func mp3() -> UrlMP3 {
//        UrlMP3(url: self)
//    }
//    
//    func mp4() -> UrlMP4 {
//        UrlMP4(url: self)
//    }
//    
//}

// MARK: UrlMP4

public struct UrlMP4: URLTransformable {
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

    public static let canBeCached: Bool = false

}

public struct UrlMP3: URLTransformable {
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

    public static let canBeCached: Bool = false
}
