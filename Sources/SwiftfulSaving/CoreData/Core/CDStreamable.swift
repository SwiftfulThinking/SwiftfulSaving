//
//  CDStreamable.swift
//  SwiftfulSaving
//
//  Created by Nick Sarno on 1/9/22.
//

import Foundation
import Combine
import SwiftUI

@propertyWrapper public struct CDStreamable<Value : CoreDataTransformable> : DynamicProperty {
        
    private let currentValue: CurrentValueSubject<Value?, Never>
    private let key: String
    private let service: CDService
    
    /// Stream object from UserDefaults. Saved object will load on launch. InitialValue will be used (and saved) if no previously saved object is found.
    /// - Parameters:
    ///   - initialValue: If a value is provided, it will be the starting value for the struct. If a value already exists, it will overwrite the value provided.
    ///   - key: Used as the filename for object in FileManager. Will be converted to lowercase & without special characters. ("My Image" => "my_image")
    ///   - service: The FMService that will perform actions within the FileManager for this object.
    public init(wrappedValue initialValue: Value? = nil, key: String, service: CDService) {
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
            
    /// Get saved object from CoreData. If saved value exists, publish value to currentValue publisher. If no saved value exists and an initial value was provided, save initial value.
    ///  - Warning: THIS SHOULD ONLY BE CALLED ONCE, FROM THE INIT.
    private func getObject(initialValue: Value? = nil) {
        Task {
            let savedValue: Value? = try? await service.object(key: key)

            // Ensure user wrappedValue wasn't set between init and now
            // Would only happen if wrappedValue is set immediately after init
            guard wrappedValue?.entity?.key == initialValue?.entity?.key else { return }

            if let savedValue = savedValue {
                // Use saved value
                currentValue.send(savedValue)
            } else if let initialValue = initialValue {
                // Nothing was saved, save new initialValue (already set to currentValue publisher on init() )
                setObject(newValue: initialValue)
            }
        }
    }
                
    /// If newValue is provided, save object to CoreData. If newValue is nil, delete the file if it exists. Publish result to currentValue publisher.
    private func setObject(newValue: Value?) {
        currentValue.send(newValue)

        Task {
            guard let newValue = newValue else {
                // If newValue == nil, then delete file
                // However, we need reference to Entity in order to delete it (lastValue)
                guard let lastValue = wrappedValue else { return }
                try await service.delete(key: key, object: lastValue)
                return
            }
            
            // If newValue != nil, save file
            let returnedObject = try await service.save(object: newValue, key: key)
            // ReturnedObject will have an updated Entity (unlike FileManager and UserDefaults)
            // Publish updated object back to application again
            currentValue.send(returnedObject)
        }
    }
    
}
