//
//  EditUserDetailsView.swift
//  Frisor Plus
//
//  Created by Youssef Azroun on 2024-04-21.
//

import Foundation
import SwiftUI

struct EditUserDetailsView: View {
    @EnvironmentObject var infoBookingsViewModel: InfoBookingsViewModel
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @Environment(\.presentationMode) var presentationMode
    @State private var firstName: String
    @State private var lastName: String
    @State private var phoneNumber: String
    @State private var showAlert = false
    @State private var alertMessage = ""

    private var isFormValid: Bool {
        !firstName.isEmpty && !lastName.isEmpty && !phoneNumber.isEmpty && phoneNumber.count == 10 && phoneNumber.hasPrefix("0")
    }

    init(user: User) {
        _firstName = State(initialValue: user.firstName)
        _lastName = State(initialValue: user.lastName)
        _phoneNumber = State(initialValue: String(user.phoneNumber))
    }

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
                VStack(spacing: 20) {
                    Text("Redigera dina info")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    TextField("Första namn", text: $firstName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    TextField("Efter namn", text: $lastName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    TextField("mobil Nummer", text: $phoneNumber)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button(action: {
                        let phoneInt = Int(phoneNumber) ?? 0
                        infoBookingsViewModel.updateUserDetails(firstName: firstName, lastName: lastName, phoneNumber: phoneInt) { success, message in
                            alertMessage = message
                            showAlert = true
                            if success {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }) {
                        Text("Spara ändringar")
                            .fontWeight(.semibold)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .background(isFormValid ? Color.brown : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(40)
                    }
                    .padding()
                    .disabled(!isFormValid)
                }
                .padding()
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Status Updatering"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
        }
          .onTapGesture {
        UIApplication.shared.endEditing()
    }
    }
}

