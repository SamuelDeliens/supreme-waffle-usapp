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
}
