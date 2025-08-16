import SwiftUI
import LocalAuthentication

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isFaceIDLoading = false
    
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
                        authenticateWithBiometrics()
                    }) {
                        HStack {
                            if isFaceIDLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: biometricType() == .faceID ? "faceid" : "touchid")
                                    .font(.system(size: 16))
                            }
                            Text(isFaceIDLoading ? "Authenticating..." : biometricButtonTitle())
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(isFaceIDLoading ? Color.green.opacity(0.7) : Color.green)
                        .cornerRadius(12)
                    }
                    .disabled(isFaceIDLoading || !biometricAuthenticationAvailable())
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
    
    private func biometricAuthenticationAvailable() -> Bool {
        let context = LAContext()
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
    
    private func biometricType() -> LABiometryType {
        let context = LAContext()
        let _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        return context.biometryType
    }
    
    private func biometricButtonTitle() -> String {
        switch biometricType() {
        case .faceID:
            return "Face ID"
        case .touchID:
            return "Touch ID"
        case .opticID:
            return "Optic ID"
        default:
            return "Biometric Login"
        }
    }
    
    private func authenticateWithBiometrics() {
        let context = LAContext()
        var error: NSError?
        
        // Check if biometric authentication is available
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            alertMessage = error?.localizedDescription ?? "Biometric authentication is not available on this device"
            showAlert = true
            return
        }
        
        isFaceIDLoading = true
        
        // Set the reason for authentication
        let reason = "Authenticate to log into your account"
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
            DispatchQueue.main.async {
                isFaceIDLoading = false
                
                if success {
                    // Authentication successful
                    // Check if user has previously logged in and stored credentials
                    if let storedEmail = UserDefaults.standard.string(forKey: "userEmail") {
                        // User has previously logged in, authenticate them
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        onLoginSuccess()
                    } else {
                        // No stored credentials, prompt them to log in first
                        alertMessage = "Please log in with email and password first to enable biometric authentication"
                        showAlert = true
                    }
                } else {
                    // Authentication failed
                    if let error = authenticationError as? LAError {
                        switch error.code {
                        case .userCancel:
                            alertMessage = "Authentication was cancelled"
                        case .userFallback:
                            alertMessage = "Authentication failed. Please try again"
                        case .biometryNotAvailable:
                            alertMessage = "Biometric authentication is not available"
                        case .biometryNotEnrolled:
                            alertMessage = "No biometric authentication is set up on this device"
                        case .biometryLockout:
                            alertMessage = "Biometric authentication is locked. Please try again later"
                        default:
                            alertMessage = "Authentication failed: \(error.localizedDescription)"
                        }
                    } else {
                        alertMessage = "Authentication failed. Please try again"
                    }
                    showAlert = true
                }
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
