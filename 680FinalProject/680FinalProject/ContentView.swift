//
//  ContentView.swift
//  680FinalProject
//
//  Created by Thomas Bercasio on 4/21/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                
                Spacer()

                // App icon placeholder
                Image(systemName: "map.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.blue)
                
                Text("Group Trip Planner")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)

                VStack(spacing: 16) {
                    NavigationLink(destination: JoinTripView()) {
                        Text("Join with Code")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(colors: [.blue.opacity(0.6), .cyan], startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)

                Spacer()

                // Correct NavigationLink to LoginPage
                NavigationLink(destination: LoginPage()) { // Should be LoginPage(), not LoginView()
                    Text("Sign in with email")
                        .font(.subheadline)
                        .foregroundColor(.cyan)
                        .underline()
                }

                Spacer().frame(height: 20)
            }
            .padding()
            .background(
                LinearGradient(gradient: Gradient(colors: [.white, .blue.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
            )
            .ignoresSafeArea()
        }
    }
}

#Preview {
    ContentView()
}

// Placeholder view for joining a trip with a code
struct JoinTripView: View {
    var body: some View {
        Text("Join Trip With Code Page")
            .font(.title)
            .foregroundColor(.gray)
    }
}

// Placeholder view for email sign-in
struct EmailLoginView: View {
    @State
    var email: String = ""
    
    @State
    var password: String = ""
    
    let authentification = testAuth()
    
    var body: some View {
        Text("Sign in with Email Page")
            .font(.title)
            .foregroundColor(.gray)
        TextField("Email: ", text: $email).textFieldStyle(.roundedBorder).padding().keyboardType(.emailAddress).textContentType(.emailAddress)
        TextField("Password: ", text: $password).textFieldStyle(.roundedBorder).padding().textContentType(.password)
        Button(action: {
            authentification.setEmail(email: email)
            authentification.setPassword(password: password)
            
            
        }) {
            Text("Submit")
        }
    }
}


