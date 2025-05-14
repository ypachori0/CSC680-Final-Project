//
//  RegisterView.swift
//  680FinalProject
//
//  Created by Michelle Nguyen on 5/9/25.
//

import SwiftUI

struct RegisterView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var registrationSuccess: Bool = false
    
    // Navigation destination
    @State private var navigateToHomeView = false
    
    let userAccountCreation = testAuth()

    var body: some View {
            VStack(spacing: 20) {
                // Title
                Text("Create an Account")
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

                // Confirm Password input
                SecureField("Confirm Password", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                // Register Button
                Button(action: {
                    handleRegistration()
                }) {
                    Text("Register")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(.title2)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .alert(isPresented: $registrationSuccess) {
                Alert(title: Text("Success"), message: Text("Account successfully registered!"), dismissButton: .default(Text("OK")))
            }
    }

    // Handle registration logic
    private func handleRegistration() {
        if password == confirmPassword {
            // Registration logic (Placeholder)
            print("Registering account for \(email)")
            userAccountCreation.addUser(email: email, password: password)
            registrationSuccess = true
            navigateToHomeView = true // Trigger navigation to HomeView
        } else {
            // Show error if passwords don't match
            print("Passwords do not match!")
        }
    }
}

#Preview {
    RegisterView()
}
