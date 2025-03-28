//
//  NetworkServiceProtocol.swift
//  USApp
//
//  Created by Samuel DELIENS on 28/03/2025.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchSheetData(tabId: String, useCache: Bool) async throws -> [[String]]

    func startBackgroundUpdates(forTabId tabId: String)

    func stopBackgroundUpdates()
}
