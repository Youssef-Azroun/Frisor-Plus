//
//  ServicesView.swift
//  Frisor Plus
//
//  Created by Kanyaton Somjit on 2024-04-17.
//

import SwiftUI

struct ServicesView: View {
    var servicItems: Services
    @Binding var navigateToCalendar: Bool
    @Binding var selectedService: Services?
    var buttonAction: () -> Void // Closure för att hantera knapptryckningen

    var body: some View {
        HStack{
            VStack(alignment: .leading) {
                Text(servicItems.servicedName)
                    .font(.headline)
                Text(servicItems.price)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            
            Button("Boka") {
                selectedService = servicItems
                navigateToCalendar = true
                self.buttonAction()
            }
            .foregroundColor(.white)
            .padding(9)
            .background(Color.brown.opacity(5))
            .cornerRadius(10.0)
            }
        .padding()
    }
}

