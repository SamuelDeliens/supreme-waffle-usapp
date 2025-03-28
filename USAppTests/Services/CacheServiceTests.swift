//
//  CacheServiceTests.swift
//  USApp
//
//  Created by Samuel DELIENS on 28/03/2025.
//


import XCTest
@testable import USApp

class CacheServiceTests: XCTestCase {
    
    var cacheService: CacheService!
    var mockFileManager: MockFileManager!
    
    override func setUp() {
        super.setUp()
        mockFileManager = MockFileManager()
        cacheService = CacheService()
    }
    
    override func tearDown() {
        cacheService = nil
        mockFileManager = nil
        super.tearDown()
    }
    
    func testSaveAndLoadData() {
        // Arrange
        let testKey = "testKey"
        let testData = ["test1", "test2", "test3"]
        
        // Act
        do {
            try cacheService.save(testData, forKey: testKey)
            let loadedData: [String]? = cacheService.load(forKey: testKey)
            
            // Assert
            XCTAssertNotNil(loadedData)
            XCTAssertEqual(loadedData, testData)
        } catch {
            XCTFail("Should not throw error: \(error)")
        }
    }
    
    func testClearCache() {
        // Arrange
        let testKey = "testKey"
        let testData = ["test1", "test2", "test3"]
        
        // Act
        do {
            try cacheService.save(testData, forKey: testKey)
            try cacheService.clearCache(forKey: testKey)
            let loadedData: [String]? = cacheService.load(forKey: testKey)
            
            // Assert
            XCTAssertNil(loadedData)
        } catch {
            XCTFail("Should not throw error: \(error)")
        }
    }
    
    func testIsDataExpired() {
        // Arrange
        let testKey = "testKey"
        let testData = ["test1", "test2", "test3"]
        
        // Act
        do {
            try cacheService.save(testData, forKey: testKey)
            
            // Test with not expired data (1 hour expiration)
            let notExpired = cacheService.isDataExpired(forKey: testKey, expirationInterval: 3600)
            
            // Test with expired data (0 seconds expiration)
            let expired = cacheService.isDataExpired(forKey: testKey, expirationInterval: 0)
            
            // Assert
            XCTAssertFalse(notExpired)
            XCTAssertTrue(expired)
        } catch {
            XCTFail("Should not throw error: \(error)")
        }
    }
}
