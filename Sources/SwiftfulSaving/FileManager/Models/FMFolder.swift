//
//  FMFolder.swift
//  SwiftfulSaving
//
//  Created by Nick Sarno on 12/10/21.
//

// logger
// remove static from protocol?

import Foundation

struct FMFolder: Hashable {
    
    let directory: FMDirectory
    let name: String
    let limit: Int
    
    init(directory: FMDirectory, name: String, limitInMB: Double? = nil) {
        self.directory = directory
        self.name = name.lowercasedWithoutSpacesOrPunctuation()
        self.limit = max(0, Int(limitInMB?.convertingMBToBytes ?? 0))
    }
    
    // Hashable
    // If two structs are in the same Directory and have the same folder Name
    public func hash(into hasher: inout Hasher) {
        hasher.combine(directory.directory.rawValue.description + name)
    }
    
    /// Get Folder current size
    public func currentSize() throws -> Int {
        do {
            let url = try url()
            return try directory.getSize(url: url)
        } catch {
            throw error
        }
    }
    
}

// MARK: URLs

extension FMFolder {
    
    /// URL for Folder within Directory
    private func url() throws -> URL {
        do {
            var url = try directory.url()
            url.appendPathComponent(name)
            return url
        } catch {
            throw error
        }
    }
       
    /// URL for File in Folder within Directory
    private func fileURL(key: String, fileExtension ext: FMFileExtension) throws -> URL {
        // Note: Originally included for developer convenience.
        // However, removes ability for developers to fully control file name
//        let key = key.lowercasedWithoutSpacesOrPunctuation()
        
        do {
            var url = try url()
            url.appendPathComponent(key + ext.fileExtension)
            return url
        } catch {
            throw error
        }
    }
    
}

// MARK: WRITE

extension FMFolder {
        
    /// Save DataTransformable object to File and manage folder size if needed
    func save<T:DataTransformable>(object: T, key: String) throws -> URL {
        do {
            // Prepare folder and directory by clearing room to fit new file as needed
            try manageFolderAndDirectorySize(object: object)
            
            // Write to folder
            return try writeToDisk(item: object, key: key)
        } catch {
            throw error
        }
    }
    
    private func manageFolderAndDirectorySize<T:DataTransformable>(object: T) throws {
        guard let sizeRequested = object.toData()?.bytes else { throw FMError.noData }
        
        do {
            // manage folder size
            try manageFolderSize(sizeRequested: sizeRequested)

            // manage directory size
            try directory.manageDirectorySize(sizeRequested: sizeRequested)
        } catch {
            throw error
        }
    }
    
    /// Check sizeRequested against Folder limit
    private func manageFolderSize(sizeRequested: Int) throws {
        // If no limit set, return success
        guard limit > 0 else { return }
        
        do {
            // Get folder URL
            let url = try url()

            // Clear room for sizeRequested as Needed
            try directory.manageSize(url: url, sizeLimit: limit, sizeRequested: sizeRequested)
        } catch {
            throw error
        }
    }

    /// Write DataTransformable to File
    private func writeToDisk<T:DataTransformable>(item: T, key: String) throws -> URL {
        // Convert file to data
        guard let data = item.toData() else { throw FMError.noData }
        
        do {
            // Create folders if they don't exist
            // Result will be successful if folders were created OR folders already existed.
            // Result is failure if unable to create or find folders.
            // If error creating folders, return the error
            try createFoldersIfNeeded()
            
            // Get file URL
            let url = try fileURL(key: key, fileExtension: T.fileExtension)
            
            // Write to file
            return try write(data: data, toURL: url)
        } catch {
            throw error
        }
    }
    
    /// Check if folders already exist and create them if needed
    private func createFoldersIfNeeded() throws {
        do {
            // Get url for directory
            let url = try url()
            
            // Check folder doesn't already exist. If it exists, return success.
            guard !directory.urlExists(url: url) else { return }

            // Create directory
            try directory.createDirectory(url: url)
        } catch {
            throw error
        }
    }
    
    /// Write Data to URL
    private func write(data: Data, toURL url: URL) throws -> URL {
        do {
            try data.write(to: url)
            return url
        } catch {
            throw error
        }
    }
        
}

// MARK: READ

extension FMFolder {
    
    func getFile<T:DataTransformable>(key: String) throws -> T {
        do {
            let data = try getFileData(key: key, fileExtension: T.fileExtension)
            guard let object: T = T(data: data) else {
                throw FMError.noData
            }
            return object
        } catch {
            throw error
        }
    }
    
    /// Get Data from File
    private func getFileData(key: String, fileExtension: FMFileExtension) throws -> Data {
        do {
            let url = try fileURL(key: key, fileExtension: fileExtension)
            
            guard directory.urlExists(url: url) else {
                throw FMError.fileNotFound
            }
            
            return try Data(contentsOf: url)
        } catch {
            throw error
        }
    }
    
}

// MARK: DELETE

extension FMFolder {
    
    func deleteFile(key: String, ext: FMFileExtension) throws {
        do {
            let url = try fileURL(key: key, fileExtension: ext)
            try directory.delete(at: url)
        } catch {
            throw error
        }
    }
    
    func deleteFolder() throws {
        do {
            let url = try url()
            try directory.delete(at: url)
        } catch {
            throw error
        }
    }
    
}
