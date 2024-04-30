//
//  MyAccountBookingsView.swift
//  Frisor Plus
//
//  Created by Youssef Azroun on 2024-04-21.
//

import SwiftUI

struct MyAccountBookingsView: View {
    @EnvironmentObject var infoBookingsViewModel: InfoBookingsViewModel
   

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if infoBookingsViewModel.bookings.isEmpty {
                    Image("Scissors")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 125, height: 125)
                    Text("Hopp...")
                        .font(.largeTitle)
                    Text("För närvarande finns inga bokningar.")
                        .padding()
                } else {
                    ForEach(infoBookingsViewModel.bookings) { booking in
                        BookingCardView(booking: booking)
                    }
                }
            }
            .padding()
        }
        .background(infoBookingsViewModel.bookings.isEmpty ? Color.white : Color.gray.opacity(0.2))
        .ignoresSafeArea() 
        .onAppear {
            infoBookingsViewModel.fetchBookings()
        }
    }
}

struct BookingCardView: View {
    var booking: Bookings
    @EnvironmentObject var infoBookingsViewModel: InfoBookingsViewModel
    @State private var showAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Namn: \(booking.firstName) \(booking.lastName)")
                .font(.headline)
            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(.secondary)
                Text("Email: \(booking.email)")
            }
            HStack {
                Image(systemName: "phone")
                    .foregroundColor(.secondary)
                Text("Mobil: 0\(String(booking.phoneNumber))")
            }
            HStack {
                Image(systemName: "scissors")
                    .foregroundColor(.secondary)
                Text("Typ av besök: \(booking.typeOfCut)")
            }
            HStack {
                Image(systemName: "creditcard")
                    .foregroundColor(.secondary)
                Text("Pris: \(booking.price)")
            }
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.secondary)
                Text("Datum: \(booking.selectedDate)")
            }
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(.secondary)
                Text("Tid: \(booking.selectedTime)")
            }
            Spacer()

            HStack {
                Spacer()
                
                Button(action: {
                    showAlert = true
                }) {
                    Text("Avboka")
                        .padding(8)
                        .background(Color.brown)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Avboka tid"),
                          message: Text("Är du säker på att du vill \navboka denna tid? \nDatum: \(booking.selectedDate) \nTid: \(booking.selectedTime)"),
                          primaryButton: .destructive(Text("Ja")) {
                        infoBookingsViewModel.cancelBooking(bookingId: booking.id!)
                        }, secondaryButton: .cancel(Text("Avbryt")))
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct MyAccountBookingsView_Previews: PreviewProvider {
    static var previews: some View {
        MyAccountBookingsView().environmentObject(InfoBookingsViewModel())
    }
}
