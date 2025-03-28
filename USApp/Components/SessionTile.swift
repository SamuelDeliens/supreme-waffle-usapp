//
//  SessionTile.swift
//  USApp
//
//  Created by Johann FOURNIER on 13/12/2024.
//
//
//  SessionTile.swift
//  USApp
//
//  Created by Johann FOURNIER on 13/12/2024.
//

import SwiftUI
import EventKit
import EventKitUI
import MapKit

// Coordinateur pour gérer la délégation entre UIKit et SwiftUI
class EventEditViewCoordinator: NSObject, EKEventEditViewDelegate {
    var parent: EventEditView
    
    init(parent: EventEditView) {
        self.parent = parent
    }
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        parent.presentationMode.wrappedValue.dismiss()
        parent.completion(action != .canceled)
    }
}

// Vue UIKit wrapper pour EKEventEditViewController
struct EventEditView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    
    var event: EKEvent
    var eventStore: EKEventStore
    var completion: (Bool) -> Void
    
    func makeCoordinator() -> EventEditViewCoordinator {
        return EventEditViewCoordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> EKEventEditViewController {
        let controller = EKEventEditViewController()
        controller.event = event
        controller.eventStore = eventStore
        controller.editViewDelegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: EKEventEditViewController, context: Context) {}
}

struct SessionTile: View {
    let type: String
    let details: String
    let location: String
    let date: String
    
    @State private var showingEventEditView = false
    @State private var eventStore = EKEventStore()
    @State private var event: EKEvent?

    private var icon: (name: String, color: Color) {
        let normalizedType = type.trimmingCharacters(in: .whitespacesAndNewlines)
                                .folding(options: .diacriticInsensitive, locale: .current)
                                .lowercased()

        switch normalizedType {
        case "course", "courses":
            return ("flame.fill", .red)
        case "fractionné", "fractionne":
            return ("stopwatch.fill", .orange)
        case "évènement", "evenement", "événement":
            return ("calendar", .purple)
        case "ppg":
            return ("dumbbell.fill", .green)
        case "endurance", "endurances":
            return ("figure.walk", .blue)
        default:
            return ("questionmark.circle", .gray)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with type icon and calendar action button
            HStack(alignment: .center) {
                HStack(spacing: 8) {
                    Image(systemName: icon.name)
                        .foregroundColor(icon.color)
                        .font(.title3)
                    Text(type.isEmpty ? "Type inconnu" : type)
                        .font(.headline)
                        .foregroundColor(icon.color)
                }
                
                Spacer()
                
                // Calendar action button
                Button(action: prepareCalendarEvent) {
                    Image(systemName: "calendar.badge.plus")
                        .font(.system(size: 18))
                        .foregroundColor(.red)
                        .padding(8)
                        .background(Color.red.opacity(0.1))
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())
            }

            // Details section
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "info.circle")
                    .foregroundColor(.blue)
                Text(details)
                    .font(.body)
                    .foregroundColor(Color("TextTuileView"))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }

            // Location with map button
            HStack(spacing: 8) {
                Image(systemName: "mappin.and.ellipse")
                    .foregroundColor(.green)
                Text(location)
                    .font(.subheadline)
                    .foregroundColor(Color("TextTuileView"))
                
                Spacer()
                Button(action: openInMaps) {
                    Image(systemName: "map")
                        .foregroundColor(.blue)
                        .padding(8)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())
            }

            // Date display
            HStack(spacing: 8) {
                Image(systemName: "calendar")
                    .foregroundColor(.red)
                Text(date)
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(Color("TextTuileView"))
                    .italic()
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("TuileView"))
        .cornerRadius(12)
        .shadow(radius: 2)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .sheet(isPresented: $showingEventEditView) {
            if let event = self.event {
                EventEditView(
                    event: event,
                    eventStore: eventStore,
                    completion: { _ in
                        // Gérer la complétion si nécessaire
                    }
                )
            }
        }
    }
    
    private func openInMaps() {
        let searchQuery = location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "http://maps.apple.com/?q=\(searchQuery)"
        
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func prepareCalendarEvent() {
        eventStore.requestAccess(to: .event) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    let newEvent = EKEvent(eventStore: eventStore)
                    newEvent.title = "\(self.type) - \(self.location)"
                    newEvent.notes = self.details
                    newEvent.location = self.location
                    newEvent.calendar = eventStore.defaultCalendarForNewEvents
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd-MM-yyyy"
                    if let eventDate = dateFormatter.date(from: self.date) {
                        newEvent.startDate = eventDate
                        newEvent.endDate = eventDate.addingTimeInterval(3600) // 1 hour duration
                    }
                    
                    self.event = newEvent
                    self.showingEventEditView = true
                }
            } else if let error = error {
                print("❌ Erreur d'accès au calendrier: \(error.localizedDescription)")
            } else {
                print("⚠️ Accès au calendrier refusé")
            }
        }
    }
}

#Preview {
    SessionTile(
        type: "Course",
        details: "10km race",
        location: "Villeneuve Tolosane",
        date: "18-05-2025"
    )
}
