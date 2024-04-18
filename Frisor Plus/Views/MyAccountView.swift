//
//  MyAccountView.swift
//  Frisor Plus
//
//  Created by Youssef Azroun on 2024-04-11.
//

import SwiftUI

struct MyAccountView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250) // Justera storleken efter behov
                .padding(.bottom, 10)
            Text("My Account View")
        }
        Spacer()
        .navigationBarItems(trailing: Button("Log Out") {
            userViewModel.logoutUser()
            presentationMode.wrappedValue.dismiss()
        })
    }
}

struct MyAccountView_Previews: PreviewProvider {
    static var previews: some View {
        MyAccountView()
    }
}
