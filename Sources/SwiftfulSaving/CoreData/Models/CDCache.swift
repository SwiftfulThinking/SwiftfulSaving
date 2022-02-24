//
//  CDCache.swift
//  SwiftfulSaving
//
//  Created by Nick Sarno on 1/7/22.
//

import Foundation
import CoreData

struct CDCache  {
    
    let cache: NSCache<NSString, NSManagedObject>

    init(limitInMB: Double? = nil) {
        let cache = NSCache<NSString, NSManagedObject>()
        if let cacheLimit = limitInMB?.convertingMBToBytes {
            cache.totalCostLimit = cacheLimit
        }
        self.cache = cache
    }

    func object<T:CoreDataTransformable>(key: String) throws -> T {
        guard let object = cache.object(forKey: key as NSString) as? T.Entity else {
            throw FMError.objectNotFoundInCache
        }
        
        guard let item = T(from: object) else {
            throw FMError.noData
        }
        
        return item
    }
    
    func save<T:CoreDataTransformable>(_ object: T, key: String) throws {
        guard let entity = object.entity else {
            throw FMError.noData
        }
        cache.setObject(entity, forKey: key as NSString)
    }
    
    func delete(key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    func deleteAllObjects() {
        cache.removeAllObjects()
    }
}
