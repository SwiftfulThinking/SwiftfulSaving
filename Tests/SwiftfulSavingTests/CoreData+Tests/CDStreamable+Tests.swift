//
//  CDStreamable+Tests.swift
//  SwiftfulSavingTests
//
//  Created by Nick Sarno on 1/9/22.
//
import XCTest
@testable import SwiftfulSaving

class CDStreamable_Tests: XCTestCase {

    struct MockModel: CoreDataTransformable {
        
        let title: String
        
        init?(from: ItemEntity) {
            guard let title = from.title else { return nil }
            self.title = title
        }
        
        func updatingValues(forEntity: inout ItemEntity) {
            forEntity.title = title
        }
        
        var entity: ItemEntity?
        
        typealias Entity = ItemEntity
        
    }
    
    let service = CDService(container: CDContainer(name: "ItemContainer"), contextName: "cdstest", cacheLimitInMB: nil)
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_FMStreamable_wrappedValue_get_value() async {
        let key: String = .randomString()
        let initModel: Item? = Item(title: .randomString())
        let streamable = CDStreamable(wrappedValue: initModel, key: key, service: service)
        let object: Item? = streamable.wrappedValue
        try? await Task.sleep(nanoseconds: 1_000_000_000)

        XCTAssertNotNil(object)
        XCTAssertEqual(object?.title, initModel?.title)
    }
    
    func test_FMStreamable_wrappedValue_get_nil() async {
        let key: String = .randomString()
        let initModel: Item? = nil
        let streamable = CDStreamable(wrappedValue: initModel, key: key, service: service)
        let object: Item? = streamable.wrappedValue
        try? await Task.sleep(nanoseconds: 1_000_000_000)

        XCTAssertNil(object)
    }
    
    func test_FMStreamable_wrappedValue_set_value() async {
        let key: String = .randomString()
        let initModel: Item? = Item(title: "ALPHA")
        let streamable = CDStreamable(wrappedValue: initModel, key: key, service: service)
        try? await Task.sleep(nanoseconds: 1_000_000_000)

        let newModel: Item? = Item(title: "BETA")
        streamable.wrappedValue = newModel
        try? await Task.sleep(nanoseconds: 3_000_000_000)

        
        let object: Item? = streamable.wrappedValue
        XCTAssertNotNil(object)
        XCTAssertEqual(object?.title, newModel?.title)
    }
    
    func test_FMStreamable_wrappedValue_set_nil() async {
        let key: String = .randomString()
        let initModel: Item? = Item(title: .randomString())
        let streamable = CDStreamable(wrappedValue: initModel, key: key, service: service)
        try? await Task.sleep(nanoseconds: 1_000_000_000)

        let newModel: Item? = nil
        streamable.wrappedValue = newModel
        try? await Task.sleep(nanoseconds: 1_000_000_000)

        
        let object: Item? = streamable.wrappedValue
        XCTAssertNil(object)
    }

}
