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
    var body: some View {
        Text("Admin View")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(trailing: Button("Log Out") {
                userViewModel.logoutAndUnsubscribe()
                presentationMode.wrappedValue.dismiss()
            })
    }
}

struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView()
    }
}