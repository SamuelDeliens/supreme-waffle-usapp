//
//  MainView.swift
//  USApp
//
//  Created by Johann FOURNIER on 12/12/2024.
//

import SwiftUI

// MARK: - MainView
struct MainView: View {
    // MARK: - State Variables
    @State private var selectedTab: Tab = .groupe
    @AppStorage("selectedProfile") private var selectedProfile: String?
    @State private var showProfileSelection: Bool = false
    @State private var showInformationSheet: Bool = false
    @State private var isShowingFutureSessions: Bool = true
    @State private var searchQuery: String = ""

    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: - Background Gradient
                backgroundGradient

                VStack(spacing: 10) {
                    // MARK: - Header
                    header

                    // MARK: - Title
                    title

                    // MARK: - Search Bar
                    if selectedTab != .ffa {
                        SearchBar(placeholder: "Rechercher une séance ou une course", text: $searchQuery)
                            .padding(.horizontal)
                    }

                    // MARK: - Content
                    content

                    Spacer()
                }

                // MARK: - Toolbar
                toolbar
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showProfileSelection) {
                ProfileSelectionView(
                    selectedProfile: $selectedProfile,
                    showProfileSelection: $showProfileSelection
                )
            }
            .sheet(isPresented: $showInformationSheet) {
                InformationSheet()
            }
        }
    }

    // MARK: - Background Gradient
    private var backgroundGradient: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.red.opacity(0.3),
                        Color.purple.opacity(0.3),
                        Color.blue.opacity(0.3)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ForEach(0..<8, id: \.self) { index in
                    Path { path in
                        let spacing = geometry.size.width / 9
                        let x = spacing * CGFloat(index + 1)
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                    }
                    .stroke(Color.white.opacity(0.2), lineWidth: 2)
                }
            }
        }
    }

    // MARK: - Header
    private var header: some View {
        HStack {
            if selectedTab == .individuel {
                ProfileSelector(
                    selectedProfile: $selectedProfile,
                    showProfileSelection: $showProfileSelection
                )
            }
            Spacer()

            if selectedTab != .ffa {
                Button(action: {
                    isShowingFutureSessions.toggle()
                }) {
                    Image(systemName: isShowingFutureSessions ? "calendar" : "clock.arrow.circlepath")
                        .font(.system(size: 24))
                        .foregroundColor(.blue)
                }
                .padding(.trailing, 10)
                .accessibilityLabel(isShowingFutureSessions ? "Voir séances passées" : "Voir séances futures")
            }

            Button(action: {
                showInformationSheet.toggle()
            }) {
                Image(systemName: "info.circle")
                    .font(.system(size: 24))
                    .foregroundColor(.blue)
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Title
    private var title: some View {
        HStack {
            Text(
                selectedTab == .groupe ? "Séances de l'US Athlé" :
                selectedTab == .individuel ? "Séances perso" :
                "Fiche FFA"
            )
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(Color("TitreView"))
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal)
    }

    // MARK: - Content
    private var content: some View {
        ScrollView {
            if selectedTab == .groupe {
                GroupView(searchQuery: $searchQuery, isShowingFutureSessions: isShowingFutureSessions)
                    .background(Color.clear)
            } else if selectedTab == .individuel {
                IndividualView(
                    selectedProfile: $selectedProfile,
                    showProfileSelection: $showProfileSelection,
                    isShowingFutureSessions: isShowingFutureSessions,
                    searchQuery: $searchQuery
                )
                .background(Color.clear)
            } else if selectedTab == .ffa {
                LocalFileManagerView()
                    .background(Color.clear)
            }
        }
    }

    // MARK: - Toolbar
    private var toolbar: some View {
        VStack {
            Spacer()
            Toolbar(selectedTab: $selectedTab, topOffset: 0)
                .background(Color("ToolBarColor").opacity(0.8))
                .frame(height: 30)
                .ignoresSafeArea(edges: .bottom)
        }
    }
}

// MARK: - Preview
#Preview {
    MainView()
}
