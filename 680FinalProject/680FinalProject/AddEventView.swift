//
//  AddEventView.swift
//  680FinalProject
//
//  Created by Michelle Nguyen on 5/12/25.
//

import SwiftUI

struct AddEventView: View {
    @State private var eventName: String = ""
    @State private var eventLocation: String = ""
    @State private var eventDescription: String = ""
    @State private var eventDate: Date = Date()
    @State private var totalCost: String = ""
    @State private var attendees: String = ""
    
    let tripService = TripManager()
    
    var body: some View {
        VStack(spacing: 20) {
            // Title Header
            Text("Create a New Event")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.top)
                .foregroundColor(.primary)

            // Event Name
            VStack(alignment: .leading) {
                Text("Event Name")
                    .font(.headline)
                    .foregroundColor(.secondary)

                TextField("Enter event name", text: $eventName)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.top, 5)
            }

            // Event Location
            VStack(alignment: .leading) {
                Text("Location")
                    .font(.headline)
                    .foregroundColor(.secondary)

                TextField("Enter location", text: $eventLocation)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.top, 5)
            }

            // Event Description
            VStack(alignment: .leading) {
                Text("Description")
                    .font(.headline)
                    .foregroundColor(.secondary)

                TextField("Enter description", text: $eventDescription)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.top, 5)
            }

            // Event Date Picker
            VStack(alignment: .leading) {
                Text("Event Date")
                    .font(.headline)
                    .foregroundColor(.secondary)

                DatePicker("Select date", selection: $eventDate, displayedComponents: [.date, .hourAndMinute])
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
            }

            // Total Cost
            VStack(alignment: .leading) {
                Text("Total Cost")
                    .font(.headline)
                    .foregroundColor(.secondary)

                TextField("Enter total cost", text: $totalCost)
                    .padding()
                    .keyboardType(.decimalPad)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.top, 5)
            }

            // Attendees
            VStack(alignment: .leading) {
                Text("Attendees (comma separated)")
                    .font(.headline)
                    .foregroundColor(.secondary)

                TextField("Enter attendee names", text: $attendees)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.top, 5)
            }

            // Add Event Button
            Button(action: {
                // Handle adding the event logic here
                addEvent()
            }) {
                Text("Add Event")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top)

            Spacer()
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]), startPoint: .top, endPoint: .bottom))
        .cornerRadius(20)
        .shadow(radius: 10)
    }

    // Add event logic (simplified for now)
    private func addEvent() {
        // Add your logic here for saving the event
        if let cost = Double(totalCost), !attendees.isEmpty {
            let attendeeList = attendees.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            print("Event: \(eventName), Cost: \(cost), Attendees: \(attendeeList)")
        } else {
            print("Please fill out all fields correctly!")
        }
    }
}

struct eventData {
    var EventName: String
    var EventDate: Date
    var EventDescirption: String
}
#Preview {
    AddEventView()
}
