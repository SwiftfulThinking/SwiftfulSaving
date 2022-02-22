//
//  FMMemoryManager.swift
//  SwiftfulSaving
//
//  Created by Nick Sarno on 12/19/21.
//

import Foundation
import SwiftUI

// This actor will contain all instances of FMFolder and FMDirectory that are created.
// It is used to:
// (1) ensure FMFolders are not duplicated (two folders reading/writing to same location can cause race conditions), and
// (2) maintain Directory limits, which can aggregate across instances of FMFolders in the same Directory

@globalActor final actor FMMemoryManager {
    
    static let shared = FMMemoryManager()
        
    var activeServices: [FMService] = []

    func add(_ service: FMService) {
        checkFolderNameIsValid(folder: service.folder)
        checkFolderIsDuplicate(folder: service.folder)
        checkDirectoryIsDuplicate(directory: service.folder.directory)
        activeServices.append(service)
    }
    
    private func checkFolderNameIsValid(folder: FMFolder) {
        guard folder.name.isEmpty else { return }
        log("You should not initialize a FMFolder without a valid name (0 characters).")
    }
    
    private func checkFolderIsDuplicate(folder: FMFolder) {
        let activeFolders = activeServices.map({ $0.folder })
        guard activeFolders.contains(folder) else { return }
        log("There are duplicate instances of FMFolder that have the same name: \(folder.name). This may lead to unwanted behavior and data races.")
    }
    
    private func checkDirectoryIsDuplicate(directory: FMDirectory) {
        let activeDirectories = activeServices.map({ $0.folder.directory })
        
        // Make sure there is not already an existing Directory where the Directory has a different limit.
        // This is to avoid multiple different limits on the same Directory.
        guard activeDirectories.contains(where: { existingDirectory in
            let sameDirectory = existingDirectory == directory
            let differentLimit = existingDirectory.limit != directory.limit
            return sameDirectory && differentLimit
        }) else { return }
        log("There are multiple FMDirectory created with the same Directory and different limits. This may lead to unwanted behavior. Assume the lower limit will be used.")
    }
    
    private func log(_ string: String) {
        print("🚨 WARNING 🚨" + string)
    }
    
    // Statistics
    func printUsage() {
        Task {
            var folders: [FolderStats] = []
            var directories: [DirectoryStats] = []
            
            for service in activeServices {
                let folderStats = await FolderStats(service: service)
                folders.append(folderStats)
                
                let directory = service.folder.directory
                if var directoryStats = directories.first(where: { $0.name == directory.name }) {
                    // Update directory stats with folder
                    directoryStats.addFolder(folderStats)
                } else {
                    // Add directory stats and update stats with folder
                    var directoryStats = DirectoryStats(directory: directory)
                    directoryStats.addFolder(folderStats)
                    directories.append(directoryStats)
                }
            }
            
            print("""
            - - - - - - - - - -
            🚀 FMService Usage:
            - - - - - - - - - -
            """)
            
            for folder in folders {
                print(folder.log())
            }
            for directory in directories {
                print(directory.log())
            }
            print("""
            - - - - - - - - - -
            🚀 END LOG
            - - - - - - - - - -
            """)
        }
    }
    
    private struct FolderStats {
        let name: String
        let limit: Int
        let currentSize: Int?
        let folderReads: Int
        let folderWrites: Int
        let cacheLimit: Int
        let cacheReads: Int
        let cacheWrites: Int
        let directory: (name: String, limit: Int)
        
        init(service: FMService) async {
            self.name = "\(service.folder.directory.name) + \(service.folder.name)"
            self.limit = service.folder.limit
            self.currentSize = try? service.folder.currentSize()
            self.folderReads = await service.folderReads
            self.folderWrites = await service.folderWrites
            self.cacheLimit = service.cache.cache.totalCostLimit
            self.cacheReads = await service.cacheReads
            self.cacheWrites = await service.cacheWrites
            self.directory = (service.folder.directory.name, service.folder.directory.limit)
        }
        
        func log() -> String {
        """
        📁 FMFolder
        - Folder Name: \(name)
        - Folder Limit: \(limit)
        - Folder Size: \(currentSize ?? 0)
        - Folder Reads: \(folderReads)
        - Folder Writes: \(folderWrites)
        - Cache Limit: \(cacheLimit)
        - Cache Reads: \(cacheReads)
        - Cache Writes: \(cacheWrites)
        - Directory Name: \(directory.name)
        - Directory Limit: \(directory.limit)
        
        """
        }
    }
    private struct DirectoryStats {
        let name: String
        let path: String?
        var limit: Int
        let currentSize: Int?
        var numberOfReads: Int
        var numberOfWrites: Int
        var folders: [(name: String, limit: Int)]
        
        init(directory: FMDirectory) {
            self.name = directory.name
            self.path = try? directory.url().path
            self.limit = directory.limit
            self.currentSize = try? directory.currentSize()
            self.numberOfReads = 0
            self.numberOfWrites = 0
            self.folders = []
        }
        
        mutating func addFolder(_ stats: FolderStats) {
            self.limit = stats.directory.limit > 0 ? min(stats.directory.limit, limit) : limit
            self.numberOfReads = numberOfReads + stats.folderReads
            self.numberOfWrites = numberOfWrites + stats.folderWrites
            self.folders = folders + [(stats.name, stats.limit)]
        }
        
        func log() -> String {
        """
        📁📁📁 FMDirectory
        - Directory Name: \(name)
        - Directory Path: \(path ?? "error")
        - Directory Limit: \(limit)
        - Directory Size: \(currentSize ?? 0)
        - Directory Reads: \(numberOfReads)
        - Directory Writes: \(numberOfWrites)
        - Directory Folders: \(folders)
                    
        """
        }
    }

    
}
