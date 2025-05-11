//
//  EventService.swift
//  680FinalProject
//
//  Created by Yash Pachori on 5/11/25.
//

import Foundation
import FirebaseFirestore

struct Event: Codable, Identifiable {
    @DocumentID var id: String? = UUID().uuidString
    var name: String
    var date: Date
    var totalCost: Double
    var attendees: [String] // userIds or emails
}

class EventService {
    private let db = Firestore.firestore()
    private let collection = "Events"
    
    // MARK: - Create Event
    func createEvent(event: Event, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            _ = try db.collection(collection).addDocument(from: event) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }

    // MARK: - Read/Get All Events
    func getAllEvents(completion: @escaping (Result<[Event], Error>) -> Void) {
        db.collection(collection).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let documents = snapshot?.documents else {
                completion(.success([]))
                return
            }
            let events = documents.compactMap { doc -> Event? in
                try? doc.data(as: Event.self)
            }
            completion(.success(events))
        }
    }

    // MARK: - Update Event
    func updateEvent(eventId: String, data: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection(collection).document(eventId).updateData(data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // MARK: - Get Single Event by ID
    func getEventById(eventId: String, completion: @escaping (Result<Event, Error>) -> Void) {
        db.collection(collection).document(eventId).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let event = try? snapshot?.data(as: Event.self) {
                completion(.success(event))
            } else {
                completion(.failure(NSError(domain: "EventService", code: 404, userInfo: [NSLocalizedDescriptionKey: "Event not found"])))
            }
        }
    }
}
