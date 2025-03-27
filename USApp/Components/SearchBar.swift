//
//  SearchBar.swift
//  USApp
//
//  Created by Johann FOURNIER on 12/12/2024.
//

import SwiftUI

struct SearchBar: View {
    let placeholder: String
    @Binding var text: String
    
    private var showClearButton: Bool {
        !text.isEmpty
    }
    
    var body: some View {
        HStack {
            textField
        }
        .padding(.horizontal)
    }
    
    private var textField: some View {
        TextField(placeholder, text: $text)
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay(
                HStack {
                    Spacer()
                    if showClearButton {
                        clearButton
                    }
                }
                .padding(.trailing, 8)
            )
    }
    
    private var clearButton: some View {
        Button(action: clearText) {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.gray)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func clearText() {
        text = ""
    }
}
