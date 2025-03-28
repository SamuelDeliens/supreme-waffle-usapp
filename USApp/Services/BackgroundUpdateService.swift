//
//  BackgroundUpdateService.swift
//  USApp
//
//  Created by Samuel DELIENS on 27/03/2025.
//

import Foundation

final class BackgroundUpdateService {
    private let apiService: NetworkServiceProtocol
    
    init(apiService: NetworkServiceProtocol = APIServiceManager.shared) {
        self.apiService = apiService
    }
    
    func startBackgroundUpdates() {
        Task {
            apiService.startBackgroundUpdates(forTabId: GoogleSheetConfig.groupTabName)
        }
    }
}
