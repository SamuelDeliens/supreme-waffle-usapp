//
//  APIServiceTests.swift
//  USApp
//
//  Created by Samuel DELIENS on 28/03/2025.
//

import XCTest
@testable import USApp

class APIServiceTests: XCTestCase {
    
    var mockURLSession: MockURLSession!
    var mockCacheService: MockCacheService!
    var apiService: APIServiceManager!
    
    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession()
        mockCacheService = MockCacheService()
        // Nous devons créer un protocole URLSessionProtocol dans le projet principal
        // Pour les tests, on peut faire une modification temporaire pour accepter le MockURLSession
        let googleAPI = GoogleSheetAPI(cacheService: mockCacheService, urlSession: URLSession.shared)
        let notificationService = MockNotificationService()
        let networkMonitor = MockNetworkMonitor()
        apiService = APIServiceManager(googleAPI: googleAPI, notificationService: notificationService, networkMonitor: networkMonitor)
    }
    
    override func tearDown() {
        mockURLSession = nil
        mockCacheService = nil
        apiService = nil
        super.tearDown()
    }
    
    func testFetchSheetDataWithCache() async {
        // Arrange
        mockCacheService.shouldReturnData = true
        let testData = [["Date", "Warmup", "Duration"], ["10-01-2025", "20min", "40min"]]
        mockCacheService.cachedData = testData
        
        // Act
        do {
            let result = try await apiService.fetchSheetData(tabId: "groupe", useCache: true)
            
            // Assert
            XCTAssertEqual(result, [testData[1]])
            XCTAssertFalse(mockURLSession.dataWasCalled)
        } catch {
            XCTFail("Should not throw error: \(error)")
        }
    }
}
