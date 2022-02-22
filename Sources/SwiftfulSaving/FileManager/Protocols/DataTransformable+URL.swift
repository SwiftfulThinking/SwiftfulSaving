//
//  DataTransformable+URL.swift
//  SwiftfulSaving
//
//  Created by Nick Sarno on 12/19/21.
//

import Foundation

// MARK: URL

extension URL {
    
    typealias MP3 = UrlMP3
    typealias MP4 = UrlMP4

}

// MARK: CONVENIENCE

extension URL {
    
    func mp3() -> UrlMP3 {
        UrlMP3(url: self)
    }
    
    func mp4() -> UrlMP4 {
        UrlMP4(url: self)
    }
    
}

// MARK: UrlMP4

struct UrlMP4 {
    let url: URL
}

extension UrlMP4: DataTransformable {

    static var fileExtension: FMFileExtension {
        .mp4
    }

    func toData() -> Data? {
        try? Data(contentsOf: url)
    }

    
    init?(data: Data) {
        guard let url = URL(dataRepresentation: data, relativeTo: nil) else { return nil }
        self.url = url
    }

}

struct UrlMP3 {
    let url: URL
}

extension UrlMP3: DataTransformable {

    static var fileExtension: FMFileExtension {
        .mp4
    }

    func toData() -> Data? {
        try? Data(contentsOf: url)
    }

    init?(data: Data) {
        guard let url = URL(dataRepresentation: data, relativeTo: nil) else { return nil }
        self.url = url
    }

}
