//
//  FMCache.swift
//  SwiftfulSaving
//
//  Created by Nick Sarno on 1/1/22.
//

import Foundation

struct FMCache {

    var cache: NSCache<NSString, NSData>

    init(limitInMB: Double? = nil) {
        let cache = NSCache<NSString, NSData>()
        if let cacheLimit = limitInMB?.convertingMBToBytes {
            cache.totalCostLimit = cacheLimit
        }
        self.cache = cache
    }

    func object<T:DataTransformable>(key: String) throws -> T {
        guard let data = cache.object(forKey: key as NSString) else {
            throw FMError.objectNotFoundInCache
        }

        guard let object = T(data: data as Data, url: nil) else {
            throw FMError.noData
        }

        return object
    }

    func save<T:DataTransformable>(_ object: T, key: String) throws {
        guard let data = object.toData() else {
            throw FMError.noData
        }
        cache.setObject(data as NSData, forKey: key as NSString)
    }

    func delete(key: String) {
        cache.removeObject(forKey: key as NSString)
    }

}
