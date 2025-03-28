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
        DateFormatterUtils.formatDate(rowData[0])
    }
    
    // MARK: - Initialization
    init(rowData: [String]) {
        self.rowData = rowData
    }
    // MARK: - Private Methods
    var eventTitle: String {
            let details = rowData[5]
            guard let parenthesisRange = details.range(of: "(") else {
                return details
            }
            return String(details[..<parenthesisRange.lowerBound]).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        var participants: [String] {
            let details = rowData[5]
            guard let startIndex = details.firstIndex(of: "("),
                  let endIndex = details.lastIndex(of: ")"),
                  startIndex < endIndex else {
                return []
            }
            
            let participantsString = String(details[details.index(after: startIndex)..<endIndex])
            return participantsString
                .components(separatedBy: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
        }

}
