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
        dateFormatter.dateFormat = "EEEE d MMMM yyyy"
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
}
