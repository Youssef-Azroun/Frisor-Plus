//
//  ContentView.swift
//  Frisor Plus
//
//  Created by Youssef Azroun on 2024-04-04.
//
//Testing a new branch

import SwiftUI

struct ContentView: View {
    @State private var navigateToLogin = false
    @State private var navigateToMyAccount = false
    @State private var navigateToAdminView = false
    @EnvironmentObject var userViewModel: UserViewModel
    let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    Button(userViewModel.isLoggedIn ? "My Account" : "Log In") {
                        if userViewModel.isLoggedIn {
                            userViewModel.checkIfUserIsAdmin { isAdmin in
                                if isAdmin {
                                    navigateToAdminView = true
                                } else {
                                    navigateToMyAccount = true
                                }
                            }
                        } else {
                            navigateToLogin = true
                        }
                    }
                    .padding()
                    .background(Color.brown.opacity(5))
                    .cornerRadius(10.0)
                    .foregroundColor(.white)
                    .navigationDestination(isPresented: $navigateToLogin) {
                        LoginView()
                    }
                    .navigationDestination(isPresented: $navigateToMyAccount) {
                        MyAccountView()
                    }
                    .navigationDestination(isPresented: $navigateToAdminView) {
                        AdminView()
                    }
                }
                .padding()
                Spacer()
            }
        }
        .onAppear {
            if isLoggedIn {
                userViewModel.checkIfUserIsAdmin { isAdmin in
                    if isAdmin {
                        navigateToAdminView = true
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(UserViewModel())
    }
}
