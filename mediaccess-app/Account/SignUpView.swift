import SwiftUI

struct SignUpView: View {
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var phoneNumber = ""
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    let onBackTapped: () -> Void
    let onSignUpSuccess: () -> Void
    let onLoginTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
                // Header
                HStack {
                    Button(action: {
                        onBackTapped()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    Text("Sign Up")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    // Invisible button for balance
                    Button(action: {}) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .opacity(0)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // Form Fields
                VStack(spacing: 20) {
                    // Full Name
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Full Name")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black)
                        
                        TextField("Enter your full name", text: $fullName)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                            .font(.system(size: 16))
                    }
                    
                    // Email
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black)
                        
                        TextField("Enter your email", text: $email)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                            .font(.system(size: 16))
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    }
                    
                    // Password
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black)
                        
                        SecureField("Enter your password", text: $password)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                            .font(.system(size: 16))
                    }
                    
                    // Phone Number
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Phone Number")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black)
                        
                        TextField("Enter your phone number", text: $phoneNumber)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                            .font(.system(size: 16))
                            .keyboardType(.phonePad)
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Sign Up Button
                Button(action: {
                    signUpUser()
                }) {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        }
                        Text(isLoading ? "Signing Up..." : "Sign Up")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(isLoading ? Color.blue.opacity(0.7) : Color.blue)
                    .cornerRadius(12)
                }
                .disabled(isLoading)
                .padding(.horizontal, 20)
                
                // Login Link
                VStack(spacing: 8) {
                    Text("Already have an account?")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    Button(action: {
                        onLoginTapped()
                    }) {
                        Text("Log In")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black)
                    }
                }
                .padding(.bottom, 40)
            }
            .background(Color.white)
            .alert("Sign Up", isPresented: $showAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
    }
    
    private func signUpUser() {
        // Basic validation
        guard !fullName.isEmpty,
              !email.isEmpty,
              !password.isEmpty,
              !phoneNumber.isEmpty else {
            alertMessage = "Please fill in all fields"
            showAlert = true
            return
        }
        
        guard isValidEmail(email) else {
            alertMessage = "Please enter a valid email address"
            showAlert = true
            return
        }
        
        guard password.count >= 6 else {
            alertMessage = "Password must be at least 6 characters"
            showAlert = true
            return
        }
        
        isLoading = true
        
        let url = URL(string: "https://mediaccess.vercel.app/api/patient/add")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody = [
            "name": fullName,
            "email": email,
            "password": password,
            "contactNumber": phoneNumber
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            isLoading = false
            alertMessage = "Error preparing request"
            showAlert = true
            return
        }
        
        // Make API call
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                
                if let error = error {
                    alertMessage = "Network error: \(error.localizedDescription)"
                    showAlert = true
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    alertMessage = "Invalid response"
                    showAlert = true
                    return
                }
                
                if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                    // Success - store user data locally (simple approach)
                    UserDefaults.standard.set(fullName, forKey: "userName")
                    UserDefaults.standard.set(email, forKey: "userEmail")
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    
                    onSignUpSuccess()
                } else {
                    // Handle API errors
                    if let data = data,
                       let errorResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let message = errorResponse["message"] as? String {
                        alertMessage = message
                    } else {
                        alertMessage = "Sign up failed. Please try again."
                    }
                    showAlert = true
                }
            }
        }.resume()
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(
            onBackTapped: {},
            onSignUpSuccess: {},
            onLoginTapped: {}
        )
    }
}
