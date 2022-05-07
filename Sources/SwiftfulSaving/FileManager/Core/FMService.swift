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

        Task {
            // Produces a warning that 'self' cannot be captured
            // This is bc init() of an actor is on @MainActor
            // We therefore cannot perform tasks on local actor here
            // However, this task does not affect local actor but globalActor @FMMemoryManager
            await FMMemoryManager.shared.add(self)
        }
    }
        
    // MARK: READ
    
    /// Get object at key from FileManager.
    public func object<T>(key: String) throws -> T where T : URLTransformable {
        try objectFromFileManager(type: T.self, key: key)
    }

    /// Get object at key from FileManager and/or NSCache.
    public func object<T>(key: String) throws -> T where T : URLTransformable, T : DataTransformable {
        if let object = objectFromCache(type: T.self, key: key) {
            return object
        }
        return try objectFromFileManager(type: T.self, key: key)
    }
    
    private func objectFromFileManager<T>(type: T.Type, key: String) throws -> T where T : URLTransformable {
        do {
            let object: T = try folder.getFile(key: key)
            folderReads += 1
            log(action: .read, at: .fileManager, key: key)
            return object
        } catch {
            log(action: .notFound, at: .fileManager, key: key)
            throw error
        }
    }
        
    private func objectFromCache<T>(type: T.Type, key: String) -> T? where T : DataTransformable {
        do {
            let object: T = try cache.object(key: key)
            cacheReads += 1
            log(action: .read, at: .nsCache, key: key)
            return object
        } catch {
            log(action: .notFound, at: .nsCache, key: key)
            return nil
        }
    }
    
    // MARK: WRITE
    
    /// Save object at key to FileManager.
    @discardableResult public func save<T>(object: T, key: String) throws -> URL where T : URLTransformable {
        try saveToFileManager(object: object, key: key)
    }
    
    /// Save object at key to FileManager and NSCache.
    @discardableResult public func save<T>(object: T, key: String) throws -> URL where T : URLTransformable, T : DataTransformable {
        try? saveToCache(object: object, key: key)
        return try saveToFileManager(object: object, key: key)
    }

    /// Save DataTransformable object to File and manage folder size if needed
    public func saveToFileManager<T>(object: T, key: String) throws -> URL where T : URLTransformable {
        do {
            let url = try folder.save(object: object, key: key)
            folderWrites += 1
            log(action: .write, at: .fileManager, key: key)
            return url
        } catch {
            log(action: .write, at: .fileManager, key: key, error: error)
            throw error
        }
    }
    
    private func saveToCache<T>(object: T, key: String) throws where T : DataTransformable {
        do {
            try cache.save(object, key: key)
            cacheWrites += 1
            log(action: .write, at: .nsCache, key: key)
        } catch {
            log(action: .write, at: .nsCache, key: key, error: error)
            throw error
        }
    }

    // MARK: DELETE
    
    /// Delete File
    public func delete(key: String, ext: FMFileExtension) throws {
        do {
            try folder.deleteFile(key: key, ext: ext)
            cache.delete(key: key)
            log(action: .delete, at: .fileManager, key: key)
        } catch {
            log(action: .delete, at: .fileManager, key: key, error: error)
        }
    }
    
    public func deleteFolder() throws {
        do {
            try folder.deleteFolder()
            log(action: .delete, at: .fileManager, key: "Folder: " + folder.name)
        } catch {
            log(action: .delete, at: .fileManager, key: "Folder: " + folder.name, error: error)
        }
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
        Task {
            await Logger.shared.log(action: action, at: type, object: "|| Directory: \(folder.directory.name) || Folder: \(folder.name) || Key: \(key) ")
            
            if let error = error {
                await Logger.shared.log(action: action, at: type, object: " || ⚠️ " + error.localizedDescription)
            }
        }
    }
    
}
