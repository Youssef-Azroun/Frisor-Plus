//
//  BookingConfirmationView.swift
//  Frisor Plus
//
//  Created by Kanyaton Somjit on 2024-04-29.
//

import SwiftUI

struct BookingConfirmationView: View {
    
   
    var body: some View {
        
        VStack {
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150) 
            
            Text("Bokning bekräftelse")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.bottom, 5)
            
            Text("Tack för din bokning hos oss Frisör plus.")
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.bottom, 5)
            
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
            
            
            
            Spacer()
            Spacer()
            
            Button("Tillbaka till Första sida") {
                
            }
            .padding(10)
            .background(Color.brown.opacity(5))
            .cornerRadius(10.0)
            .foregroundColor(.white)
        }
        Spacer()
    }
}


struct bookingConfirmation_Previews: PreviewProvider {
    static var previews: some View {
        BookingConfirmationView()
    }
}
