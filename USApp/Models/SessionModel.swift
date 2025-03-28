//
//  SessionModel.swift
//  USApp
//
//  Created by Samuel DELIENS on 28/03/2025.
//


//
//  SessionModel.swift
//  USApp
//
//  Created on 28/03/2025.
//

import Foundation

/// Model representing a training session
struct SessionModel: Codable, Identifiable, Hashable {
    /// Unique identifier for the session
    var id: String { dateString }
    
    /// Date of the session in string format (dd-MM-yyyy)
    let dateString: String
    
    /// Warm-up duration
    let warmup: String
    
    /// Main session duration
    let duration: String
    
    /// Recovery duration
    let recovery: String
    
    /// Type of session (e.g., "Course", "Fractionné")
    let type: String
    
    /// Detailed description of the session
    let details: String
    
    /// Pace information
    let pace: String
    
    /// Location of the session
    let location: String
    
    /// The date object parsed from dateString
    var date: Date? {
        DateFormatterUtils.dateFromString(dateString)
    }
    
    /// Creates a SessionModel from an array of strings
    /// - Parameter row: Array of strings representing a row from the sheet
    /// - Returns: A SessionModel if the row has enough elements, nil otherwise
    static func from(row: [String]) -> SessionModel? {
        guard row.count >= 8 else { return nil }
        
        return SessionModel(
            dateString: row[0],
            warmup: row[1],
            duration: row[2],
            recovery: row[3],
            type: row[4],
            details: row[5],
            pace: row[6],
            location: row[7]
        )
    }
    
    /// Converts the model back to a string array
    /// - Returns: Array of strings representing the session
    func toStringArray() -> [String] {
        [dateString, warmup, duration, recovery, type, details, pace, location]
    }
}

/// Extension to handle arrays of session models
extension Array where Element == SessionModel {
    /// Converts an array of SessionModel to an array of string arrays
    /// - Returns: Array of string arrays
    func toStringArrays() -> [[String]] {
        self.map { $0.toStringArray() }
    }
    
    /// Creates an array of SessionModel from an array of string arrays
    /// - Parameter rows: Array of string arrays
    /// - Returns: Array of SessionModel
    static func from(rows: [[String]]) -> [SessionModel] {
        rows.compactMap { SessionModel.from(row: $0) }
    }
}