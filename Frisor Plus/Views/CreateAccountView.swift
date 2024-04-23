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
    
    private var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty && !firstName.isEmpty && !lastName.isEmpty && !phoneNumber.isEmpty
    }
    
    var body: some View {
         VStack {
             Image("logo")
                 .resizable()
                 .scaledToFit()
                 .frame(width: 250, height: 250) // Justera storleken efter behov
                 .padding(.bottom, 10)
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
                        TextField("Lösenord", text: $password)
                            .foregroundColor(.black)
                    } else {
                        SecureField("Lösenord", text: $password)
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
                    TextField("Förnamn", text: $firstName)
                        .foregroundColor(.black)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(20)

                HStack {
                    Image(systemName: "person")
                        .foregroundColor(.gray)
                    TextField("Efternamn", text: $lastName)
                        .foregroundColor(.black)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(20)

                HStack {
                    Image(systemName: "phone")
                        .foregroundColor(.gray)
                    TextField("Telefonnummer", text: $phoneNumber)
                        .foregroundColor(.black)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(20)
                .padding(.bottom, 20)

            Button("Skapa konto") {
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
            .background(isFormValid ? Color.brown.opacity(5) : Color.gray)
            .cornerRadius(10.0)
            .foregroundColor(.white)
            .disabled(!isFormValid)
        }
        .padding()
        Spacer()
        .alert(isPresented: $showAlert) {
    Alert(
        title: Text("Konto skapande"),
        message: Text(alertMessage),
        primaryButton: .default(Text("OK")) {
            presentationMode.wrappedValue.dismiss()
        },
        secondaryButton: .cancel(Text("Avbryt"))
    )
}
}
}

struct CreateAccount_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
    }
}
