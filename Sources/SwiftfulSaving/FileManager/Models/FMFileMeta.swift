//
//  FMFileMeta.swift
//  SwiftfulSaving
//
//  Created by Nick Sarno on 12/19/21.
//

import Foundation

struct FMFileMeta {
    let url: URL
    let lastAccessDate: Date?
    let creationDate: Date?
    let isDirectory: Bool
    let fileSize: Int

    init?(fileURL: URL, resourceKeys: Set<URLResourceKey>) {
        let meta = try? fileURL.resourceValues(forKeys: resourceKeys)
        guard let meta = meta else { return nil }
        
        self.init(
            fileURL: fileURL,
            lastAccessDate: meta.contentAccessDate,
            creationDate: meta.creationDate,
            isDirectory: meta.isDirectory ?? false,
            fileSize: meta.fileSize ?? 0)
    }
    
    init(fileURL: URL, lastAccessDate: Date?, creationDate: Date?, isDirectory: Bool, fileSize: Int) {
        self.url = fileURL
        self.lastAccessDate = lastAccessDate
        self.creationDate = creationDate
        self.isDirectory = isDirectory
        self.fileSize = fileSize
    }
    
}

extension Array where Element == FMFileMeta {
    
    func totalSize() -> Int {
        return self.reduce(into: 0, { size, meta in
            return size += meta.fileSize
        })
    }
    
}
