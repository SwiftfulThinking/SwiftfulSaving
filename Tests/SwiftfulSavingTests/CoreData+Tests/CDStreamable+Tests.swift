//
//  CDStreamable+Tests.swift
//  SwiftfulSavingTests
//
//  Created by Nick Sarno on 1/9/22.
//
import XCTest
@testable import SwiftfulSaving
import CoreData

// FIXME: CD TESTS ARE CURRENTLY FAILING
// Below tests succeed in a test project, but not within this framework.
// The ItemContainer is not part of the regular Bundle and must be loaded in a special way.
// 1. Change ItemContainer -> CDItemContainer
// 2. Change ItemEntity -> CDItemEntity
// 3. Change Item -> CDItem
// 4. Figure out how to initialize CoreData container for below tests:
// https://stackoverflow.com/questions/65137756/nspersistentcontainer-will-load-in-app-wont-load-in-test-target
// https://stackoverflow.com/questions/50004553/get-all-urls-for-resources-in-sub-directory-in-swift
// https://developer.apple.com/documentation/coredata/setting_up_a_core_data_stack/setting_up_a_core_data_stack_manually

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
    
    let service = CDService(container: CDContainer(name: "ItemContainer"), contextName: "CoreDataTest", cacheLimitInMB: nil)
    
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
