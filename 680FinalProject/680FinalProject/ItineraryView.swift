//
//  itineraryView.swift
//  680FinalProject
//
//  Created by Michelle Nguyen on 5/9/25.
//

import SwiftUI

struct ItineraryView: View {
    // Sample data for display
    @State private var itinerary: [ItineraryDay] = sampleItinerary

    var body: some View {
        ScrollView {  // Wrap the entire content in ScrollView
            VStack(alignment: .leading) {
                Text("Your Trip Itinerary")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)

                ForEach(itinerary) { day in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(day.dateFormatted)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.bottom, 5)

                        ForEach(day.events) { event in
                            EventCardView(event: event)
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
            .padding()
            NavigationLink(destination: AddEventView()){
                Text("Create Event")
            }
        }
        // Removed redundant navigation bar title to avoid stacking headers
    }
}

// MARK: - Supporting Models

struct ItineraryDay: Identifiable {
    let id = UUID()
    let date: Date
    let events: [TripEvent]

    var dateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
}

struct TripEvent: Identifiable {
    let id = UUID()
    let time: String
    let location: String
    let description: String
}

// MARK: - Sample Data

let sampleItinerary: [ItineraryDay] = [
    ItineraryDay(date: Date(), events: [
        TripEvent(time: "9:00 AM", location: "Hotel Lobby", description: "Meet for breakfast"),
        TripEvent(time: "11:00 AM", location: "Art Museum", description: "Guided tour"),
        TripEvent(time: "2:00 PM", location: "Cafe del Mar", description: "Lunch break")
    ]),
    ItineraryDay(date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, events: [
        TripEvent(time: "10:00 AM", location: "Central Park", description: "Picnic & games"),
        TripEvent(time: "1:00 PM", location: "Food Market", description: "Try local bites"),
        TripEvent(time: "5:00 PM", location: "Riverside Walk", description: "Evening stroll")
    ])
]

// MARK: - Reusable Card View

struct EventCardView: View {
    var event: TripEvent

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: "clock")
                .frame(width: 32, height: 32)
                .foregroundColor(.blue)

            VStack(alignment: .leading) {
                Text(event.time)
                    .font(.headline)

                Text(event.location)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(event.description)
                    .font(.body)
            }

            Spacer()
            NavigationLink(destination: EditEventView()){
                Text("Edit Event")
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
    }
}

#Preview {
    ItineraryView()
}
