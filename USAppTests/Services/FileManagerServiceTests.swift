//
//  FileManagerServiceTests.swift
//  USApp
//
//  Created by Samuel DELIENS on 28/03/2025.
//


import XCTest
@testable import USApp

class FileManagerServiceTests: XCTestCase {
    
    var fileManagerService: FileManagerService!
    
    override func setUp() {
        super.setUp()
        fileManagerService = FileManagerService()
    }
    
    override func tearDown() {
        fileManagerService = nil
        super.tearDown()
    }
    
    func testSaveAndLoadRecord() {
        // Arrange
        let testRecord = PersonalRecord(
            licenceNumber: "TEST123456",
            record5K: "20:30",
            record10K: "45:10",
            recordSemi: "1:40:20",
            recordMarathon: "3:30:15"
        )
        
        // Act
        fileManagerService.save(record: testRecord)
        let loadedRecord = fileManagerService.load()
        
        // Assert
        XCTAssertNotNil(loadedRecord)
        XCTAssertEqual(loadedRecord?.licenceNumber, testRecord.licenceNumber)
        XCTAssertEqual(loadedRecord?.record5K, testRecord.record5K)
        XCTAssertEqual(loadedRecord?.record10K, testRecord.record10K)
        XCTAssertEqual(loadedRecord?.recordSemi, testRecord.recordSemi)
        XCTAssertEqual(loadedRecord?.recordMarathon, testRecord.recordMarathon)
    }
}