//
//  DetailIndividualViewModel.swift
//  USApp
//
//  Created by Samuel DELIENS on 27/03/2025.
//

import Foundation

final class DetailIndividualViewModel: ObservableObject {
    // MARK: - Properties
    let rowData: [String]
    @Published var selectedProfile: String?
    
    // MARK: - Computed Properties
    var formattedDate: String {
        DateFormatterUtils.formatDate(rowData[0])
    }
    
    // MARK: - Initialization
    init(rowData: [String], selectedProfile: String?) {
        self.rowData = rowData
        self.selectedProfile = selectedProfile
    }
}
