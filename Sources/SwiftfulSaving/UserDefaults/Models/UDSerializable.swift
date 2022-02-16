//
//  UDSerializable.swift
//  SwiftfulSaving
//
//  Created by Nick Sarno on 1/3/22.
//
//  Original Created by Jesse Squires
//  https://www.jessesquires.com
//
//  Documentation
//  https://jessesquires.github.io/Foil
//
//  GitHub
//  https://github.com/jessesquires/Foil
//
//  Copyright © 2021-present Jesse Squires
//

import Foundation

/// Describes a value that can be saved to and fetched from `UserDefaults`.
///
/// Default conformances are provided for:
///    - `Bool`
///    - `Int`
///    - `UInt`
///    - `Float`
///    - `Double`
///    - `String`
///    - `URL`
///    - `Date`
///    - `Data`
///    - `Array`
///    - `Set`
///    - `Dictionary`
///    - `RawRepresentable` types
public protocol UDSerializable {

    /// The type of the value that is stored in `UserDefaults`.
    associatedtype StoredValue

    /// The value to store in `UserDefaults`.
    var storedValue: StoredValue { get }

    /// Initializes the object using the provided value.
    ///
    /// - Parameter storedValue: The previously store value fetched from `UserDefaults`.
    init(storedValue: StoredValue)
}

/// :nodoc:
extension Bool: UDSerializable {
    public var storedValue: Self { self }

    public init(storedValue: Self) {
        self = storedValue
    }
}

/// :nodoc:
extension Int: UDSerializable {
    public var storedValue: Self { self }

    public init(storedValue: Self) {
        self = storedValue
    }
}

/// :nodoc:
extension UInt: UDSerializable {
    public var storedValue: Self { self }

    public init(storedValue: Self) {
        self = storedValue
    }
}

/// :nodoc:
extension Float: UDSerializable {
    public var storedValue: Self { self }

    public init(storedValue: Self) {
        self = storedValue
    }
}

/// :nodoc:
extension Double: UDSerializable {
    public var storedValue: Self { self }

    public init(storedValue: Self) {
        self = storedValue
    }
}

/// :nodoc:
extension String: UDSerializable {
    public var storedValue: Self { self }

    public init(storedValue: Self) {
        self = storedValue
    }
}

/// :nodoc:
extension URL: UDSerializable {
    public var storedValue: Self { self }

    public init(storedValue: Self) {
        self = storedValue
    }
}

/// :nodoc:
extension Date: UDSerializable {
    public var storedValue: Self { self }

    public init(storedValue: Self) {
        self = storedValue
    }
}

/// :nodoc:
extension Data: UDSerializable {
    public var storedValue: Self { self }

    public init(storedValue: Self) {
        self = storedValue
    }
}

/// :nodoc:
extension Array: UDSerializable where Element: UDSerializable {
    public var storedValue: [Element.StoredValue] {
        self.map { $0.storedValue }
    }

    public init(storedValue: [Element.StoredValue]) {
        self = storedValue.map { Element(storedValue: $0) }
    }
}

/// :nodoc:
extension Set: UDSerializable where Element: UDSerializable {
    public var storedValue: [Element.StoredValue] {
        self.map { $0.storedValue }
    }

    public init(storedValue: [Element.StoredValue]) {
        self = Set(storedValue.map { Element(storedValue: $0) })
    }
}

/// :nodoc:
extension Dictionary: UDSerializable where Key == String, Value: UDSerializable {
    public var storedValue: [String: Value.StoredValue] {
        self.mapValues { $0.storedValue }
    }

    public init(storedValue: [String: Value.StoredValue]) {
        self = storedValue.mapValues { Value(storedValue: $0) }
    }
}

/// :nodoc:
extension UDSerializable where Self: RawRepresentable, Self.RawValue: UDSerializable {
    public var storedValue: RawValue.StoredValue { self.rawValue.storedValue }

    public init(storedValue: RawValue.StoredValue) {
        self = Self(rawValue: Self.RawValue(storedValue: storedValue))!
    }
}
