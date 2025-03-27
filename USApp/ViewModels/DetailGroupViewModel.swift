//
//  DetailGroupViewModel.swift
//  USApp
//
//  Created by Jihad RIFI on 27/03/2025.
//

import Foundation

final class DetailGroupViewModel: ObservableObject {
    // MARK: - Properties
    let rowData: [String]
    
    // MARK: - Computed Properties
    var formattedDate: String {
        formatDate(rowData[0])
    }
    
    // MARK: - Initialization
    init(rowData: [String]) {
        self.rowData = rowData
    }
    
    // MARK: - Helpers
    private func formatDate(_ dateString: String) -> String {
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
}
