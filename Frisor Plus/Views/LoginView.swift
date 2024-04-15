//
//  LoginView.swift
//  Frisor Plus
//
//  Created by Youssef Azroun on 2024-04-04.

import SwiftUI
import FirebaseMessaging

struct LoginView: View {
    @State private var navigateToAdminView = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var navigateToCreateAccount = false
    @State private var isPasswordVisible = false
    
    var body: some View {
        VStack {
         HStack {
                    Image(systemName: "envelope")
                        .foregroundColor(.gray)
                    TextField("Email", text: $email)
                        .foregroundColor(.black)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(20)
            

          HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.gray)
                    if isPasswordVisible {
                        TextField("Password", text: $password)
                            .foregroundColor(.black)
                    } else {
                        SecureField("Password", text: $password)
                            .foregroundColor(.black)
                    }
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 10)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(20)

            
            

            Button("Log in") {
                userViewModel.loginUser(email: email, password: password) { success, message in
                    if success {
                        // Check if the user is an admin
                        userViewModel.checkIfUserIsAdmin { isAdmin in
                            if isAdmin {
                                // Subscribe to admin topic
                                Messaging.messaging().subscribe(toTopic: "admin")
                                navigateToAdminView = true // Set to navigate to AdminView
                            } else {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    } else {
                        // Show error message
                    }
                }
            }
            .padding()
            .background(Color.brown.opacity(5))
            .cornerRadius(10.0)
            .foregroundColor(.white)
            .navigationDestination(isPresented: $navigateToAdminView) {
                AdminView()
            }

            Button("Create account") {
                navigateToCreateAccount = true
            }
            .padding()
            .background(Color.brown.opacity(5))
            .cornerRadius(10.0)
            .foregroundColor(.white)
            .navigationDestination(isPresented: $navigateToCreateAccount) {
                CreateAccountView()
            }
        }
        .padding()
}
}
    struct LoginView_Previews: PreviewProvider {
        static var previews: some View {
            LoginView()
        }
    }
