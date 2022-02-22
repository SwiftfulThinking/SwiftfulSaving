//
//  FileManagerDirectory.swift
//  SwiftfulSaving
//
//  Created by Nick Sarno on 12/10/21.
//

import Foundation

// MARK: INIT

public struct FMDirectory: Hashable {
    
    private let manager: FileManager = FileManager()
    let directory: FileManager.SearchPathDirectory
    let limit: Int

    init(directory: FileManager.SearchPathDirectory, limitInMB: Double? = nil) {
        self.directory = directory
        self.limit = max(0, Int(limitInMB?.convertingMBToBytes ?? 0))
    }
    
    // Hashable
    // If two structs are the same Directory
    public func hash(into hasher: inout Hasher) {
        hasher.combine(directory.rawValue.description)
    }
    
    var name: String {
        directory.name
    }
}

// MARK: URLs

extension FMDirectory {
    
    /// URL for Directory
    func url() throws -> URL {
        guard var url = manager.urls(for: .cachesDirectory, in: .userDomainMask).first else { throw FMError.invalidURL }
        url.appendPathComponent("FMFolders")
        return url
    }
    
    /// Check if a URL exists within FileManager
    func urlExists(url: URL) -> Bool {
        manager.fileExists(atPath: url.path)
    }
    
    /// Get metadata for all URLs within Directory
    fileprivate func metadataForUrls(inDirectoryURL url: URL) throws -> [FMFileMeta] {
        let urlResourceKeys: Set<URLResourceKey> = [.fileSizeKey, .contentAccessDateKey, .isDirectoryKey]

        guard let urls = manager.enumerator(at: url, includingPropertiesForKeys: Array(urlResourceKeys))?.allObjects as? [URL] else {
            throw FMError.directoryNotFound
        }
        return urls.compactMap({ FMFileMeta(fileURL: $0, resourceKeys: urlResourceKeys) })
    }

}

// MARK: WRITE

extension FMDirectory {
    
    /// Check sizeRequested against Directory limit
    func manageDirectorySize(sizeRequested: Int) throws {
        // 0 means no limit was set!
        guard limit > 0 else { return }

        do {
            // Get directory URL
            let url = try url()
            
            // Clear room for sizeRequested as needed
            try manageSize(url: url, sizeLimit: limit, sizeRequested: sizeRequested)
        } catch {
            throw error
        }
    }

    /// Check sizeRequested against limit for URL.
    func manageSize(url: URL, sizeLimit: Int, sizeRequested: Int) throws {
        guard sizeLimit > sizeRequested else {
            throw FMError.fileTooLarge(maximumLimit: sizeLimit, sizeRequested: sizeRequested)
        }
        
        // get metadata for all files in directory (includes file sizes)
        var metadata: [FMFileMeta] = []
        do {
            metadata = try metadataForUrls(inDirectoryURL: url)
        } catch {
            throw error
        }
                
        // available space outstanding
        var availableSize = sizeLimit - metadata.totalSize()
                
        // Check if there's enough space available
        guard availableSize < sizeRequested else { return }
//        Logger.log(type: .info, object: "There is not enough free space available at: \(url). Attempting to delete items.")
        
        // remove directories from data
        // we want to delete files, not folders
        metadata.removeAll(where: { $0.isDirectory })
        
        // sort data by most recently used elements first
        metadata.sort { a, b in
            let d1 = a.lastAccessDate ?? a.creationDate ?? Date(timeIntervalSince1970: 0)
            let d2 = b.lastAccessDate ?? b.creationDate ?? Date(timeIntervalSince1970: 0)
            return d1 > d2
        }
        
        var deletedURLs: [URL] = []
        var problemURLs: [URL] = []

        // delete least recently used items until there's enough available space
        while availableSize < sizeRequested, let meta = metadata.popLast() {
            do {
                try delete(at: meta.url)
                availableSize += meta.fileSize
                deletedURLs.append(meta.url)
            } catch {
                problemURLs.append(meta.url)
            }
        }
        
        guard availableSize >= sizeRequested else {
            throw FMError.failedToCleanCache(
                directory: url,
                maximumLimit: sizeLimit,
                availableSize: availableSize,
                sizeRequested: sizeRequested,
                urlsDeleted: deletedURLs,
                urlsUnableToDelete: problemURLs)
        }
    }

    /// Create Folder & Intermediate Directories for URL.
    func createDirectory(url: URL) throws {
        do {
            try manager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        } catch {
            throw error
        }
    }
    
}

// MARK: READ

extension FMDirectory {
    
    /// Get Directory current size
    func currentSize() throws -> Int {
        do {
            let url = try url()
            return try getSize(url: url)
        } catch {
            throw error
        }
    }

    func getSize(url: URL) throws -> Int {
        do {
            let metadata = try metadataForUrls(inDirectoryURL: url)
            return metadata.totalSize()
        } catch {
            throw error
        }
    }
    
}


// MARK: DELETE

extension FMDirectory {
    
    internal func deleteAllFoldersInDirectory() throws {
        do {
            let url = try url()
            try delete(at: url)
        } catch {
            throw error
        }
    }

    /// Delete at URL
    @discardableResult internal func delete(at url: URL) throws -> URL {
        do {
            try manager.removeItem(at: url)
            return url
        } catch {
            throw error
        }
    }
    
    private func directoryIsEmpty(url: URL) -> Bool? {
        do {
            let contents = try FileManager.default.contentsOfDirectory(atPath: url.path)
            
            // If 2+ items, directory is not empty
            guard contents.count < 2 else {
                return false
            }
            
            // If only 1 item is in directory
            let item = contents.first ?? ""
            guard item == ".DS_Store" else {
                // If item is not DS_Store
                return false
            }
            
            // If item is DS_Store, directory is empty
            return true
        } catch _ {
            return nil
        }
    }
    
//    func cleanDirectoryIfNeeded() {
//        guard let url = url else { return }
//        let folders = metadataForUrls(inDirectoryURL: url)?.filter({ $0.isDirectory }) ?? []
//
//        for folder in folders {
//            if directoryIsEmpty(url: folder.url) ?? false {
//                do {
//                    try delete(at: folder.url)
//                } catch <#pattern#> {
//                    <#statements#>
//                }
//            }
//        }
//    }

}
