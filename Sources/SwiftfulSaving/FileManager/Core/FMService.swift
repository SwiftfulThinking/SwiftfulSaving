//
//  FMService.swift
//  FMService
//
//  Created by Nick Sarno on 8/13/21.
//

import Foundation

final public actor FMService {
        
    nonisolated static public func printUsage() {
        Task {
            await FMMemoryManager.shared.printUsage()
        }
    }
        
    // MARK: PROPERTIES
        
    internal let folder: FMFolder
    internal let cache: FMCache
    
    internal var folderReads: Int = 0
    internal var folderWrites: Int = 0
    internal var cacheReads: Int = 0
    internal var cacheWrites: Int = 0

    // MARK: INIT
    
    /// Initialize service with a specific folder to read/write from
    public init(directory: FMDirectory, folderName: String, folderLimitInMB: Double? = nil, cacheLimitInMB: Double? = nil) {
        
        let newFolder = FMFolder(directory: directory, name: folderName, limitInMB: folderLimitInMB)
        self.folder = newFolder
        self.cache = FMCache(limitInMB: cacheLimitInMB)

//        Task.detached {
//            // Produces a warning that 'self' cannot be captured
//            // This is bc init() of an actor is on @MainActor
//            // We therefore cannot perform tasks on local actor here
//            // However, this task does not affect local actor but globalActor @FMMemoryManager
//            await FMMemoryManager.shared.add(self)
//        }
    }
        
    // MARK: READ
        
    /// Get DataTransformable object from File
    public func object<T:DataTransformable>(key: String) throws -> T {
        throw URLError(.badURL)
        // Check NSCache
//        do {
//            let object: T = try cache.object(key: key)
//            cacheReads += 1
//            log(action: .read, at: .nsCache, key: key)
//            return object
//        } catch {
//            log(action: .notFound, at: .nsCache, key: key)
//        }
//        
//        // Check FileManager
//        do {
//            let object: T = try folder.getFile(key: key)
//            folderReads += 1
//            log(action: .read, at: .fileManager, key: key)
//            Task {
//                saveToCache(object: object, key: key)
//            }
//            return object
//        } catch {
//            log(action: .notFound, at: .fileManager, key: key)
//            throw error
//        }
    }
                
    // MARK: WRITE
    
    /// Save DataTransformable object to File and manage folder size if needed
    @discardableResult public func save<T:DataTransformable>(object: T, key: String) throws -> URL {
        throw URLError(.badURL)
//        do {
//            // Add to FileManager
//            let url = try folder.save(object: object, key: key)
//            
//            // Add to NSCache
//            Task {
//                saveToCache(object: object, key: key)
//            }
//            
//            folderWrites += 1
//            log(action: .write, at: .fileManager, key: key)
//            return url
//        } catch {
//            log(action: .write, at: .fileManager, key: key, error: error)
//            throw error
//        }
    }
    
    private func saveToCache<T:DataTransformable>(object: T, key: String) {
//        do {
//            try cache.save(object, key: key)
//            cacheWrites += 1
//            log(action: .write, at: .nsCache, key: key)
//        } catch {
//            log(action: .write, at: .nsCache, key: key, error: error)
//        }
    }

    // MARK: DELETE
    
    /// Delete File
    public func delete(key: String, ext: FMFileExtension) throws {
//        do {
//            try folder.deleteFile(key: key, ext: ext)
//            cache.delete(key: key)
//            log(action: .delete, at: .fileManager, key: key)
//        } catch {
//            log(action: .delete, at: .fileManager, key: key, error: error)
//        }
    }
    
    public func deleteFolder() throws {
//        do {
//            try folder.deleteFolder()
//            log(action: .delete, at: .fileManager, key: "Folder: " + folder.name)
//        } catch {
//            log(action: .delete, at: .fileManager, key: "Folder: " + folder.name, error: error)
//        }
    }
    
    // MARK: SIZE

    // Public functions to observe & test limits
    // FMFolder and associated limits are internal to framework
    // and not accessible from Test/App modules
    public func cacheUsage() -> (limit: Int, size: Int?) {
        (cache.cache.totalCostLimit, nil)
    }
    public func folderUsage() -> (limit: Int, size: Int?) {
        (folder.limit, try? folder.currentSize())
    }
    public func directoryUsage() -> (limit: Int, size: Int?) {
        (folder.directory.limit, try? folder.directory.currentSize())
    }
    
}

extension FMService {
        
    private func log(action: SwiftfulSaving.ServiceAction, at type: SwiftfulSaving.ServiceType, key: String, error: Error? = nil) {
//        Task {
//            await Logger.shared.log(action: action, at: type, object: "|| Directory: \(folder.directory.name) || Folder: \(folder.name) || Key: \(key) ")
//            
//            if let error = error {
//                await Logger.shared.log(action: action, at: type, object: " || ⚠️ " + error.localizedDescription)
//            }
//        }
    }
    
}
