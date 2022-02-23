//
//  UDStreamable.swift
//  SwiftfulSaving
//
//  Created by Nick Sarno on 1/3/22.
//

import Foundation
import SwiftUI
import Combine

@propertyWrapper public struct UDStreamable<Value : UDSerializable> : DynamicProperty {
        
    private let currentValue: CurrentValueSubject<Value?, Never>
    private let key: String
    private let service: UDService
    
    /// Stream object from UserDefaults. Saved object will load asynchronously on launch. InitialValue will be used (and saved) if no previously saved object is found.
    /// - Parameters:
    ///   - initialValue: If a value is provided, it will be the starting value for the struct. If a value already exists, it will overwrite the value provided.
    ///   - key: Used as the filename for object in FileManager. Will be converted to lowercase & without special characters. ("My Image" => "my_image")
    ///   - service: The FMService that will perform actions within the FileManager for this object.
    public init(wrappedValue initialValue: Value? = nil, key: String, service: UDService) {
        self.currentValue = CurrentValueSubject<Value?, Never>(initialValue)
        self.key = key
        self.service = service
        self.getObject(initialValue: initialValue)
    }
        
    public var wrappedValue: Value? {
        get {
            currentValue.value
        }
        nonmutating set {
            setObject(newValue: newValue)
        }
    }
    
    public var projectedValue: CurrentValueSubject<Value?, Never> {
        currentValue
    }
            
    /// Get saved object from UserDefaults. If saved value exists, publish value to currentValue publisher. If no saved value exists and an initial value was provided, save initial value.
    ///  - Warning: THIS SHOULD ONLY BE CALLED ONCE, FROM THE INIT.
    private func getObject(initialValue: Value? = nil) {
        Task {
            let savedValue: Value? = try? await service.object(key: key)

            // Ensure user wrappedValue wasn't set between init and now
            // Would only happen if wrappedValue is set immediately after init
            guard wrappedValue == initialValue else { return }

            if let savedValue = savedValue {
                // Publish saved value
                currentValue.send(savedValue)
            } else if let initialValue = initialValue {
                // Nothing was saved, save new initialValue (already set to currentValue publisher in the init)
                setObject(newValue: initialValue)
            }
        }
    }
            
    /// If newValue is provided, save object to FileManager. If newValue is nil, delete the file if it exists. Publish result to currentValue publisher.
    private func setObject(newValue: Value?) {
        // Set value, even if it is nil
        // Publish value first, for UI & data race issues
        // Then persist to UserDefaults
        currentValue.send(newValue)

        Task {
            guard let newValue = newValue else {
                // If newValue == nil, then delete file
                await service.delete(key: key)
                return
            }
            
            // If newValue != nil, save file
            await service.save(object: newValue, key: key)
        }
    }
            
}
