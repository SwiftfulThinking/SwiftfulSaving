//
//  UDStreamable+Tests.swift
//  SwiftfulSavingTests
//
//  Created by Nick Sarno on 1/3/22.
//

import Foundation

import XCTest
@testable import SwiftfulSaving

class UDStreamable_Tests: XCTestCase {
    
    let service = UDService(suiteName: "UDTestSuite")
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_UDStreamable_wrappedValue_get_value() async {
        let key: String = .randomString()
        let value: String = .randomString()
        let streamable = UDStreamable(wrappedValue: value, key: key, service: service)
        let object: String? = streamable.wrappedValue

        XCTAssertNotNil(object)
        XCTAssertEqual(object, value)
    }
    
    func test_UDStreamable_wrappedValue_get_nil() async {
        let key: String = .randomString()
        let value: String? = nil
        let streamable = UDStreamable(wrappedValue: value, key: key, service: service)
        let object: String? = streamable.wrappedValue

        XCTAssertNil(object)
    }
    
    func test_UDStreamable_wrappedValue_set_value() async {
        let key: String = .randomString()
        let value: String? = nil
        let streamable = UDStreamable(wrappedValue: value, key: key, service: service)
        let newValue: String = .randomString()
        streamable.wrappedValue = newValue
        try? await Task.sleep(nanoseconds: 1_000_000_000)

        
        let object = streamable.wrappedValue
        XCTAssertNotNil(object)
        XCTAssertEqual(object, newValue)
    }
    
    func test_FMStreamable_wrappedValue_set_nil() async {
        SwiftfulSaving.addLogging(service: .userDefaults, actions: [.write, .read, .delete, .notFound])
        let key: String = .randomString()
        let value: String? = .randomString()
        let streamable = UDStreamable(wrappedValue: value, key: key, service: service)
        let newValue: String? = nil
        streamable.wrappedValue = newValue
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        let object = streamable.wrappedValue
        XCTAssertNil(object)
    }

}
