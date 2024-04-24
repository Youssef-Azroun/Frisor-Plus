//
//  AdminView.swift
//  Frisor Plus
//
//  Created by Youssef Azroun on 2024-04-13.
//

import SwiftUI

struct AdminView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var infoBookingsViewModel: InfoBookingsViewModel
    
    var body: some View {
        VStack{
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250) // Justera storleken efter behov
                .padding(.horizontal)
            
            Text("Frisör plus \nadministration")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)
               
            Text("Alla bookningar:")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
            AdminBookingsCardView()
            
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(trailing: Button("Log Out") {
                    userViewModel.logoutAndUnsubscribe()
                    presentationMode.wrappedValue.dismiss()
                })
        }
        Spacer()
    }
}

struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView().environmentObject(InfoBookingsViewModel())
    }
}
