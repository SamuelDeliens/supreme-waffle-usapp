//
//  ViewModel.swift
//  USApp
//
//  Created by Johann FOURNIER on 14/12/2024.
//

import SwiftUI

class AppViewModel: ObservableObject {
    @Published var selectedTab: Tab = .groupe
    @Published var selectedProfile: String? = nil
    @Published var showProfileSelection: Bool = false
    @Published var showInformationSheet: Bool = false
}
