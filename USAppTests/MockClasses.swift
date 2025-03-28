//
//  MockURLSession.swift
//  USApp
//
//  Created by Samuel DELIENS on 28/03/2025.
//
import Foundation
import Combine
@testable import USApp

// MARK: - Network Mocks

// Cette classe simule URLSession pour les tests
class MockURLSession: URLSessionProtocol {
    var data: Data = Data()
    var response: URLResponse = URLResponse()
    var error: Error? = nil
    var shouldThrowError: Bool = false
    var dataWasCalled: Bool = false
    
    func data(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        dataWasCalled = true
        
        if shouldThrowError, let error = error {
            throw error
        }
        
        return (data, response)
    }
}

class MockCacheService: CacheServiceProtocol {
    var shouldReturnData: Bool = false
    var cachedData: [[String]] = []
    var saveDataCalled: Bool = false
    
    func save<T: Encodable>(_ data: T, forKey key: String) throws {
        saveDataCalled = true
    }
    
    func load<T: Decodable>(forKey key: String) -> T? {
        if shouldReturnData {
            if T.self == [[String]].self {
                return cachedData as? T
            }
        }
        return nil
    }
    
    func clearCache(forKey key: String) throws {
        // Nothing to do for mock
    }
    
    func isDataExpired(forKey key: String, expirationInterval: TimeInterval) -> Bool {
        return !shouldReturnData
    }
    
    func saveData(_ data: [[String]], forKey key: String) {
        saveDataCalled = true
        cachedData = data
    }
    
    func loadData(forKey key: String) -> [[String]]? {
        return shouldReturnData ? cachedData : nil
    }
}

class MockNetworkMonitor: NetworkMonitorProtocol {
    var isConnected: Bool = true
    
    var connectionStatusPublisher: AnyPublisher<Bool, Never> {
        Just(isConnected).eraseToAnyPublisher()
    }
}

class MockNotificationService: NotificationServiceProtocol {
    func requestAuthorization() {
        // Nothing to do for mock
    }
    
    func scheduleRaceNotifications(from data: [[String]]) {
        // Nothing to do for mock
    }
    
    func scheduleNotification(title: String, body: String, at date: Date) {
        // Nothing to do for mock
    }
}

// MARK: - File System Mocks

class MockFileManager: FileManager {
    var fileExists = true
    var files: [String: Data] = [:]
    
    override func fileExists(atPath path: String) -> Bool {
        return fileExists
    }
    
    override func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]? = nil) throws {
        // Do nothing
    }
    
    override func removeItem(at URL: URL) throws {
        files[URL.path] = nil
    }
    
    override func contents(atPath path: String) -> Data? {
        return files[path]
    }
    
    func setContents(_ data: Data, atPath path: String) {
        files[path] = data
    }
}
