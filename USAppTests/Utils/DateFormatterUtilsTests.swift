//
//  DateFormatterUtilsTests.swift
//  USApp
//
//  Created by Samuel DELIENS on 28/03/2025.
//


import XCTest
@testable import USApp

class DateFormatterUtilsTests: XCTestCase {
    
    func testFormatDate() {
        // Test French locale formatting
        let formattedDate = DateFormatterUtils.formatDate("25-12-2024")
        
        // This test will depend on the locale, so we just check it's not the original format
        XCTAssertNotEqual(formattedDate, "25-12-2024")
        // The format should be something like "Mercredi 25 Décembre" (capitalized)
        XCTAssertTrue(formattedDate.first?.isUppercase ?? false)
    }
    
    func testDateFromString() {
        // Test valid date
        let date = DateFormatterUtils.dateFromString("25-12-2024")
        XCTAssertNotNil(date)
        
        // Test invalid date
        let invalidDate = DateFormatterUtils.dateFromString("invalid")
        XCTAssertNil(invalidDate)
        
        // Test components of valid date
        if let validDate = date {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day, .month, .year], from: validDate)
            XCTAssertEqual(components.day, 25)
            XCTAssertEqual(components.month, 12)
            XCTAssertEqual(components.year, 2024)
        }
    }
}
