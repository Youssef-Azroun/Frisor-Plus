import SwiftUI

struct CreateAccountView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var phoneNumber: String = ""
    @State private var isPasswordVisible = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
         VStack {
            HStack {
                    Image(systemName: "envelope")
                        .foregroundColor(.gray)
                    TextField("Email", text: $email)
                        .foregroundColor(.black)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(20)

                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.gray)
                    if isPasswordVisible {
                        TextField("Password", text: $password)
                            .foregroundColor(.black)
                    } else {
                        SecureField("Password", text: $password)
                            .foregroundColor(.black)
                    }
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 10)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(20)

                HStack {
                    Image(systemName: "person")
                        .foregroundColor(.gray)
                    TextField("First name", text: $firstName)
                        .foregroundColor(.black)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(20)

                HStack {
                    Image(systemName: "person")
                        .foregroundColor(.gray)
                    TextField("Last name", text: $lastName)
                        .foregroundColor(.black)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(20)

                HStack {
                    Image(systemName: "phone")
                        .foregroundColor(.gray)
                    TextField("Phone number", text: $phoneNumber)
                        .foregroundColor(.black)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(20)

            Button("Create account") {
                // Handle log in action
                let phoneInt = Int(phoneNumber) ?? 0
                userViewModel.createUser(email: email, password: password, firstName: firstName, lastName: lastName, phoneNumber: phoneInt) { success, message in
                    if success {
                        // Show alert and dismiss view
                        showAlert = true
                        alertMessage = message
                    } else {
                        // Show error alert
                        showAlert = true
                        alertMessage = message
                    }
                }
            }
            .padding()
            .background(Color.brown.opacity(5))
            .cornerRadius(10.0)
            .foregroundColor(.white)
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Account Creation"), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                presentationMode.wrappedValue.dismiss()
            })
        }
}
}

struct CreateAccount_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
    }
}
