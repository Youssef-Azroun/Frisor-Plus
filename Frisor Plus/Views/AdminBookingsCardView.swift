//
//  AdminBookingsCardView.swift
//  Frisor Plus
//
//  Created by Kanyaton Somjit on 2024-04-23.
//


import SwiftUI

struct AdminBookingsCardView: View {
    @EnvironmentObject var infoBookingsViewModel: InfoBookingsViewModel
    @State private var showAlert = false
    @State private var deleteIndex: Int?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(infoBookingsViewModel.bookings.indices, id: \.self) { index in
                    AllBookingsCardView(booking: infoBookingsViewModel.bookings[index], index: index)
                }
            }
            .padding()
            .padding(.top, 15)
        }
        .background(Color.gray.opacity(0.2))
        .ignoresSafeArea()
        .onAppear {
            infoBookingsViewModel.showAllBookings()
        }
    }
}


struct AllBookingsCardView: View {
    @EnvironmentObject var infoBookingsViewModel: InfoBookingsViewModel
    var booking: Bookings
    var index: Int
    
    @State private var showAlert = false
    
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
            
            HStack {
                Spacer()
                Button(action: {
                    showAlert = true
                }) {
                    Text("Ta bort")
                        .padding(8)
                        .background(Color.brown)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .alert(isPresented: $showAlert) {
                    // Visa en bekräftelsealert
                    Alert(title: Text("Bekräfta borttagning"), 
                          message: Text("Är du säker på att du vill ta bort \nden här bokningen? \nNamn: \(booking.firstName) \(booking.lastName) \nDatum: \(booking.selectedDate) \nTid: \(booking.selectedTime)"),
                          primaryButton: .destructive(Text("Ja")) {
                        // Ta bort bokningen om användaren väljer Ja
                        infoBookingsViewModel.deleteBooking(index: index)
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


struct AdminBookingsCardView_Previews: PreviewProvider {
    static var previews: some View {
        AdminBookingsCardView().environmentObject(InfoBookingsViewModel())
    }
}
