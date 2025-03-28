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
    
    func testFetchAllRowsSuccess() async {
        // Arrange
        mockURLSession.data = """
        {
            "values": [
                ["Header1", "Header2", "Header3"],
                ["Value1", "Value2", "Value3"]
            ]
        }
        """.data(using: .utf8)!
        mockURLSession.response = HTTPURLResponse(url: URL(string: "https://test.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        
        // Act
        do {
            let result = try await googleSheetAPI.fetchAllRows(tabName: "groupe", useCache: false)
            
            // Assert
            XCTAssertEqual(result.count, 1) // We should get 1 row (header removed)
            XCTAssertEqual(result[0][0], "Value1")
            XCTAssertTrue(mockCacheService.saveDataCalled)
        } catch {
            XCTFail("Should not throw error: \(error)")
        }
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
    
    func testFetchAllRowsClientError() async {
        // Arrange
        mockURLSession.response = HTTPURLResponse(url: URL(string: "https://test.com")!, statusCode: 404, httpVersion: nil, headerFields: nil)!
        
        // Act & Assert
        do {
            _ = try await googleSheetAPI.fetchAllRows(tabName: "groupe", useCache: false)
            XCTFail("Should throw error")
        } catch {
            XCTAssertTrue(error is NetworkError)
            if let networkError = error as? NetworkError {
                switch networkError {
                case .clientError(let code):
                    XCTAssertEqual(code, 404)
                default:
                    XCTFail("Wrong error type")
                }
            }
        }
    }
    
    func testFetchAllRowsServerError() async {
        // Arrange
        mockURLSession.response = HTTPURLResponse(url: URL(string: "https://test.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
        
        // Act & Assert
        do {
            _ = try await googleSheetAPI.fetchAllRows(tabName: "groupe", useCache: false)
            XCTFail("Should throw error")
        } catch {
            XCTAssertTrue(error is NetworkError)
            if let networkError = error as? NetworkError {
                switch networkError {
                case .serverError(let code):
                    XCTAssertEqual(code, 500)
                default:
                    XCTFail("Wrong error type")
                }
            }
        }
    }
}
