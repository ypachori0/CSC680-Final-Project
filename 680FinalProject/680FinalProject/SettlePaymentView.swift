//
//  SettlePaymentView.swift
//  680FinalProject
//
//  Created by Michelle Nguyen on 5/12/25.
//

import SwiftUI

struct SettlePaymentView: View {
    var expenseID: UUID
    @State private var paymentStatus: String = "Unpaid"
    
    var body: some View {
        VStack {
            Text("Settle Payment for Expense")
                .font(.title)
            
            Text("Expense ID: \(expenseID)")
                .padding()

            Text("Payment Status: \(paymentStatus)")
                .padding()

            Button("Mark as Paid") {
                // Mark the expense as paid
                paymentStatus = "Paid"
                // Here, you would update the payment status in the database
                print("Expense \(expenseID) marked as paid")
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            Spacer()
        }
        .padding()
        .navigationBarTitle("Settle Payment", displayMode: .inline)
    }
}

#Preview {
    SettlePaymentView(expenseID: UUID())  // Provide a mock UUID for preview
}
