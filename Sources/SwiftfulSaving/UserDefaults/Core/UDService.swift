//
//  UDService.swift
//  UDService
//
//  Created by Nick Sarno on 2/21/22.
//

import Foundation

final public actor UDService {

    private let suite: UserDefaults
    let name: String

    public init(suiteName: String? = nil) {
        self.suite = UserDefaults(suiteName: suiteName) ?? UserDefaults.standard
        self.name = suiteName ?? "Standard"
    }
        
    public func object<T:UDSerializable>(key: String) throws -> T {
        guard let object = suite.value(forKey: key) else {
            throw UDError.objectNotFound
        }
        
        guard let object = object as? T else {
            throw UDError.invalidDataType
        }

        defer {
            log(action: .read, key: key, error: nil)
        }
        
        return object
    }
    
    public func save<T:UDSerializable>(object: T, key: String) {
        suite.set(object, forKey: key)
        log(action: .write, key: key, error: nil)
    }
    
    public func delete(key: String) {
        suite.set(nil, forKey: key)
        log(action: .delete, key: key, error: nil)
    }
    
}


extension UDService {
        
    private func log(action: SwiftfulSaving.ServiceAction, key: String, error: Error? = nil) {
        Task {
            await Logger.shared.log(action: action, at: .userDefaults, object: "|| SuiteName: \(name) || Key: \(key)")
        }
    }
    
}
