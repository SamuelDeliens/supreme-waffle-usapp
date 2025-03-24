//
//  LocalFileManagerView.swift
//  USApp
//
//  Created by Johann FOURNIER on 26/12/2024.
//

import SwiftUI

// MARK: - PersonalRecord Model
struct PersonalRecord: Codable {
    var licenceNumber: String
    var record5K: String
    var record10K: String
    var recordSemi: String
    var recordMarathon: String
}

// MARK: - LocalFileManagerView
struct LocalFileManagerView: View {
    
    // MARK: - State Variables
    @State private var licenceNumber: String = ""
    @State private var record5K: String = ""
    @State private var record10K: String = ""
    @State private var recordSemi: String = ""
    @State private var recordMarathon: String = ""
    @State private var showSaveConfirmation: Bool = false
    private let fileName = "personalRecords.json"

    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                // MARK: - Licence Number
                VStack(alignment: .leading, spacing: 5) {
                    Text("Numéro de licence FFA")
                        .font(.headline)
                        .foregroundColor(.blue)
                    TextField("Entrez votre numéro de licence", text: $licenceNumber)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                // MARK: - Personal Records
                VStack(alignment: .leading, spacing: 10) {
                    recordField(title: "5 km", value: $record5K)
                    recordField(title: "10 km", value: $record10K)
                    recordField(title: "Semi-marathon", value: $recordSemi)
                    recordField(title: "Marathon", value: $recordMarathon)
                }

                // MARK: - Save Button
                HStack {
                    Spacer()
                    Button("Sauvegarder") {
                        saveToFile()
                        showSaveConfirmation = true
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 20)

                // MARK: - Save Confirmation Message
                if showSaveConfirmation {
                    Text("👍 Données enregistrées !")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                        .transition(.opacity)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    showSaveConfirmation = false
                                }
                            }
                        }
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            loadFromFile()
        }
    }

    // MARK: - Record Field
    private func recordField(title: String, value: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.headline)
                .foregroundColor(.blue)
            TextField("Entrez votre record", text: value)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }

    // MARK: - Get Documents Directory
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    // MARK: - Save to File
    private func saveToFile() {
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)

        let record = PersonalRecord(
            licenceNumber: licenceNumber,
            record5K: record5K,
            record10K: record10K,
            recordSemi: recordSemi,
            recordMarathon: recordMarathon
        )

        do {
            let data = try JSONEncoder().encode(record)
            try data.write(to: fileURL, options: .atomic)
            print("✅ Données sauvegardées avec succès dans \(fileName).")
        } catch {
            print("❌ Erreur lors de la sauvegarde des données : \(error.localizedDescription)")
        }
    }

    // MARK: - Load from File
    private func loadFromFile() {
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)

        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            print("📂 Fichier \(fileName) inexistant. Aucune donnée à charger.")
            return
        }

        do {
            let data = try Data(contentsOf: fileURL)
            let record = try JSONDecoder().decode(PersonalRecord.self, from: data)
            licenceNumber = record.licenceNumber
            record5K = record.record5K
            record10K = record.record10K
            recordSemi = record.recordSemi
            recordMarathon = record.recordMarathon
            print("✅ Données chargées depuis le fichier \(fileName).")
        } catch {
            print("❌ Erreur lors du chargement des données : \(error.localizedDescription)")
        }
    }
}

// MARK: - Preview
#Preview {
    LocalFileManagerView()
}
