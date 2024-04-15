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
            Text("My Account View")
        }
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
