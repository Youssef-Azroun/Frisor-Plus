//
//  BookingDetailsLogedInView.swift
//  Frisor Plus
//
//  Created by Youssef Azroun on 2024-04-27.
//

import SwiftUI

struct BookingDetailsLogedInView: View {
    @ObservedObject var viewModel: BookingDetailsViewModel
    var selectedDate: Date
    var selectedTime: String
    var price: String
    var typeOfCut: String
    @State private var userDetails: User?

    var body: some View {
        Text("Booking Details:")
        .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
        VStack(alignment: .leading, spacing: 10) {
            if let userDetails = userDetails {
                Text("Name: \(userDetails.firstName) \(userDetails.lastName)")
                .font(.headline)
                HStack {
                    Image(systemName: "envelope")
                    .foregroundColor(.secondary)
                Text("Email: \(userDetails.email)")
                }
                  HStack {
                    Image(systemName: "phone")
                    .foregroundColor(.secondary)
                Text("Phone: 0\(String(userDetails.phoneNumber))")
                  }
            }
            HStack {
                Image(systemName: "calendar")
                .foregroundColor(.secondary)
            Text("Date: \(viewModel.formattedDate(selectedDate))")
            }
            HStack {
                Image(systemName: "clock")
                .foregroundColor(.secondary)
            Text("Time: \(selectedTime)")
            }
            HStack {
                Image(systemName: "creditcard")
                .foregroundColor(.secondary)
            Text("Price: \(price)")
            }
            HStack {
                Image(systemName: "scissors")
                .foregroundColor(.secondary)
            Text("Type of Cut: \(typeOfCut)")
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)

        Button("Boka tiden") {

        }
        .padding()
            .background(Color.brown)
            .cornerRadius(10.0)
            .foregroundColor(.white)
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
