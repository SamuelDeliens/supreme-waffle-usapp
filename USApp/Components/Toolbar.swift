//
//  Toolbar.swift
//  USApp
//
//  Created by Johann FOURNIER on 12/12/2024.
//

import SwiftUI

enum Tab {
    case groupe
    case individuel
    case ffa
}

struct Toolbar: View {
    @Binding var selectedTab: Tab
    var topOffset: CGFloat = 0

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            HStack {
                Spacer()

                Button(action: {
                    selectedTab = .groupe
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: "person.3.fill")
                            .font(.system(size: 24))
                            .foregroundColor(selectedTab == .groupe ? Color("IconToolBar") : .gray.opacity(0.6))
                        Text("Groupe")
                            .font(.caption)
                            .foregroundColor(selectedTab == .groupe ? Color("IconToolBar") : .gray.opacity(0.6))
                    }
                }

                Spacer()

                Button(action: {
                    selectedTab = .individuel
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 24))
                            .foregroundColor(selectedTab == .individuel ? Color("IconToolBar") : .gray.opacity(0.6))
                        Text("Individuel")
                            .font(.caption)
                            .foregroundColor(selectedTab == .individuel ? Color("IconToolBar") : .gray.opacity(0.6))
                    }
                }

                Spacer()

                Button(action: {
                    selectedTab = .ffa
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: "medal.fill")
                            .font(.system(size: 24))
                            .foregroundColor(selectedTab == .ffa ? Color("IconToolBar") : .gray.opacity(0.6))
                        Text("FFA")
                            .font(.caption)
                            .foregroundColor(selectedTab == .ffa ? Color("IconToolBar") : .gray.opacity(0.6))
                    }
                }

                Spacer()
            }
            .padding(.vertical, 16)
            .background(Color.clear)
            .cornerRadius(0)
            .ignoresSafeArea(edges: .bottom)
            .offset(y: topOffset)
        }
    }
}

#Preview {
    @Previewable @State var selectedTab: Tab = .groupe
    return Toolbar(selectedTab: $selectedTab, topOffset: 10)
}
