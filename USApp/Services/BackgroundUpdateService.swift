//
//  BackgroundUpdateService.swift
//  USApp
//
//  Created by Samuel DELIENS on 27/03/2025.
//

import Foundation

final class BackgroundUpdateService {
    
    func startBackgroundUpdates() {
            Task {
                APIServiceManager.shared.startBackgroundUpdates(forTabId: "groupe")
            }
        }
}
