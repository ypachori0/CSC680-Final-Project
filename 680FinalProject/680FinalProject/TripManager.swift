//
//  TripManager.swift
//  680FinalProject
//
//  Created by Thomas Bercasio
//  And Majd Alnajjar
//  On 5/12/2025

import Foundation
import FirebaseFirestore

// MARK: - Event and Expense Service Class
class TripManager {
    private let db = Firestore.firestore()

    // Create a new event document in Firestore
    func createEvent(eventName: String, location: String, description: String, cost: Double, attendees: [String]) async -> Bool {
        let eventData: [String: Any] = [
            "EventName": eventName,
            "Location": location,
            "Description": description,
            "Cost": cost,
            "Time": Timestamp(date: Date()),
            "AttendedBy": attendees
        ]

        do {
            let newRef = db.collection("Event").document()
            try await newRef.setData(eventData)
            print("Event created with ID: \(newRef.documentID)")
            return true
        } catch {
            print("Failed to create event: \(error)")
            return false
        }
    }

    // Get event data by event ID
    func getEventData(eventID: String) async -> [String: Any]? {
        let docRef = db.collection("Event").document(eventID)
        do {
            let document = try await docRef.getDocument()
            if document.exists {
                return document.data()
            }
        } catch {
            print("Failed to fetch event: \(error)")
        }
        return nil
    }

    // Get events attended by the user by checking "AttendedBy" subfield
    func getEventsAttendedBy(userID: String) async -> [[String: Any]] {
        var userEvents: [[String: Any]] = []
        let collectionRef = db.collection("Event")

        do {
            let snapshot = try await collectionRef.getDocuments()
            for document in snapshot.documents {
                if let attendees = document.data()["AttendedBy"] as? [String], attendees.contains(userID) {
                    userEvents.append(document.data())
                }
            }
        } catch {
            print("Error getting user events: \(error)")
        }

        return userEvents
    }

    // Get all expense receipts for a specific user
    func getUserExpenseData(userID: String) async -> [[String: Any]] {
        var expenses: [[String: Any]] = []
        let receiptsRef = db.collection("Expenses").document(userID).collection("Bills")

        do {
            let snapshot = try await receiptsRef.getDocuments()
            for doc in snapshot.documents {
                expenses.append(doc.data())
            }
        } catch {
            print("Error getting user expenses: \(error)")
        }
        return expenses
    }

    // Calculate total cost of events attended by a user
    func calculateAccountBalance(userID: String) async -> Double {
        let expenses = await getUserExpenseData(userID: userID)
        let total = expenses.reduce(0.0) { partialResult, data in
            partialResult + (data["cost"] as? Double ?? 0.0)
        }
        return total
    }

    // Split event cost evenly and create receipt documents for each user
    func costSplit(eventID: String, cost: Double, attendees: [String], eventName: String) async {
        let perPerson = cost / Double(attendees.count)

        for userID in attendees {
            let receiptData: [String: Any] = [
                "eventID": eventID,
                "eventName": eventName,
                "cost": perPerson,
                "timestamp": Timestamp(date: Date())
            ]
            do {
                try await db.collection("Expenses")
                    .document(userID)
                    .collection("Receipts")
                    .addDocument(data: receiptData)
            } catch {
                print("Error writing receipt for \(userID): \(error)")
            }
        }
    }

    // Update existing event fields
    func updateEvent(eventID: String, updatedFields: [String: Any]) async -> Bool {
        let docRef = db.collection("Event").document(eventID)
        do {
            try await docRef.updateData(updatedFields)
            return true
        } catch {
            print("Error updating event: \(error)")
            return false
        }
    }

    // Update an existing user's receipt
    func updateBill(userID: String, receiptID: String, updatedFields: [String: Any]) async -> Bool {
        let docRef = db.collection("Expense").document(userID).collection("Bills").document(receiptID)
        do {
            try await docRef.updateData(updatedFields)
            return true
        } catch {
            print("Error updating bill: \(error)")
            return false
        }
    }
}
