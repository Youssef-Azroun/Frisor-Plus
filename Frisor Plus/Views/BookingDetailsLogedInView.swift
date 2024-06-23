//
//  BookingDetailsLogedInView.swift
//  Frisor Plus
//
//  Created by Youssef Azroun on 2024-04-27.
//

import SwiftUI
import FirebaseAuth

struct BookingDetailsLogedInView: View {
    @ObservedObject var viewModel: BookingDetailsViewModel
    var selectedDate: Date
    var selectedTime: String
    var price: String
    var typeOfCut: String
    @State private var userDetails: User?
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    @State private var navigateToBookingConfirmationView = false
    private var isFormValid: Bool {
        !email.isEmpty && !firstName.isEmpty && !lastName.isEmpty && !phoneNumber.isEmpty && phoneNumber.count == 10 && phoneNumber.hasPrefix("0")
    }
    @State private var showAlert = false
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var phoneNumber = ""
    @State private var email = ""
    
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
                ScrollView {
                    VStack{
                        Image("Logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                        
                        Text("Här kommer din bokningsdetaljer \n📍Kolla att allt stämmer innan du boka din tid!")
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 5)
                        
                        
                        Text("Bokningsdetaljer:")
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 20)
                    }
                    
                    
                    VStack {
                        if Auth.auth().currentUser?.isAnonymous == true {
                            VStack {
                                HStack{
                                    Image(systemName: "person")
                                        .foregroundColor(.gray)
                                    TextField("Förnamn", text: $firstName)
                                        .foregroundColor(.black)
                                        .frame(height: 10)
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(20)
                                HStack{
                                    Image(systemName: "person")
                                        .foregroundColor(.gray)
                                    TextField("Efternamn", text: $lastName)
                                        .foregroundColor(.black)
                                        .frame(height: 10)
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(20)
                                HStack{
                                    Image(systemName: "phone")
                                        .foregroundColor(.gray)
                                    TextField("Telefonnummer", text: $phoneNumber)
                                        .foregroundColor(.black)
                                        .frame(height: 10)
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(20)
                                HStack{
                                    Image(systemName: "envelope")
                                        .foregroundColor(.gray)
                                    TextField("Email", text: $email)
                                        .foregroundColor(.black)
                                        .frame(height: 10)
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(20)
                            }
                        }
                    }
                    .padding()
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        if let userDetails = userDetails {
                            Text("Namn: \(userDetails.firstName) \(userDetails.lastName)")
                                .font(.headline)
                            HStack {
                                Image(systemName: "envelope")
                                    .foregroundColor(.secondary)
                                Text("Email: \(userDetails.email)")
                            }
                            HStack {
                                Image(systemName: "phone")
                                    .foregroundColor(.secondary)
                                Text("Mobil: 0\(String(userDetails.phoneNumber))")
                            }
                        }
                        HStack {
                            Image(systemName: "scissors")
                                .foregroundColor(.secondary)
                            Text("Typ av besök: \(typeOfCut)")
                        }
                        HStack {
                            Image(systemName: "creditcard")
                                .foregroundColor(.secondary)
                            Text("Pris: \(price)")
                        }
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.secondary)
                            Text("Datum: \(viewModel.formattedDate(selectedDate))")
                        }
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(.secondary)
                            Text("Tid: \(selectedTime)")
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    
                    Spacer()
                    
                    Button("Boka tiden") {
                        let formattedDate = viewModel.formattedDate(selectedDate)
                        viewModel.fetchBookingsForDate(date: formattedDate) { bookedTimes in
                            if bookedTimes.contains(selectedTime) {
                                showAlert = true
                            } else {
                                let booking = Bookings(
                                    email: Auth.auth().currentUser?.isAnonymous == true ? email : (userDetails?.email ?? ""),
                                    firstName: Auth.auth().currentUser?.isAnonymous == true ? firstName : (userDetails?.firstName ?? ""),
                                    lastName: Auth.auth().currentUser?.isAnonymous == true ? lastName : (userDetails?.lastName ?? ""),
                                    phoneNumber: Auth.auth().currentUser?.isAnonymous == true ? (Int(phoneNumber) ?? 0) : (userDetails?.phoneNumber ?? 0),
                                    price: price,
                                    selectedDate: formattedDate,
                                    selectedTime: selectedTime,
                                    typeOfCut: typeOfCut
                                )
                                if Auth.auth().currentUser?.isAnonymous == true {
                                    viewModel.saveBookingToAllBookingsOnly(booking: booking) {
                                        navigateToBookingConfirmationView = true
                                    }
                                } else {
                                    viewModel.saveBookingDetails(booking: booking) { success in
                                        if success {
                                            navigateToBookingConfirmationView = true
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .disabled(Auth.auth().currentUser?.isAnonymous == true && !isFormValid)
                    .padding(15) 
                    .frame(minWidth: 0, maxWidth: 200) 
                    .background(Auth.auth().currentUser?.isAnonymous == true && !isFormValid ? Color.gray : Color.brown)
                    .cornerRadius(10.0)
                    .foregroundColor(.white)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Tidsluckan otillgänglig"), message: Text("Denna tid är redan bokad av en annan person."), dismissButton: .default(Text("Okej")))
                    }
                    .padding(10)
                    .navigationDestination(isPresented: $navigateToBookingConfirmationView) {
                        if Auth.auth().currentUser?.isAnonymous == true {
                            BookingConfirmationView(selectedDate: viewModel.formattedDate(selectedDate), selectedTime: selectedTime, price: price, typeOfCut: typeOfCut, userDetails: User(email: email, firstName: firstName, lastName: lastName, phoneNumber: Int(phoneNumber) ?? 0))
                        } else {
                            BookingConfirmationView(selectedDate: viewModel.formattedDate(selectedDate), selectedTime: selectedTime, price: price, typeOfCut: typeOfCut, userDetails: userDetails)
                        }
                    }
                    .onAppear {
                        viewModel.fetchUserDetails { user in
                            self.userDetails = user
                        }
                    }
                }
            }
        }
          .onTapGesture {
        UIApplication.shared.endEditing()
    }
    }
    
    struct BookingDetailsLogedInView_Previews: PreviewProvider {
        static var previews: some View {
            BookingDetailsLogedInView(viewModel: BookingDetailsViewModel(), selectedDate: Date(), selectedTime: "12:00 PM", price: "50$", typeOfCut: "Regular Cut")
        }
    }
}

