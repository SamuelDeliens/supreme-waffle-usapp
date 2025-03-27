//
//  LocalFileManagerView.swift
//  USApp
//
//  Created by Johann FOURNIER on 26/12/2024.
//

import SwiftUI

struct LocalFileManagerView: View {
    @StateObject private var viewModel = LocalFileManagerViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                // MARK: - Licence Number
                VStack(alignment: .leading, spacing: 5) {
                    Text("Numéro de licence FFA")
                        .font(.headline)
                        .foregroundColor(.blue)
                    TextField("Entrez votre numéro de licence", text: $viewModel.licenceNumber)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                // MARK: - Personal Records
                VStack(alignment: .leading, spacing: 10) {
                    recordField(title: "5 km", value: $viewModel.record5K)
                    recordField(title: "10 km", value: $viewModel.record10K)
                    recordField(title: "Semi-marathon", value: $viewModel.recordSemi)
                    recordField(title: "Marathon", value: $viewModel.recordMarathon)
                }

                // MARK: - Save Button
                HStack {
                    Spacer()
                    Button("Sauvegarder") {
                        viewModel.save()
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
                if viewModel.showSaveConfirmation {
                    Text("👍 Données enregistrées !")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                        .transition(.opacity)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    viewModel.showSaveConfirmation = false
                                }
                            }
                        }
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            viewModel.load()
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
}


// MARK: - Preview
#Preview {
    LocalFileManagerView()
}
