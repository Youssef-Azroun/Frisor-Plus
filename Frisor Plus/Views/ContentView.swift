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
    @State private var navigateToCalendar = false
    @State private var selectedService: Services?
    
    let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    Button(userViewModel.isLoggedIn ? "Mitt konto" : "Logga In") {
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
                    .padding(10)
                    .background(Color.brown.opacity(5))
                    .cornerRadius(10.0)
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
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
                .padding(8)
                
                VStack{
                    HStack{
                        Image("Logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 160, height: 160) // Justera storleken efter behov
                    VStack{
                        HStack{
                            Image(systemName: "mappin.and.ellipse")
                                .font(.system(size: 20))
                                .foregroundColor(.black)
                            Text("Carl Krooks Gata 6\n252 25 Helsingborg")
                                .foregroundColor(.black)
                        }
                        .padding(.bottom, 1)
                        HStack{
                            Image(systemName: "envelope")
                                .font(.system(size: 20))
                                .foregroundColor(.black)
                            Text("frisorplus@gmail.com")
                                .foregroundColor(.black)
                                .onTapGesture {
                                            if let url = URL(string: "mailto:frisorplus@gmail.com") {
                                                UIApplication.shared.open(url)
                                            }
                                        }
                        }
                        .padding(.bottom, 1)
                        HStack{
                            Image(systemName: "link")
                                .font(.system(size: 20))
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
                    ServicesView(servicItems: item, navigateToCalendar: $navigateToCalendar, selectedService: $selectedService) { // Update this line
                        print("Boka-knapp tryckt för \(item.servicedName)")
                    }
                }
                .navigationDestination(isPresented: $navigateToCalendar) {
                    CalendarAndTimeView(selectedService: selectedService)
                }
                .navigationBarBackButtonHidden(true)
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
