//
//  AddEventView.swift
//  680FinalProject
//
//  Created by Michelle Nguyen on 5/12/25.
//

import SwiftUI

struct AddEventView: View {
    @State private var eventName: String = ""
    @State private var eventDescription: String = ""
    @State private var eventDate: Date = Date()
    
    // Placeholder for a database or API call
    @State private var isEventSaved: Bool = false
    @State private var showConfirmationMessage: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                // Event Name
                TextField("Event Name", text: $eventName)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.top)

                // Event Description
                TextField("Event Description", text: $eventDescription)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.top)

                // Event Date Picker
                DatePicker("Event Date", selection: $eventDate, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding(.top)

                // Save Button
                Button(action: saveEvent) {
                    Text("Save Event")
                        .font(.title2)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top)

                // Confirmation Message
                if showConfirmationMessage {
                    Text(isEventSaved ? "Event successfully saved!" : "Failed to save event.")
                        .foregroundColor(isEventSaved ? .green : .red)
                        .padding(.top)
                }
                
                Spacer()
            }
            .padding()
            .navigationBarTitle("Add New Event")
        }
    }
    
    // Simulate saving the event (DATABASE STUFF HERE)
    private func saveEvent() {

        
        if !eventName.isEmpty && !eventDescription.isEmpty {
            // Simulate a successful save
            isEventSaved = true
        } else {
            // Simulate a failure
            isEventSaved = false
        }
        
        // Show confirmation message
        showConfirmationMessage = true
    }
}

#Preview {
    AddEventView()
}
