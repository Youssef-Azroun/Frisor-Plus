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
                ForEach(infoBookingsViewModel.bookings) { booking in
                    BookingCardView(booking: booking)
                }
            }
            .padding()
        }
        .background(Color.gray.opacity(0.2))
        .ignoresSafeArea() 
        .onAppear {
            infoBookingsViewModel.fetchBookings()
        }
    }
}

struct BookingCardView: View {
    var booking: Bookings

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Namn: \(booking.firstName) \(booking.lastName)")
                .font(.headline)
            HStack {
                Image(systemName: "scissors")
                    .foregroundColor(.secondary)
                Text("Typ Av besök: \(booking.typeOfCut)")
            }
            HStack {
                Image(systemName: "creditcard")
                    .foregroundColor(.secondary)
                Text("Pris: \(booking.price)")
            }
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
                Image(systemName: "clock")
                    .foregroundColor(.secondary)
                Text("Tid: \(booking.selectedTime)")
            }
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.secondary)
                Text("Datum: \(booking.selectedDate)")
            }
            Spacer()

            HStack {
                Spacer()
                Button("Avboka") {
                    
                }
                .padding()
                .background(Color.brown)
                .foregroundColor(.white)
                .cornerRadius(10)
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