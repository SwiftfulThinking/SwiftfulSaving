//
//  CDService.swift
//  SwiftfulSaving
//
//  Created by Nick Sarno on 1/7/22.
//

import Foundation

final public actor CDService {

    nonisolated static public func printUsage() {
        Task {
            await CDMemoryManager.shared.printUsage()
        }
    }
    
    let context: CDContext
    let cache: CDCache
    
    internal var contextReads: Int = 0
    internal var contextWrites: Int = 0
    internal var cacheReads: Int = 0
    internal var cacheWrites: Int = 0

    init(container: CDContainer, contextName: String, cacheLimitInMB: Double? = nil) {
        let newContext = CDContext(container: container, contextName: contextName)
        self.context = newContext
        self.cache = CDCache(limitInMB: cacheLimitInMB)
        
        Task.detached {
            // Produces a warning that 'self' cannot be captured
            // This is bc init() of an actor is on @MainActor
            // We therefore cannot perform tasks on local actor here
            // However, this task does not affect local actor but globalActor @FMMemoryManager
            await CDMemoryManager.shared.add(self)
        }
    }

    // Convert to T.Entity here and pass that protocol to next function
    func object<T:CoreDataTransformable>(key: String) throws -> T {
                        
        // Check NSCache
        do {
            let object: T = try cache.object(key: key)
            cacheReads += 1
            log(action: .read, at: .nsCache, key: key)
            return object
        } catch {
            log(action: .notFound, at: .nsCache, key: key)
        }
        
        // Check CoreData
        do {
            let object: T = try context.object(key: key)
            contextReads += 1
            log(action: .read, at: .coreData, key: key)
            Task {
                saveToCache(object: object, key: key)
            }
            return object
        } catch {
            log(action: .notFound, at: .coreData, key: key)
            throw error
        }
    }
    
    func allObjects<T:CoreDataTransformable>() throws -> [T] {
        // Check CoreData
        let key = "N/A - All Objects"
        do {
            let objects: [T] = try context.objects(predicate: nil, sortDescriptors: nil)
            contextReads += 1
            log(action: .read, at: .coreData, key: key)
            Task {
                for object in objects {
                    guard let key = object.entity?.key else { continue }
                    saveToCache(object: object, key: key)
                }
            }
            return objects
        } catch {
            log(action: .notFound, at: .coreData, key: key)
            throw error
        }
    }

    /// Save DataTransformable object to File and manage folder size if needed
    public func save<T:CoreDataTransformable>(object: T, key: String) throws -> T {
        do {
            // Add to CoreData
            let updatedItem: T = try context.save(object: object, key: key)
            
            // Add to NSCache (must be after update, with new Entity)
            Task {
                saveToCache(object: updatedItem, key: key)
            }
            
            contextWrites += 1
            log(action: .write, at: .coreData, key: key)
            return updatedItem
        } catch {
            log(action: .write, at: .coreData, key: key, error: error)
            throw error
        }
    }
    
    private func saveToCache<T:CoreDataTransformable>(object: T, key: String) {
        do {
            try cache.save(object, key: key)
            cacheWrites += 1
            log(action: .write, at: .nsCache, key: key)
        } catch {
            log(action: .write, at: .nsCache, key: key, error: error)
        }
    }
    
    public func delete<T:CoreDataTransformable>(key: String, object: T) throws {
        do {
            try context.delete(item: object)
            cache.delete(key: key)
            log(action: .delete, at: .coreData, key: key)
        } catch {
            log(action: .delete, at: .coreData, key: key, error: error)
        }
    }
    
    public func deleteAllObjects<T:CoreDataTransformable>(withType type: T.Type) throws {
        let key = "N/A - All Objects"
        do {
            try context.deleteAllObjects(withType: type)
            cache.deleteAllObjects()
            log(action: .delete, at: .coreData, key: key)
        } catch {
            log(action: .delete, at: .coreData, key: key, error: error)
        }
    }

}

extension CDService {
        
    private func log(action: SwiftfulSaving.ServiceAction, at type: SwiftfulSaving.ServiceType, key: String, error: Error? = nil) {
        Task {
            await Logger.shared.log(action: action, at: type, object: "|| Container: \(context.container.name) || Context: \(context.name) || Key: \(key) ")
            
            if let error = error {
                await Logger.shared.log(action: action, at: type, object: " || ⚠️ " + error.localizedDescription)
            }
        }
    }
    
}


