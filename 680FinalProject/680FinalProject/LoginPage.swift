//
//  Loginpage.swift
//  680FinalProject
//
//  Created by Michelle Nguyen on 5/9/25.
//

import SwiftUI
import Combine

final class KeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0
    private var cancellable: AnyCancellable?

    init() {
        cancellable = Publishers.Merge(
            NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
                .compactMap { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height },
            NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in CGFloat(0) }
        )
        .subscribe(on: RunLoop.main)
        .assign(to: \.currentHeight, on: self)
    }
}

struct LoginPage: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isRegistering: Bool = false
    @StateObject private var keyboard = KeyboardResponder()
    
    let authentification = testAuth()
    
    var body: some View {
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
                    //after logging in this should then move to the next page and make user ID 
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
            .padding(.bottom, keyboard.currentHeight)
            .animation(.easeOut(duration: 0.25), value: keyboard.currentHeight)
    }

    // Handle submit action for both login and registration
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
