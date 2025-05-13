//
//  HomeView.swift
//  680FinalProject
//
//  Created by Michelle Nguyen on 5/9/25.
//


import SwiftUI

struct DashboardView: View {
    @Binding var dashAuth: testAuth
    
    @State private var returnToLogin: Bool = false
    
    @State var tripService: TripManager // will be used as a binding variable in other subviews
    
    init (authentification: Binding<testAuth>){
        self.tripService = TripManager()
        self._dashAuth = authentification
    }
    
    var body: some View {
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
                            destination: ExpensesView(authentication: $dashAuth) // Navigate to ExpensesView
                        )

                        NavigationCardView(
                            icon: "map",
                            title: "Map & Locations",
                            description: "See your trip spots on a map.",
                            destination: LocationView() // Navigate to LocationView
                        )
                        Spacer()
                        Button(action: {
                            //after logging in this should then move to the next page and make user ID
                            returnToLogin = dashAuth.signOutCurrentUser()
                        }) {
                            Text("Sign Out")
                        }
                    }
                    .navigationDestination(isPresented: $returnToLogin){
                        LoginPage()
                    }
                    Spacer()
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
    func populateDatabaseWithExpenses() {
        let currentUserID = dashAuth.getCurrentUserData()?.user.uid
        let dbAccess = testBackend()
        print(currentUserID)
        Task{
            let _ = await dbAccess.writeExpenseData(UserID: currentUserID!)
        }
    }
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
