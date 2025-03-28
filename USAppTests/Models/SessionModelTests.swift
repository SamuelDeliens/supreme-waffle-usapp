//
//  SessionModelTests.swift
//  USApp
//
//  Created by Samuel DELIENS on 28/03/2025.
//


import XCTest
@testable import USApp

class SessionModelTests: XCTestCase {
    
    func testSessionModelFromRow() {
        // Arrange
        let row = ["25-12-2024", "15min", "40min", "10min", "Course", "Sortie longue", "5:30/km", "Parc des Sports"]
        
        // Act
        let session = SessionModel.from(row: row)
        
        // Assert
        XCTAssertNotNil(session)
        XCTAssertEqual(session?.dateString, "25-12-2024")
        XCTAssertEqual(session?.warmup, "15min")
        XCTAssertEqual(session?.duration, "40min")
        XCTAssertEqual(session?.recovery, "10min")
        XCTAssertEqual(session?.type, "Course")
        XCTAssertEqual(session?.details, "Sortie longue")
        XCTAssertEqual(session?.pace, "5:30/km")
        XCTAssertEqual(session?.location, "Parc des Sports")
    }
    
    func testSessionModelFromInvalidRow() {
        // Arrange
        let invalidRow = ["25-12-2024", "15min"] // Too short
        
        // Act
        let session = SessionModel.from(row: invalidRow)
        
        // Assert
        XCTAssertNil(session)
    }
    
    func testDate() {
        // Arrange
        let dateString = "25-12-2024"
        let row = [dateString, "15min", "40min", "10min", "Course", "Sortie longue", "5:30/km", "Parc des Sports"]
        
        // Act
        let session = SessionModel.from(row: row)
        
        // Assert
        XCTAssertNotNil(session?.date)
        
        // Verify it matches the expected date
        let expectedDate = DateFormatterUtils.dateFromString(dateString)
        XCTAssertEqual(session?.date, expectedDate)
    }
    
    func testToStringArray() {
        // Arrange
        let original = ["25-12-2024", "15min", "40min", "10min", "Course", "Sortie longue", "5:30/km", "Parc des Sports"]
        
        // Act
        let session = SessionModel.from(row: original)
        let converted = session?.toStringArray()
        
        // Assert
        XCTAssertNotNil(converted)
        XCTAssertEqual(converted, original)
    }
    
    func testArrayExtensions() {
        // Arrange
        let rows = [
            ["25-12-2024", "15min", "40min", "10min", "Course", "Sortie longue", "5:30/km", "Parc des Sports"],
            ["26-12-2024", "20min", "60min", "15min", "Fractionné", "10x400m", "4:15/km", "Piste"]
        ]
        
        // Act
        let sessions = Array<SessionModel>.from(rows: rows)
        let backToRows = sessions.toStringArrays()
        
        // Assert
        XCTAssertEqual(sessions.count, 2)
        XCTAssertEqual(backToRows.count, 2)
        XCTAssertEqual(backToRows, rows)
    }
}
