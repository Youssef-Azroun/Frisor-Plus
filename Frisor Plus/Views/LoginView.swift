//
//  LoginView.swift
//  Frisor Plus
//
//  Created by Youssef Azroun on 2024-04-04.

import SwiftUI
import FirebaseMessaging

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct LoginView: View {
    @State private var navigateToAdminView = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var infoBookingsViewModel: InfoBookingsViewModel
    @EnvironmentObject var bookingDetailsViewModel: BookingDetailsViewModel
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var navigateToCreateAccount = false
    @State private var isPasswordVisible = false
    @State private var showToast = false
    @State private var toastMessage: String = ""
    
    var body: some View {
        ScrollView {
        VStack {
            if !networkMonitor.isConnected {
                Text("Ingen internetanslutning")
                    .foregroundColor(.red)
                    .padding()
            } else {
                Image("Logo")
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
                            userViewModel.checkIfUserIsAdmin { isAdmin in
                                if isAdmin {
                                    Messaging.messaging().subscribe(toTopic: "admin")
                                    // Explicitly navigate to AdminStartPage
                                    if let window = UIApplication.shared.windows.first {
                                        let newInfoBookingsViewModel = InfoBookingsViewModel()
                                        let newBookingDetailsViewModel = BookingDetailsViewModel()
                                        let adminView = AdminView()
                                            .environmentObject(newInfoBookingsViewModel)
                                            .environmentObject(userViewModel)
                                            .environmentObject(newBookingDetailsViewModel)
                                        window.rootViewController = UIHostingController(rootView: adminView)
                                        window.makeKeyAndVisible()
                                    }
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
                           // toastMessage = message
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
        }
    }
        .onTapGesture {
            UIApplication.shared.endEditing()
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
