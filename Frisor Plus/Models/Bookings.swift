//
//  Bookings.swift
//  Frisor Plus
//
//  Created by Kanyaton Somjit on 2024-04-19.
//

import Foundation

struct Bookings: Identifiable {
    
    var id: String?
    var email: String
    var firstName: String
    var lastName: String
    var phoneNumber: Int
    var price: String
    var selectedDate: String
    var selectedTime: String
    var typeOfCut: String
    
    var dateTime: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-ddHH:mm"
        let dateString = "\(selectedDate)\(selectedTime)"
        return dateFormatter.date(from: dateString)
    }
}
