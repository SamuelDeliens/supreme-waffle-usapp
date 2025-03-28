//
//  GoogleSheetConfig.swift
//  USApp
//
//  Created by Samuel DELIENS on 28/03/2025.
//


//
//  GoogleSheetConfig.swift
//  USApp
//
//  Created on 28/03/2025.
//

import Foundation

/// Configuration for Google Sheet API
struct GoogleSheetConfig {
    /// API key for accessing Google Sheets API
    static let apiKey = "AIzaSyCFB_HnIZQKpqrP5JxtwO8HpYkktdc6sKk"
    
    /// ID of the spreadsheet to access
    static let spreadsheetId = "1jeLNms9lfRM27GF_2hitAn4agOWaX8PVgBRk7qVsLkE"
    
    /// Name of the group tab
    static let groupTabName = "groupe"
    
    /// Names of individual tabs
    static let individualTabs = [
        "Alexandre", "Amar", "Assia", "Corine", "Fati", "Fethy",
        "Jean-Louis", "Jerome", "Johann", "Lynda", "Maude", "Renaud"
    ]
    
    /// Base URL for the NoCode API
    static let noCodeBaseURL = "https://v1.nocodeapi.com/angelstyle/google_sheets/tHewggNPxxAzjnGk"
    
    /// Interval for background updates in seconds
    static let backgroundUpdateInterval: TimeInterval = 300
}