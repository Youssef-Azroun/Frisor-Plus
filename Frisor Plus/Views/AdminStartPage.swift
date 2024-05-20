//
//  AdminStartPage.swift
//  Frisor Plus
//
//  Created by Youssef Azroun on 2024-05-18.
//

import SwiftUI

struct AdminStartPage: View {
    @EnvironmentObject var infoBookingsViewModel: InfoBookingsViewModel

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                NavigationLink(destination: AdminView().environmentObject(infoBookingsViewModel)) {
                    Text("Se alla bokningar")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Spacer()
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct AdminStartPage_Previews: PreviewProvider {
    static var previews: some View {
        AdminStartPage()
    }
}
