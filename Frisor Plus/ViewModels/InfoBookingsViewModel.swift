//
//  InfoBookingsViewModel.swift
//  Frisor Plus
//
//  Created by Kanyaton Somjit on 2024-04-19.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class InfoBookingsViewModel: ObservableObject {
    @Published var bookings = [Bookings]()
    let db = Firestore.firestore()
    
    
    func deleteBooking(bookingId: String) {
        let bookingRef = db.collection("AllBookings")
        bookingRef.document(bookingId).delete { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.bookings.removeAll { $0.id == bookingId }
                }
            }
        }
    }

    
    func showAllBookings() {
        Firestore.firestore().collection("AllBookings").addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    let data = diff.document.data()
                    let newBooking = Bookings(
                        id: diff.document.documentID,
                        email: data["email"] as? String ?? "",
                        firstName: data["firstName"] as? String ?? "",
                        lastName: data["lastName"] as? String ?? "",
                        phoneNumber: data["phoneNumber"] as? Int ?? 0,
                        price: data["price"] as? String ?? "",
                        selectedDate: data["selectedDate"] as? String ?? "",
                        selectedTime: data["selectedTime"] as? String ?? "",
                        typeOfCut: data["typeOfCut"] as? String ?? ""
                    )
                    self.bookings.append(newBooking)
                }
                if (diff.type == .removed) {
                    if let index = self.bookings.firstIndex(where: { $0.id == diff.document.documentID }) {
                        self.bookings.remove(at: index)
                    }
                }
            }
            self.bookings.sort(by: { $0.dateTime ?? Date.distantFuture < $1.dateTime ?? Date.distantFuture })
        }
    }
    
   
    func fetchBookings() {
        let userId = Auth.auth().currentUser?.uid ?? ""
        Firestore.firestore().collection("UsersBookings").document(userId).collection("UserBookings").getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                self.bookings = querySnapshot.documents.compactMap { document in
                    let data = document.data()
                    return Bookings(
                        id: document.documentID,
                        email: data["email"] as? String ?? "",
                        firstName: data["firstName"] as? String ?? "",
                        lastName: data["lastName"] as? String ?? "",
                        phoneNumber: data["phoneNumber"] as? Int ?? 0,
                        price: data["price"] as? String ?? "",
                        selectedDate: data["selectedDate"] as? String ?? "",
                        selectedTime: data["selectedTime"] as? String ?? "",
                        typeOfCut: data["typeOfCut"] as? String ?? ""
                    )
                }.sorted(by: { $0.dateTime ?? Date.distantFuture < $1.dateTime ?? Date.distantFuture })
            } else {
                print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
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

    func updateUserDetails(firstName: String, lastName: String, phoneNumber: Int, completion: @escaping (Bool, String) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(false, "User not found")
            return
        }
        let userRef = Firestore.firestore().collection("Users").document(userId)
        userRef.updateData([
            "firstName": firstName,
            "lastName": lastName,
            "phoneNumber": phoneNumber
        ]) { error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                completion(true, "Dina uppgifter har uppdaterats framgångsrikt.")
            }
        }
    }
}
