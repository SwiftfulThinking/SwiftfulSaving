//
//  File.swift
//  
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
        
    internal func value(forKey key: String) -> Any? {
        let value = suite.value(forKey: key)
        log(action: .read, key: key, error: nil)
        return value
    }
    
    internal func set(_ value: Any?, forKey key: String) {
        suite.set(value, forKey: key)
        log(action: .write, key: key, error: nil)
    }
    
}


extension UDService {
        
    private func log(action: SwiftfulSaving.ServiceAction, key: String, error: Error? = nil) {
        Task {
            await Logger.shared.log(action: action, at: .userDefaults, object: "|| Key: \(key) || SuiteName: \(name)")
        }
    }
    
}
