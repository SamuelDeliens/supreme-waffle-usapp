//
//  KeychainServiceTests.swift
//  USApp
//
//  Created by Samuel DELIENS on 28/03/2025.
//


import XCTest
@testable import USApp

class KeychainServiceTests: XCTestCase {
    
    var keychainService: KeychainService!
    
    override func setUp() {
        super.setUp()
        keychainService = KeychainService.shared
        // Clean up any existing test key
        try? keychainService.delete(key: "testKey")
    }
    
    override func tearDown() {
        try? keychainService.delete(key: "testKey")
        super.tearDown()
    }
    
    func testSaveRetrieveAndDeleteKey() {
        // Arrange
        let testKey = "testKey"
        let testValue = "testValue"
        
        // Act - Save
        do {
            try keychainService.save(key: testKey, value: testValue)
            
            // Retrieve
            let retrievedValue = try keychainService.retrieve(key: testKey)
            
            // Delete
            try keychainService.delete(key: testKey)
            let deletedValue = try keychainService.retrieve(key: testKey)
            
            // Assert
            XCTAssertNotNil(retrievedValue)
            XCTAssertEqual(retrievedValue, testValue)
            XCTAssertNil(deletedValue)
        } catch {
            XCTFail("Should not throw error: \(error)")
        }
    }
    
    func testUpdateKey() {
        // Arrange
        let testKey = "testKey"
        let initialValue = "initialValue"
        let updatedValue = "updatedValue"
        
        // Act
        do {
            try keychainService.save(key: testKey, value: initialValue)
            try keychainService.update(key: testKey, value: updatedValue)
            let retrievedValue = try keychainService.retrieve(key: testKey)
            
            // Assert
            XCTAssertEqual(retrievedValue, updatedValue)
        } catch {
            XCTFail("Should not throw error: \(error)")
        }
    }
}