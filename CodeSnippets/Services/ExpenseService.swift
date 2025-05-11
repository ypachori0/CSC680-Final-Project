//
//  ExpenseService.swift
//  680FinalProject
//
//  Created by Yash Pachori on 5/11/25.
//

import Foundation
import FirebaseFirestore

struct Expense: Codable, Identifiable {
    @DocumentID var id: String? = UUID().uuidString
    var userId: String
    var eventId: String
    var amount: Double
    var description: String
    var timestamp: Date
}

class ExpenseService {
    private let db = Firestore.firestore()
    private let collection = "Expenses"

    // MARK: - Get All Expenses for a User
    func getUserExpenses(userId: String, completion: @escaping (Result<[Expense], Error>) -> Void) {
        db.collection(collection)
            .whereField("userId", isEqualTo: userId)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                let expenses = snapshot?.documents.compactMap {
                    try? $0.data(as: Expense.self)
                } ?? []
                completion(.success(expenses))
            }
    }

    // MARK: - Split Cost Across Users
    func splitCostEvenly(eventId: String, totalCost: Double, attendees: [String], description: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let individualCost = totalCost / Double(attendees.count)
        let timestamp = Date()

        let batch = db.batch()
        for userId in attendees {
            let docRef = db.collection(collection).document()
            let expense = Expense(
                id: docRef.documentID,
                userId: userId,
                eventId: eventId,
                amount: individualCost,
                description: description,
                timestamp: timestamp
            )
            do {
                try batch.setData(from: expense, forDocument: docRef)
            } catch {
                completion(.failure(error))
                return
            }
        }

        batch.commit { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // MARK: - Update a Bill
    func updateExpense(expenseId: String, data: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection(collection).document(expenseId).updateData(data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
