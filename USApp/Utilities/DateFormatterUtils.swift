//
//  DateFormatterHelper.swift
//  USApp
//
//  Created by Samuel DELIENS on 27/03/2025.
//


// DateFormatterUtils.swift
import Foundation

struct DateFormatterUtils {
    
    static func formatDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd-MM-yyyy"
        
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "fr_FR")
        outputFormatter.dateFormat = "EEEE d MMMM"
        
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date).capitalized
        }
        return dateString
    }
    
    static func dateFromString(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.date(from: dateString)
    }
    
}
