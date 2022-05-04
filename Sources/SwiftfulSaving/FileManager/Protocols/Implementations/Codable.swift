//
//  URLTransformable+Codable.swift
//  SwiftfulSaving
//
//  Created by Nick Sarno on 12/30/21.
//

import Foundation

// Note: Cannot extend Codable, so add implementations to Decodable & Encodable instead.

// Currently using JSONDecoder/JSONEncoder as static computed variables bc we don't want to create new ones for every object.
// However, we should find a more performant / elegant way to handle this.

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
    
    init?(data: Data) {
        guard let object = try? Self.jsonDecoder.decode(Self.self, from: data) else { return nil }
        self = object
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
}
