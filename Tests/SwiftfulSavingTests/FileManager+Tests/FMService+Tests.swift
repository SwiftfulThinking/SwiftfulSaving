//
//  FMService+Tests.swift
//  SwiftfulSavingTests
//
//  Created by Nick Sarno on 1/2/22.
//

import XCTest
@testable import SwiftfulSaving

// Naming structure:    test_UnitOfWork_StateUnderTest_ExpectedBehavior
// Test structure:      Given, When, Then

class FMService_Tests: XCTestCase {

    var service: FMService?
    
    override func setUpWithError() throws {
        guard service == nil else { return }
        let dir = FMDirectory(directory: .cachesDirectory)
        let service = FMService(directory: dir, folderName: "FMServiceTest")
        self.service = service
    }

    override func tearDownWithError() throws {
        
    }
    
    func test_FMService_getObject_objectNotFound() async {
        for _ in 0..<100 {
            // Given
            let key: String = .randomString()

            // When
            let object: UIImage? = try? await service?.object(key: key)
            
            // Then
            print(key)
            XCTAssertNil(object)
        }
        await test_FMService_deleteFolder()
    }
    
    func test_FMService_getObject_objectFound() async {
        for _ in 0..<100 {
            // Given
            let key: String = .randomString()

            // When
            guard let image = UIImage.random() else {
                XCTFail()
                return
            }
            
            let url = try? await service?.save(object: image, key: key)
            let object: UIImage? = try? await service?.object(key: key)
            
            // Then
            XCTAssertNotNil(url)
            XCTAssertNotNil(object)
        }
        await test_FMService_deleteFolder()
    }
    
    func test_FMService_saveObject_objectSaved() async {
        for _ in 0..<100 {
            // Given
            let key: String = .randomString()

            // When
            guard let image = UIImage.random() else {
                XCTFail()
                return
            }
            
            let url = try? await service?.save(object: image, key: key)
            
            // Then
            XCTAssertNotNil(url)
        }
        
        await test_FMService_deleteFolder()
    }
    
    func test_FMService_deleteObject_objectDeleted() async {
        for _ in 0..<100 {
            // Given
            let key: String = .randomString()

            // When
            guard let image = UIImage.random() else {
                XCTFail()
                return
            }
            
            let _ = try? await service?.save(object: image, key: key)
            
            // Then
            do {
                try await service?.delete(key: key, ext: UIImage.fileExtension)
            } catch {
                XCTFail()
            }
        }
    }
    
    func test_FMService_deleteFolder() async {
        do {
            try await service?.deleteFolder()
        } catch {
            XCTFail()
        }
    }
    
    func test_FMService_directoryLimits() async {
        let limit: Double? = Double.random(in: 0...10)
        let dir = FMDirectory(directory: .cachesDirectory, limitInMB: limit)
        let service = FMService(directory: dir, folderName: "fmdirectorytest")
        
        let initLimits = await service.directoryUsage()
        XCTAssertEqual(initLimits.limit, limit?.convertingMBToBytes)
        
        guard let image = UIImage.random(size: CGSize(width: 800, height: 800)) else {
            XCTFail()
            return
        }
        let data = image.jpegData(compressionQuality: 1)?.bytes ?? 0
        
        let loopCount = 100
        for _ in 0..<loopCount {
            let key: String = .randomString()
            let _ = try? await service.save(object: image, key: key)
        }
        
        let dirLimits = await service.directoryUsage()
        let expectedSize = min(loopCount * data, dirLimits.limit)
        let accuracy = 300000  // 0.3 mb
        XCTAssertEqual(dirLimits.size ?? 0, expectedSize, accuracy: accuracy)
        
        try? await service.deleteFolder()
    }
    
    func test_FMService_folderLimits() async {
        let limit: Double? = Double.random(in: 0...10)
        let dir = FMDirectory(directory: .cachesDirectory)
        let service = FMService(directory: dir, folderName: "fmfoldertest", folderLimitInMB: limit)
        
        let initLimits = await service.folderUsage()
        XCTAssertEqual(initLimits.limit, limit?.convertingMBToBytes)
        
        guard let image = UIImage.random(size: CGSize(width: 800, height: 800)) else {
            XCTFail()
            return
        }
        let data = image.jpegData(compressionQuality: 1)?.bytes ?? 0
        
        let loopCount = 100
        for _ in 0..<loopCount {
            let key: String = .randomString()
            let _ = try? await service.save(object: image, key: key)
        }
        
        let folderLimits = await service.folderUsage()
        let expectedSize = min(loopCount * data, folderLimits.limit)
        let accuracy = 300000  // 0.3 mb
        XCTAssertEqual(folderLimits.size ?? 0, expectedSize, accuracy: accuracy)
        
        try? await service.deleteFolder()
    }
    
    func test_FMService_folderAndDirectoryLimits() async {
        let limitFolder: Double? = Double.random(in: 0...10)
        let limitDirectory: Double? = Double.random(in: 0...10)
        let dir = FMDirectory(directory: .cachesDirectory, limitInMB: limitDirectory)
        let service = FMService(directory: dir, folderName: "fmfolderanddirectorytest", folderLimitInMB: limitFolder)
        
        let initFolderLimits = await service.folderUsage()
        XCTAssertEqual(initFolderLimits.limit, limitFolder?.convertingMBToBytes)
        let initDirectoryLimits = await service.directoryUsage()
        XCTAssertEqual(initDirectoryLimits.limit, limitDirectory?.convertingMBToBytes)

        guard let image = UIImage.random(size: CGSize(width: 800, height: 800)) else {
            XCTFail()
            return
        }
        let data = image.jpegData(compressionQuality: 1)?.bytes ?? 0
        
        let loopCount = 100
        for _ in 0..<loopCount {
            let key: String = .randomString()
            let _ = try? await service.save(object: image, key: key)
        }
        
        let accuracy = 300000  // 0.3 mb
        let imagesAggregateSize = loopCount * data
        let folderLimits = await service.folderUsage()
        let directoryLimits = await service.directoryUsage()
        let expectedSize = min(imagesAggregateSize, folderLimits.limit, directoryLimits.limit)
        XCTAssertEqual(folderLimits.size ?? 0, expectedSize, accuracy: accuracy)
        XCTAssertEqual(directoryLimits.size ?? 0, expectedSize, accuracy: accuracy)

        try? await service.deleteFolder()
    }
    
    func test_FMService_cacheLimits() async {
        let limit: Double? = Double.random(in: 0...10)
        let dir = FMDirectory(directory: .cachesDirectory)
        let service = FMService(directory: dir, folderName: "fmfoldertest", cacheLimitInMB: limit)
        
        let initLimits = await service.cacheUsage()
        XCTAssertEqual(initLimits.limit, limit?.convertingMBToBytes)
    }
    
}
