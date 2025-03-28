//
//  GoogleSheetAPITests.swift
//  USApp
//
//  Created by Samuel DELIENS on 28/03/2025.
//

import XCTest
@testable import USApp

class GoogleSheetAPITests: XCTestCase {
    
    var mockURLSession: MockURLSession!
    var mockCacheService: MockCacheService!
    var googleSheetAPI: GoogleSheetAPI!
    
    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession()
        mockCacheService = MockCacheService()
        googleSheetAPI = GoogleSheetAPI(cacheService: mockCacheService, urlSession: mockURLSession)
    }
    
    override func tearDown() {
        mockURLSession = nil
        mockCacheService = nil
        googleSheetAPI = nil
        super.tearDown()
    }
    
    func testFetchAllRowsUseCache() async {
        // Arrange
        mockCacheService.shouldReturnData = true
        let testData = [["Date", "Warmup", "Duration"], ["10-01-2025", "20min", "40min"]]
        mockCacheService.cachedData = testData
        
        // Act
        do {
            let result = try await googleSheetAPI.fetchAllRows(tabName: "groupe", useCache: true)
            
            // Assert
            XCTAssertEqual(result, [testData[1]])
            XCTAssertFalse(mockURLSession.dataWasCalled)
        } catch {
            XCTFail("Should not throw error: \(error)")
        }
    }
}
