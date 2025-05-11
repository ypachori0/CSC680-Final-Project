//
//  Loginpage.swift
//  680FinalProject
//
//  Created by Michelle Nguyen on 5/9/25.
//

import SwiftUI

struct LoginPage: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isRegistering: Bool = false
    
    let authentification = testAuth()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Title
                Text(isRegistering ? "Create an Account" : "Sign In")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)

                // Email input
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                // Password input
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                // Submit Button
                Button(action: {
                    handleSubmit()
                }) {
                    Text(isRegistering ? "Register" : "Sign In")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(.title2)
                }
                .padding(.horizontal)

                // Toggle between Login and Register
                NavigationLink(
                    destination: RegisterView(),
                    label: {
                        Text(isRegistering ? "Already have an account? Sign In" : "Don't have an account? Register")
                            .foregroundColor(.blue)
                            .font(.subheadline)
                    }
                )

                Spacer()
            }
            .padding()
        }
    }

    // Handle submit action for both login and registration
    // call auth function here to determine whether person is signing in or not
    private func handleSubmit() {
        if isRegistering {
            // Register user logic (Placeholder)
            print("Registering account for \(email)")
        } else {
            // Sign In logic (Placeholder)
            print("Signing in with \(email)")
            authentification.setEmail(email: email)
            authentification.setPassword(password: password)
            if(authentification.checkAuth()){
                print("Succesful login")
            }
            
            
        }
    }
}

#Preview {
    LoginPage()
}
