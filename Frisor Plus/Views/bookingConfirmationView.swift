//
//  BookingConfirmationView.swift
//  Frisor Plus
//
//  Created by Kanyaton Somjit on 2024-04-29.
//

import SwiftUI

struct BookingConfirmationView: View {
    var selectedDate: String
    var selectedTime: String
    var price: String
    var typeOfCut: String
    var userDetails: User?
    
    var body: some View {
        
        VStack {
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            
            Text("Bokning bekräftelse")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.bottom, 5)
            
            Text("Tack för din bokning hos oss Frisör plus.")
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
            
            Text("📍Viktigt info!")
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .font(.headline)
            
            HStack{
                Spacer()
                Text("Om du har konto hos oss kan du ser din boknings på mitt konto sida om du inte har konto ta gärna en skämdump för att har din bokning sparat i din telefon.")
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 5)
            
            Text("Bokningsdetaljer:")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
            
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
                Text("Datum: \(selectedDate)")
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
            Spacer()
            NavigationLink(destination: ContentView()) {
                Text("Tillbaka till Första sida")
                    .padding(10)
                    .background(Color.brown.opacity(5))
                    .cornerRadius(10.0)
                    .foregroundColor(.white)
            }
        }
        .navigationBarBackButtonHidden(true)
        Spacer()
    }
}


struct bookingConfirmation_Previews: PreviewProvider {
    static var previews: some View {
        BookingConfirmationView(selectedDate: "2024-05-01", selectedTime: "15:00", price: "300kr", typeOfCut: "Herrklippning", userDetails: User(email: "john.doe@example.com", firstName: "John", lastName: "Doe", phoneNumber: 123456789))
    }
}
