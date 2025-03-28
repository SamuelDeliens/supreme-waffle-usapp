//
//  DetailsEventUtils2.swift
//  USApp
//
//  Created by Samuel DELIENS on 28/03/2025.
//

extension String {
    func extractEventTitle() -> String {
        guard let parenthesisRange = self.range(of: "(") else {
            return self
        }
        return String(self[..<parenthesisRange.lowerBound]).trimmed()
    }
    
    func extractParticipants() -> [String] {
        guard let startIndex = self.firstIndex(of: "("),
              let endIndex = self.lastIndex(of: ")"),
              startIndex < endIndex else {
            return []
        }
        
        return String(self[self.index(after: startIndex)..<endIndex])
            .components(separatedBy: ",")
            .map { $0.trimmed() }
            .filter { !$0.isEmpty }
    }
    
    private func trimmed() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

