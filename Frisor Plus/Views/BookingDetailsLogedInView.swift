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
    
    @State private var navigateToBookingConfirmationView = false

    var body: some View {
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
            navigateToBookingConfirmationView = true
        }
        .padding(10)
        .background(Color.brown)
        .cornerRadius(10.0)
        .foregroundColor(.white)
        .navigationDestination(isPresented: $navigateToBookingConfirmationView) {
                BookingConfirmationView()
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
