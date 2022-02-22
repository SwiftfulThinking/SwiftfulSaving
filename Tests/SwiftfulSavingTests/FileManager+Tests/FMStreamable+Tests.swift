//
//  FMStreamable+Tests.swift
//  SwiftfulSavingTests
//
//  Created by Nick Sarno on 1/3/22.
//

import XCTest
@testable import SwiftfulSaving

class FMStreamable_Tests: XCTestCase {

    struct MockModel: Codable, DataTransformable {
        let value: String
    }
    
    let service = FMService(directory: FMDirectory(directory: .cachesDirectory), folderName: "fmstreamabletests")
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_FMStreamable_wrappedValue_get_value() async {
        let key: String = .randomString()
        let initModel: MockModel? = MockModel(value: .randomString())
        let streamable = FMStreamable(wrappedValue: initModel, key: key, service: service)
        let object: MockModel? = streamable.wrappedValue
        try? await Task.sleep(nanoseconds: 1_000_000_000)

        XCTAssertNotNil(object)
        XCTAssertEqual(object?.value, initModel?.value)
    }
    
    func test_FMStreamable_wrappedValue_get_nil() async {
        let key: String = .randomString()
        let initModel: MockModel? = nil
        let streamable = FMStreamable(wrappedValue: initModel, key: key, service: service)
        let object: MockModel? = streamable.wrappedValue
        try? await Task.sleep(nanoseconds: 1_000_000_000)

        XCTAssertNil(object)
    }
    
    func test_FMStreamable_wrappedValue_set_value() async {
        let key: String = .randomString()
        let initModel: MockModel? = MockModel(value: .randomString())
        let streamable = FMStreamable(wrappedValue: initModel, key: key, service: service)
        try? await Task.sleep(nanoseconds: 1_000_000_000)

        let newModel: MockModel? = MockModel(value: .randomString())
        streamable.wrappedValue = newModel
        try? await Task.sleep(nanoseconds: 1_000_000_000)

        
        let object: MockModel? = streamable.wrappedValue
        XCTAssertNotNil(object)
        XCTAssertEqual(object?.value, newModel?.value)
    }
    
    func test_FMStreamable_wrappedValue_set_nil() async {
        let key: String = .randomString()
        let initModel: MockModel? = MockModel(value: .randomString())
        let streamable = FMStreamable(wrappedValue: initModel, key: key, service: service)
        try? await Task.sleep(nanoseconds: 1_000_000_000)

        let newModel: MockModel? = nil
        streamable.wrappedValue = newModel
        try? await Task.sleep(nanoseconds: 1_000_000_000)

        
        let object: MockModel? = streamable.wrappedValue
        XCTAssertNil(object)
    }

}
