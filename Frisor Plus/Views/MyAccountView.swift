//
//  MyAccountView.swift
//  Frisor Plus
//
//  Created by Youssef Azroun on 2024-04-11.
//

import SwiftUI

struct MyAccountView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var infoBookingsViewModel: InfoBookingsViewModel
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @Environment(\.presentationMode) var presentationMode
    @State private var userDetails: User?

    var body: some View {
        VStack {
            if !networkMonitor.isConnected {
                HStack {
    Image(systemName: "wifi.slash")
        .foregroundColor(.red)
    Text("Ingen internetanslutning")
        .foregroundColor(.red)
}
.padding()
            } else {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding(.bottom, 10)

                Text("Mina Info:")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                
                if let userDetails = userDetails {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Namn: \(userDetails.firstName) \(userDetails.lastName)")
                                .font(.headline)
                                .fontWeight(.bold)
                            Spacer()
                            NavigationLink(destination: EditUserDetailsView(user: userDetails).environmentObject(infoBookingsViewModel)) {
                                Image(systemName: "pencil")
                                    .padding(8)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .shadow(radius: 3)
                            }
                        }

                        Text("Email: \(userDetails.email)")
                            .font(.headline)
                        Text("Mobil: 0\(String(userDetails.phoneNumber))")
                            .font(.headline)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                }
                
                Text("Mina bookningar:")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                MyAccountBookingsView() 
            }
        }
        .onAppear {
            infoBookingsViewModel.fetchUserDetails { user in
                self.userDetails = user
            }
        }
        Spacer()
        .navigationBarItems(trailing: Button("Log Out") {
            userViewModel.logoutUser()
            presentationMode.wrappedValue.dismiss()
        })
    }
}

struct MyAccountView_Previews: PreviewProvider {
    static var previews: some View {
        MyAccountView().environmentObject(InfoBookingsViewModel())
    }
}

