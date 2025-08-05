import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    let onBackTapped: () -> Void
    let onLoginSuccess: () -> Void
    let onSignUpTapped: () -> Void
    
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
                    
                    Text("Log In")
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
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Login Buttons
                VStack(spacing: 16) {
                    // Log In Button
                    Button(action: {
                        loginUser()
                    }) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            }
                            Text(isLoading ? "Logging In..." : "Log In")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(isLoading ? Color.blue.opacity(0.7) : Color.blue)
                        .cornerRadius(12)
                    }
                    .disabled(isLoading)
                    
                    // Face ID Button
                    Button(action: {
                        // Simulate Face ID success for demo
                        onLoginSuccess()
                    }) {
                        Text("Face ID")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 20)
                
                // Sign Up Link
                VStack(spacing: 8) {
                    Text("No account?")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    Button(action: {
                        onSignUpTapped()
                    }) {
                        Text("Sign Up")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black)
                    }
                }
                .padding(.bottom, 40)
            }
            .background(Color.white)
            .alert("Login", isPresented: $showAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
    }
    
    private func loginUser() {
        // Basic validation
        guard !email.isEmpty, !password.isEmpty else {
            alertMessage = "Please fill in both email and password"
            showAlert = true
            return
        }
        
        isLoading = true
        
        // For demo purposes, we'll do a simple check
        // In a real app, you'd make an API call to verify credentials
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isLoading = false
            
            // Simple demo logic - you can replace this with actual API call
            if email.contains("@") && password.count >= 6 {
                // Store login state
                UserDefaults.standard.set(email, forKey: "userEmail")
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                onLoginSuccess()
            } else {
                alertMessage = "Invalid email or password"
                showAlert = true
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(
            onBackTapped: {},
            onLoginSuccess: {},
            onSignUpTapped: {}
        )
    }
}
