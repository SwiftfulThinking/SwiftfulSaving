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
    
    internal var contextReads: Int = 0
    internal var contextWrites: Int = 0

    public init(container: CDContainer, contextName: String, cacheLimitInMB: Double? = nil) {
        let newContext = CDContext(container: container, contextName: contextName)
        self.context = newContext
        
        Task.detached {
            // Produces a warning that 'self' cannot be captured
            // This is bc init() of an actor is on @MainActor
            // We therefore cannot perform tasks on local actor here
            // However, this task does not affect local actor but globalActor @FMMemoryManager
            await CDMemoryManager.shared.add(self)
        }
    }

    // Convert to T.Entity here and pass that protocol to next function
    public func object<T:CoreDataTransformable>(key: String) throws -> T {
        do {
            let object: T = try context.object(key: key)
            contextReads += 1
            log(action: .read, at: .coreData, key: key)
            return object
        } catch {
            log(action: .notFound, at: .coreData, key: key)
            throw error
        }
    }
    
    public func allObjects<T:CoreDataTransformable>() throws -> [T] {
        // Check CoreData
        do {
            let objects: [T] = try context.allObjects()
            contextReads += 1
            log(action: .read, at: .coreData, key: "N/A - All Objects")
            return objects
        } catch {
            log(action: .notFound, at: .coreData, key: "N/A - All Objects")
            throw error
        }
    }

    /// Save DataTransformable object to File and manage folder size if needed
    @discardableResult public func save<T:CoreDataTransformable>(object: T, key: String) throws -> T {
        do {
            // Add to CoreData
            let updatedItem: T = try context.save(object: object, key: key)
            contextWrites += 1
            log(action: .write, at: .coreData, key: key)
            return updatedItem
        } catch {
            log(action: .write, at: .coreData, key: key, error: error)
            throw error
        }
    }
        
    public func delete<T:CoreDataTransformable>(key: String, type: T.Type) throws {
        do {
            try context.delete(key: key, type: type)
            log(action: .delete, at: .coreData, key: key)
        } catch {
            log(action: .delete, at: .coreData, key: key, error: error)
        }
    }
    
    public func deleteAllObjects<T:CoreDataTransformable>(withType type: T.Type) throws {
        let key = "N/A - All Objects"
        do {
            try context.deleteAllObjects(withType: type)
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


