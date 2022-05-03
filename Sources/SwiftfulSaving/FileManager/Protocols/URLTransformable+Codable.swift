//
//  URLTransformable+Codable.swift
//  SwiftfulSaving
//
//  Created by Nick Sarno on 12/30/21.
//

import Foundation

// MARK: ENCODABLE

public extension Encodable {
    
    static var jsonEncoder: JSONEncoder {
        JSONEncoder()
    }
    
    static var fileExtension: FMFileExtension {
        .txt
    }
    func toData() -> Data? {
        try? Self.jsonEncoder.encode(self)
    }
}

// MARK: DECODABLE

public extension Decodable {
        
    static var jsonDecoder: JSONDecoder {
        JSONDecoder()
    }

    init?(url: URL) {
        guard let data = try? Data(contentsOf: url), let object = try? Self.jsonDecoder.decode(Self.self, from: data) else { return nil }
        self = object
    }

    static var canBeCached: Bool {
        true
    }
}

// MARK: CODABLE ARRAY

extension Array: URLTransformable where Element : Codable {
    static var jsonEncoder: JSONEncoder {
        JSONEncoder()
    }
    
    public static var fileExtension: FMFileExtension {
        .txt
    }
    public func toData() -> Data? {
        try? Self.jsonEncoder.encode(self)
    }
    
    static var jsonDecoder: JSONDecoder {
        JSONDecoder()
    }

    public init?(url: URL) {
        guard let data = try? Data(contentsOf: url), let object = try? Self.jsonDecoder.decode(Self.self, from: data) else { return nil }
        self = object
    }

    public static var canBeCached: Bool {
        true
    }
}
