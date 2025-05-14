//
//  EditEventView.swift
//  680FinalProject
//
//  Created by Michelle Nguyen on 5/12/25.
//

import SwiftUI

struct EditEventView: View {
    
    @State private var eventName: String = "Sample Event"
    @State private var eventLocation: String = "Sample Location"
    @State private var eventDescription: String = "Sample Description"
    @State private var eventDate: Date = Date()

    var body: some View {
        VStack {
            TextField("Event Name", text: $eventName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Location", text: $eventLocation)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Description", text: $eventDescription)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            DatePicker("Event Date", selection: $eventDate)
                .padding()

            Button("Update Event") {
                // Update event logic here
                print("Event Updated: \(eventName)")
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)

            Button("Delete Event") {
                // Remove event logic here
                print("Event Deleted")
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)

            Spacer()
        }
        .padding()
        .navigationBarTitle("Edit Event", displayMode: .inline)
    }
}
