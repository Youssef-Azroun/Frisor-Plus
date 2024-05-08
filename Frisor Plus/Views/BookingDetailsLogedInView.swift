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
                            email: userDetails?.email ?? "",
                            firstName: userDetails?.firstName ?? "",
                            lastName: userDetails?.lastName ?? "",
                            phoneNumber: userDetails?.phoneNumber ?? 0,
                            price: price,
                            selectedDate: formattedDate,
                            selectedTime: selectedTime,
                            typeOfCut: typeOfCut
                        )
                        viewModel.saveBookingDetails(booking: booking) { success in
                            if success {
                                navigateToBookingConfirmationView = true
                            }
                        }
                    }
                }
            }
            .disabled(Auth.auth().currentUser?.isAnonymous == true && !isFormValid)
            .padding(15)  // Increase padding for larger touch area
            .frame(minWidth: 0, maxWidth: 200)  // Make the button expand to the full available width
            .background(Auth.auth().currentUser?.isAnonymous == true && !isFormValid ? Color.gray : Color.brown)
            .cornerRadius(10.0)
            .foregroundColor(.white)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Tidsluckan otillgänglig"), message: Text("Denna tid är redan bokad av en annan person."), dismissButton: .default(Text("Okej")))
            }
            .padding(10)
            .navigationDestination(isPresented: $navigateToBookingConfirmationView) {
                BookingConfirmationView(selectedDate: viewModel.formattedDate(selectedDate), selectedTime: selectedTime, price: price, typeOfCut: typeOfCut, userDetails: userDetails)
            }
            .onAppear {
                viewModel.fetchUserDetails { user in
                    self.userDetails = user
                }
            }
        }
    }
    
    struct BookingDetailsLogedInView_Previews: PreviewProvider {
        static var previews: some View {
            BookingDetailsLogedInView(viewModel: BookingDetailsViewModel(), selectedDate: Date(), selectedTime: "12:00 PM", price: "50$", typeOfCut: "Regular Cut")
        }
    }
}
