//
//  CDContainer.swift
//  SwiftfulSaving
//
//  Created by Nick Sarno on 1/7/22.
//

import Foundation
import CoreData

public struct CDContainer: Hashable {

    private let container: NSPersistentContainer
    
    var name: String {
        container.name
    }

    public init(name: String) {
        container = NSPersistentContainer(name: name)
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("FATALITY: ERROR LOADING CORE DATA. \(error)")
            }
        }
    }
    
    /// FOR UNIT TESTS ONLY
//    public init<T:AnyObject>(name: String, modelName: String, modelType: T.Type) {
//        container = NSPersistentContainer(name: name, managedObjectModel: managedObjectModel)
//        container.loadPersistentStores { (description, error) in
//            if let error = error {
//                print("FATALITY: ERROR LOADING CORE DATA. \(error)")
//            }
//        }
//    }
    
    // Hashable
    // If two structs are the same Container
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }

    func newBackgroundContext() -> NSManagedObjectContext {
        return container.newBackgroundContext()
    }

}
