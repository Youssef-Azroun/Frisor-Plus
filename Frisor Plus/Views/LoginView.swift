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
    @State private var showToast = false
    @State private var toastMessage: String = ""
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250) // Justera storleken efter behov
                .padding(.bottom, 10)
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
                        TextField("Lösenord", text: $password)
                            .foregroundColor(.black)
                    } else {
                        SecureField("Lösenord", text: $password)
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
                .padding(.bottom, 20)
            
            Text("Logga in om du har ett konto om du inte har \nett konto klicka på registrera för att skapa \nett konto.")
                .foregroundColor(.black)
                .multilineTextAlignment(.center) 
                .padding(.bottom, 20)
            
            Button("Logga in") {
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
                        if message == "Please verify your email before logging in." {
                            toastMessage = "Vänligen verifiera din e-postadress innan du loggar in."
                        } else {
                            toastMessage = "Något har gått fel. Antingen är din e-postadress eller lösenord felaktigt."
                        }
                        showToast = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            showToast = false
                        }
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

            Button("Registrera") {
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
        Spacer()
        
        if showToast {
            toastView
                .animation(.easeInOut, value: showToast)
                .transition(.move(edge: .bottom))
        }
}
    private var toastView: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle")
                .foregroundColor(.white)
                .font(.system(size: 25))
            Text(toastMessage)
        }
        .padding()
        .background(Color.red)
        .foregroundColor(Color.white)
        .cornerRadius(25)
    }
}
    struct LoginView_Previews: PreviewProvider {
        static var previews: some View {
            LoginView()
        }
    }
