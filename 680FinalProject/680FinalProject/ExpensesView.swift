//
//  expensesView.swift
//  680FinalProject
//
//  Created by Michelle Nguyen on 5/9/25.
//

import SwiftUI

struct ExpensesView: View {
    
    //populate this array with objects from the database
    @State private var expenses: [Expense] = [
        Expense(name: "Breakfast", amount: 45.00, people: ["Payd", "Yash", "Michelle", "Thomas"]),
        Expense(name: "Shared Ride", amount: 60.75, people: ["Majd", "Michelle", "Thomas", "You"]),
        Expense(name: "Dinner", amount: 135.00, people: ["Thomas", "Yash", "Majd", "Michelle"]),
    ]
    
    // Total expenses and amount owed as @State so they update dynamically
    @State private var totalExpenses: Double = 240.75
    @State private var amountOwed: Double = 85.25
    
    @Binding private var expenseAuth: testAuth
    
    let tripService = TripManager()
    
    @State private var currentUID: String = ""
    
    init (authentication: Binding<testAuth>){
        self._expenseAuth = authentication //passed auth data from dash
        expenses = []
        
    }

    var body: some View {
        ScrollView {  // Wrap the entire content in ScrollView
            VStack(spacing: 20) {
                // Header with total and owed amount
                VStack(alignment: .leading, spacing: 5) {
                    Text("Total Expenses \(expenseAuth.getCurrentUserData()?.user.uid)")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("$\(totalExpenses, specifier: "%.2f")")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                    
                    Text("You Owe")
                        .font(.headline)
                    
                    Text("$\(amountOwed, specifier: "%.2f")")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
                .padding(.top)

                // List of expenses
                ForEach(expenses, id: \.id) { expense in
                    NavigationLink(destination: SettlePaymentView(expenseID: expense.id)) {
                        ExpenseRow(expense: expense)
                            .padding(.bottom, 10)
                    }
                }

                // Add expense button
                Button(action: {
                    addNewExpense()
                }) {
                    Text("+ Add Expense")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
                .padding(.bottom)
            }
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]), startPoint: .top, endPoint: .bottom))
            .cornerRadius(20)
            .shadow(radius: 10)
            .frame(maxWidth: .infinity)
        }
        .frame(maxHeight: .infinity) // Ensure the scroll view takes up the whole screen
    }

    // Function to simulate adding a new expense
    private func addNewExpense() {
        let newExpense = Expense(name: "New Item", amount: Double.random(in: 0...300), people: ["New Member", "You"])
        expenses.append(newExpense)
        
        // Recalculate total expenses and amount owed
        totalExpenses = expenses.reduce(0) { $0 + $1.amount }
        let totalPeople = expenses.flatMap { $0.people }.count
        amountOwed = totalPeople > 0 ? totalExpenses / Double(totalPeople) : 0.0
    }
}

struct ExpenseRow: View {
    var expense: Expense
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(expense.name)
                .font(.headline)
                .fontWeight(.semibold)
            
            Text("$\(expense.amount, specifier: "%.2f")")
                .font(.subheadline)
                .foregroundColor(.green)
            
            HStack {
                Text("Payee(s):")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                ForEach(expense.people, id: \.self) { person in
                    Text(person)
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct Expense: Identifiable {
    var id = UUID()
    var name: String
    var amount: Double
    var people: [String]
}
