//
//  Frisor_PlusApp.swift
//  Frisor Plus
//
//  Created by Youssef Azroun on 2024-04-04.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct Frisor_PlusApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var userViewModel = UserViewModel() // Create an instance of UserViewModel
    @StateObject var infoBookingsViewModel = InfoBookingsViewModel()
    @StateObject var bookingDetailsViewModel = BookingDetailsViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userViewModel) // Pass UserViewModel as an environment object
                .environmentObject(infoBookingsViewModel)
                .environmentObject(bookingDetailsViewModel)
        }
    }
}
