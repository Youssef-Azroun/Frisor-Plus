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
    @ObservedObject var servicesItem = ServicesItem()
    
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
                    .padding(5)
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
                .padding(5)
                
                VStack{
                    HStack{
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150) // Justera storleken efter behov
                    VStack{
                        HStack{
                            Image(systemName: "mappin.and.ellipse.circle")
                                .font(.system(size: 25))
                                .foregroundColor(.black)
                            Text("Carl Krooks Gata 6\n252 25 Helsingborg")
                                .foregroundColor(.black)
                        }
                        HStack{
                            Image(systemName: "envelope.circle")
                                .font(.system(size: 25))
                                .foregroundColor(.black)
                            Text("frisorplus@gmail.com")
                                .foregroundColor(.black)
                                .onTapGesture {
                                            if let url = URL(string: "mailto:frisorplus@gmail.com") {
                                                UIApplication.shared.open(url)
                                            }
                                        }
                        }
                        HStack{
                            Image(systemName: "link.circle")
                                .font(.system(size: 25))
                                .foregroundColor(.black)
                            Text("www.facebook.com/frisorplus.se")
                                .foregroundColor(.black)
                        }
                        }
                    }
                    Text("Boka tjänster:")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
               
                List(servicesItem.serviceItems) { item in
                    ServicesView(servicItems: item) {
                        print("Boka-knapp tryckt för \(item.servicedName)")
                    }
                }
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
