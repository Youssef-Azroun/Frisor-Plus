import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseMessaging

class UserViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    
    init() {
        self.isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
    }

    func createUser(email: String, password: String, firstName: String, lastName: String, phoneNumber: Int, completion: @escaping (Bool, String) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
                var errorMessage = error.localizedDescription
                if error.code == AuthErrorCode.emailAlreadyInUse.rawValue {
                    errorMessage = "Kontot används redan av en annan användare."
                }
                completion(false, errorMessage)
                return
            }
            guard let user = authResult?.user else {
                completion(false, "Användarskapande misslyckades")
                return
            }
            user.sendEmailVerification { error in
                if let error = error {
                    completion(false, error.localizedDescription)
                    return
                }
                let userData = [
                    "admin": false,
                    "email": email,
                    "firstName": firstName,
                    "lastName": lastName,
                    "phoneNumber": phoneNumber
                ] as [String : Any]
                Firestore.firestore().collection("Users").document(user.uid).setData(userData) { error in
                    if let error = error {
                        completion(false, error.localizedDescription)
                    } else {
                        completion(true, "Ett verifieringsmeddelande har skickats till din e-postadress. Vänligen kontrollera din inkorg och genomför verifieringen. Om du inte fick verifieringsmeddelandet vänligen kontrolera dina info. tack! ")
                    }
                }
            }
        }
    }

    func loginUser(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            guard let user = authResult?.user else {
                completion(false, "Login failed")
                return
            }
            if !user.isEmailVerified {
                completion(false, "Please verify your email before logging in.")
                return
            }
            // Check if the user is an admin
            Firestore.firestore().collection("Users").document(user.uid).getDocument { document, error in
                if let document = document, let data = document.data(), let isAdmin = data["admin"] as? Bool, isAdmin {
                    // Subscribe to admin topic
                    Messaging.messaging().subscribe(toTopic: "admin")
                    self.isLoggedIn = true
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    completion(true, "Login successful, admin privileges granted.")
                } else {
                    self.isLoggedIn = true
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    completion(true, "Login successful")
                }
            }
        }
    }

    func logoutUser() {
        do {
            try Auth.auth().signOut()
            self.isLoggedIn = false
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            // Additional logic to handle anonymous users
            if Auth.auth().currentUser?.isAnonymous == true {
                Auth.auth().currentUser?.delete(completion: nil)
            }
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func checkIfUserIsAdmin(completion: @escaping (Bool) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(false)
            return
        }
        let db = Firestore.firestore()
        
        db.collection("Users").document(currentUser.uid).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let isAdmin = data?["admin"] as? Bool ?? false
                completion(isAdmin)
            } else {
                print("Document does not exist")
                completion(false)
            }
        }
    }
    
    func checkLoginStatus(completion: @escaping (Bool, Bool) -> Void) {
        let isLoggedIn = Auth.auth().currentUser != nil
        if isLoggedIn {
            checkIfUserIsAdmin { isAdmin in
                completion(true, isAdmin)
            }
        } else {
            completion(false, false)
        }
    }

    func logoutAndUnsubscribe() {
        do {
            try Auth.auth().signOut()
            Messaging.messaging().unsubscribe(fromTopic: "admin")
            self.isLoggedIn = false
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func loginAnonymously(completion: @escaping (Bool) -> Void) {
        Auth.auth().signInAnonymously { authResult, error in
            if let _ = authResult?.user, error == nil {
                self.isLoggedIn = false  // Treat as not logged in for UI purposes
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
