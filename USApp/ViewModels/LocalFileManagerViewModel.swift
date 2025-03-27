//
//  LocalFileManagerViewModel.swift
//  USApp
//
//  Created by Samuel DELIENS on 27/03/2025.
//


// LocalFileManagerViewModel.swift
import SwiftUI

class LocalFileManagerViewModel: ObservableObject {
    private let fileManagerService = FileManagerService()
    
    @Published var licenceNumber: String = ""
    @Published var record5K: String = ""
    @Published var record10K: String = ""
    @Published var recordSemi: String = ""
    @Published var recordMarathon: String = ""
    @Published var showSaveConfirmation: Bool = false

    func load() {
        if let record = fileManagerService.load() {
            licenceNumber = record.licenceNumber
            record5K = record.record5K
            record10K = record.record10K
            recordSemi = record.recordSemi
            recordMarathon = record.recordMarathon
        }
    }

    func save() {
        let record = PersonalRecord(
            licenceNumber: licenceNumber,
            record5K: record5K,
            record10K: record10K,
            recordSemi: recordSemi,
            recordMarathon: recordMarathon
        )
        fileManagerService.save(record: record)
        showSaveConfirmation = true
    }
}
