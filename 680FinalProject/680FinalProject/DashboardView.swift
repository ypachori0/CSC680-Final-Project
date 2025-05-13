//
//  DashboardView.swift
//  680FinalProject
//
//  Created by Michelle Nguyen on 5/9/25.
//

import SwiftUI
import FirebaseAuth

struct DashboardView: View {
    // 🔒 Optional auth binding — not currently used
    // @Binding var dashAuth: testAuth
    
    @State var tripService = TripManager()
    @Environment(\.presentationMode) var presentationMode // Used to go back to MainView

    // Init method preserved if you want to pass auth later
    /*
    init(authentification: Binding<testAuth>) {
        self.tripService = TripManager()
        self._dashAuth = authentification
    }
    */

    var body: some View {
        VStack {
            // Scrollable content area
            ScrollView {
                VStack(spacing: 30) {

                    // Welcome / header
                    VStack(spacing: 4) {
                        Text("Welcome Back!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)

                        Text("Trip Dashboard")
                            .font(.title3)
                            .foregroundColor(.gray)
                    }

                    // Navigation cards
                    VStack(spacing: 20) {

                        NavigationCardView(
                            icon: "calendar",
                            title: "Itinerary",
                            description: "View and edit your trip's day-by-day plan.",
                            destination: ItineraryView() // Navigate to ItineraryView
                        )

                        NavigationCardView(
                            icon: "dollarsign.circle",
                            title: "Expenses",
                            description: "Track and split group expenses.",
                            destination: ExpensesView() // Removed auth binding
                        )

                        NavigationCardView(
                            icon: "map",
                            title: "Map & Locations",
                            description: "See your trip spots on a map.",
                            destination: LocationView()
                        )

                        /*
                        Button(action: {
                            populateDatabaseWithExpenses()
                        }) {
                            Text("It is 3am and I need this to work")
                        }
                        */
                    }

                    Spacer()
                }
                .padding()
            }

            // Sign Out button
            Button(action: {
                handleSignOut()
            }) {
                Text("Sign Out")
                    .foregroundColor(.red)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(10)
            }
            .padding()
        }
        .navigationBarHidden(true)
        .background(
            LinearGradient(gradient: Gradient(colors: [.white, .blue.opacity(0.1)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
        )
    }

    // MARK: - Sign Out Logic (Firebase)
    func handleSignOut() {
        do {
            try Auth.auth().signOut()
            print("User signed out")
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }

    // Optional helper for test backend interaction
    /*
    func populateDatabaseWithExpenses() {
        let currentUserID = dashAuth.getCurrentUserData()?.user.uid
        let dbAccess = testBackend()
        print(currentUserID)
        Task {
            let success = await dbAccess.writeExpenseData(UserID: currentUserID!)
        }
    }
    */
}

struct NavigationCardView<Destination: View>: View {
    var icon: String
    var title: String
    var description: String
    var destination: Destination

    var body: some View {
        NavigationLink(destination: destination) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .frame(width: 44, height: 44)
                    .background(Color.blue.opacity(0.2))
                    .foregroundColor(.blue)
                    .clipShape(Circle())

                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
}
