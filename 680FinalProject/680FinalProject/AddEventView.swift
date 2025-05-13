//
//  AddEventView.swift
//  680FinalProject
//
//  Created by Michelle Nguyen on 5/12/25.
//  And Majd Alnajjar on 5/13/25
//

import SwiftUI

struct AddEventView: View {
    @Binding var auth: testAuth

    @State private var eventName: String = ""
    @State private var eventLocation: String = ""
    @State private var eventDescription: String = ""
    @State private var eventDate: Date = Date()
    @State private var totalCost: String = ""
    @State private var attendees: String = ""

    @State private var successMessage: String?
    @State private var errorMessage: String?

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
                Task { await addEvent() }
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

            // Feedback Messages
            if let success = successMessage {
                Text(success)
                    .foregroundColor(.green)
            }
            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }

            Spacer()
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]), startPoint: .top, endPoint: .bottom))
        .cornerRadius(20)
        .shadow(radius: 10)
    }

    // Add event and write to Firestore
    private func addEvent() async {
        guard let cost = Double(totalCost),
              !eventName.isEmpty,
              !eventLocation.isEmpty,
              !eventDescription.isEmpty,
              !attendees.isEmpty else {
            errorMessage = "Please fill out all fields correctly."
            return
        }

        let attendeeList = attendees
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

        let success = await tripService.createEvent(
            eventName: eventName,
            location: eventLocation,
            description: eventDescription,
            cost: cost,
            attendees: attendeeList
        )

        if success {
            successMessage = "Event added successfully!"
            errorMessage = nil

            // Note: if you want to use the real eventID from Firestore, you'll need to modify TripManager to return it
            await tripService.costSplit(
                eventID: UUID().uuidString, // Temporary ID; replace with real Firestore event ID if needed
                cost: cost,
                attendees: attendeeList,
                eventName: eventName
            )
        } else {
            errorMessage = "Failed to add event."
            successMessage = nil
        }
    }
}

#Preview {
    AddEventView(auth: .constant(testAuth()))
}
