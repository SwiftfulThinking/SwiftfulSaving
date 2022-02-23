//
//  CDContext.swift
//  SwiftfulSaving
//
//  Created by Nick Sarno on 1/4/22.
//

import Foundation
import CoreData

struct CDContext: Hashable {

    private let context: NSManagedObjectContext
    let container: CDContainer
    
    var name: String {
        context.name ?? "unknown"
    }

    init(container: CDContainer, contextName: String) {
        self.context = container.newBackgroundContext()
        self.context.name = contextName.lowercasedWithoutSpacesOrPunctuation()
        self.container = container
    }
    
    // Hashable
    // If two structs are in the same Container and have the same Context Name
    public func hash(into hasher: inout Hasher) {
        hasher.combine(container.name + name)
    }

    func object<T:CoreDataTransformable>(key: String) throws -> T {
        do {
            // lockedKey is used when saving values via CoreDataTransformable
            let lockedKey = key.lowercasedWithoutSpacesOrPunctuation()
            
            // Filter for all objects with key
            let predicate = NSPredicate(format: "key == %@", "\(lockedKey)")

            // All objects with key
            let objects: [T] = try objects(predicate: predicate, sortDescriptors: nil)

            // Return first object
            // There should only ever be one because objects are IdentifiableByKey
            guard let object: T = objects.first else {
                throw FMError.fileNotFound
            }
            
            // Return object
            return object
        } catch {
            throw error
        }
    }
    
    
    func objects<T:CoreDataTransformable>(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) throws -> [T] {
        
        // Create request for all entities within the context of type T.Entity
        let fetchRequest = NSFetchRequest<T.Entity>(entityName: String(describing: T.Entity.self))
        
        // Add filters
        fetchRequest.predicate = predicate
        
        // Add sorting
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
            // Perform fetch request
            let fetchResults = try context.fetch(fetchRequest)
            
            // Convert fetched [T.Entity] to [T]
            let returnedItems = fetchResults.compactMap({ T(from: $0) })
            // Ensure at least 1 item
            guard !returnedItems.isEmpty else {
                throw FMError.noData
            }
            
            // Return [T]
            return returnedItems
        } catch {
            throw error
        }
    }

    func save<T:CoreDataTransformable>(object: T, key: String) throws -> T {
        do {
            // Create new Entity within Context if needed
            var entity = object.entity ?? T.Entity(context: context)
            
            // Update Entity with values from object
            object.updatingValues(forEntity: &entity)
            
            // Ensure Entity has the object's key
            entity.key = key.lowercasedWithoutSpacesOrPunctuation()

            // Save context
            try context.save()
            
            // Convert Entity back to object, with the updated Entity included
            guard let updatedObject = T(from: entity) else {
                throw URLError(.badURL)
            }
            return updatedObject
        } catch {
            throw error
        }
    }
    
    func delete<T:CoreDataTransformable>(item: T) throws {
        guard let entity = item.entity else {
            throw FMError.noData
        }
        context.delete(entity)
        
        return try context.save()
    }

    func deleteAllObjects<T:CoreDataTransformable>(withType type: T.Type) throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: String(describing: T.Entity.self))
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try context.execute(deleteRequest)
        try context.save()
    }

}

