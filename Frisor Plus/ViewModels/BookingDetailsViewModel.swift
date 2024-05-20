//
//  BookingDetailsViewModel.swift
//  Frisor Plus
//
//  Created by Kanyaton Somjit on 2024-04-19.
//

import Foundation
import Firebase

class BookingDetailsViewModel: ObservableObject {
    
    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "sv_SE")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }

    func fetchUserDetails(completion: @escaping (User?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        Firestore.firestore().collection("Users").document(userId).getDocument { (document, error) in
            guard let document = document, document.exists, let data = document.data() else {
                completion(nil)
                return
            }
            let user = User(
                admin: data["admin"] as? Bool ?? false,
                email: data["email"] as? String ?? "",
                firstName: data["firstName"] as? String ?? "",
                lastName: data["lastName"] as? String ?? "",
                phoneNumber: data["phoneNumber"] as? Int ?? 0
            )
            completion(user)
        }
    }

    func saveBookingDetails(booking: Bookings, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let bookingID = UUID().uuidString
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let bookingDate = dateFormatter.date(from: booking.selectedDate) else {
            print("Invalid date format")
            completion(false)
            return
        }
        let bookingData: [String: Any] = [
            "email": booking.email,
            "firstName": booking.firstName,
            "lastName": booking.lastName,
            "phoneNumber": booking.phoneNumber,
            "price": booking.price,
            "selectedDate": formattedDate(bookingDate),
            "selectedTime": booking.selectedTime,
            "typeOfCut": booking.typeOfCut
        ]

        // Save to AllBookings
        db.collection("AllBookings").document(bookingID).setData(bookingData) { error in
            if let error = error {
                print("Error saving booking to AllBookings: \(error.localizedDescription)")
                completion(false)
                return
            }

            // Save to UserBookings
            if let userId = Auth.auth().currentUser?.uid {
                db.collection("UsersBookings").document(userId).collection("UserBookings").document(bookingID).setData(bookingData) { error in
                    if let error = error {
                        print("Error saving booking to UserBookings: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        completion(true)
                    }
                }
            } else {
                print("User not logged in")
                completion(false)
            }
        }
    }

    func saveBookingToAllBookingsOnly(booking: Bookings, completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        let bookingID = UUID().uuidString // Generate a unique ID for the booking
        let bookingData: [String: Any] = [
            "email": booking.email,
            "firstName": booking.firstName,
            "lastName": booking.lastName,
            "phoneNumber": booking.phoneNumber,
            "price": booking.price,
            "selectedDate": booking.selectedDate,
            "selectedTime": booking.selectedTime,
            "typeOfCut": booking.typeOfCut
        ]
        db.collection("AllBookings").document(bookingID).setData(bookingData) { error in
            if let error = error {
                print("Error saving booking to AllBookings: \(error.localizedDescription)")
            } else {
                completion()
            }
        }
    }

        func fetchBookingsForDate(date: String, completion: @escaping ([String]) -> Void) {
        let db = Firestore.firestore()
        db.collection("AllBookings").whereField("selectedDate", isEqualTo: date).getDocuments { (querySnapshot, error) in
            var bookedTimes: [String] = []
            if let snapshot = querySnapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    if let time = data["selectedTime"] as? String {
                        bookedTimes.append(time)
                    }
                }
            }
            completion(bookedTimes)
        }
    }
}
