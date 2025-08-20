import SwiftUI
import LocalAuthentication

// Data models for API response
struct LoginResponse: Codable {
    let message: String
    let patient: Patient
}

struct Patient: Codable {
    let id: String
    var email: String
    var name: String?
    var phone: String?
    var contactNumber: String?
    var address: String?
    var bloodType: String?
    var allergy: String?
    var medications: String?
    var nicNo: String?
    var dob: String?
    var gender: String?
    var emergencyContact: [EmergencyContact]?
    
    // Map contactNumber to phone for consistency
    var phoneNumber: String? {
        return phone ?? contactNumber
    }
}

// EmergencyContact model for the emergency contact array
//struct EmergencyContact: Codable {
//    let id: String
//    let name: String
//    let contactNumber: String
//    let relation: String
//}

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
        
        // Email format validation
        guard email.contains("@") && email.contains(".") else {
            alertMessage = "Please enter a valid email address"
            showAlert = true
            return
        }
        
        isLoading = true
        
        // API call to authenticate user
        authenticateWithAPI(email: email, password: password)
    }
    
    private func authenticateWithAPI(email: String, password: String) {
        guard let url = URL(string: "https://mediaccess.vercel.app/api/patient/login") else {
            DispatchQueue.main.async {
                self.isLoading = false
                self.alertMessage = "Invalid API endpoint"
                self.showAlert = true
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create request body
        let requestBody: [String: String] = [
            "email": email,
            "password": password
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            DispatchQueue.main.async {
                self.isLoading = false
                self.alertMessage = "Failed to prepare request"
                self.showAlert = true
            }
            return
        }
        
        // Make the API call
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                // Handle network error
                if let error = error {
                    self.alertMessage = "Network error: \(error.localizedDescription)"
                    self.showAlert = true
                    return
                }
                
                // Handle HTTP response
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        // Success - parse the response
                        if let data = data {
                            do {
                                let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                                
                                // Store user data and login state
                                self.storeUserData(patient: loginResponse.patient)
                                
                                // Navigate to success
                                self.onLoginSuccess()
                                
                            } catch {
                                self.alertMessage = "Failed to parse server response"
                                self.showAlert = true
                            }
                        }
                    } else if httpResponse.statusCode == 401 {
                        // Invalid credentials
                        self.alertMessage = "Invalid email or password"
                        self.showAlert = true
                    } else if httpResponse.statusCode == 400 {
                        // Bad request
                        self.alertMessage = "Please check your email and password"
                        self.showAlert = true
                    } else {
                        // Other server errors
                        self.alertMessage = "Server error. Please try again later"
                        self.showAlert = true
                    }
                }
            }
        }.resume()
    }
    
    private func storeUserData(patient: Patient) {
        // Store user data in UserDefaults for persistence with correct keys
        UserDefaults.standard.set(patient.email, forKey: "email")
        UserDefaults.standard.set(patient.id, forKey: "id") // Changed from "userId" to "patientId"
        UserDefaults.standard.set(patient.name, forKey: "name") // Keep as userName for compatibility
        UserDefaults.standard.set(patient.phoneNumber, forKey: "contactNumber") // Changed from "userPhone" to "contactNumber"
        UserDefaults.standard.set(patient.dob, forKey: "dob") // Add dob storage
        UserDefaults.standard.set(patient.address, forKey: "address") // Add address storage
        UserDefaults.standard.set(patient.bloodType, forKey: "bloodType") // Add bloodType storage
        UserDefaults.standard.set(patient.allergy, forKey: "allergy") // Add allergy storage
        UserDefaults.standard.set(patient.medications, forKey: "medications") // Add medications storage
        UserDefaults.standard.set(patient.nicNo, forKey: "nicNo") // Add nicNo storage
        UserDefaults.standard.set(patient.gender, forKey: "gender") // Add gender storage
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        
        // Store patient data as JSON for future use
        if let patientData = try? JSONEncoder().encode(patient) {
            UserDefaults.standard.set(patientData, forKey: "patientData")
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
                self.isFaceIDLoading = false
                
                if success {
                    // Authentication successful
                    // Check if user has previously logged in and stored credentials
                    if let storedEmail = UserDefaults.standard.string(forKey: "userEmail"),
                       UserDefaults.standard.bool(forKey: "isLoggedIn") {
                        // User has previously logged in, authenticate them
                        self.onLoginSuccess()
                    } else {
                        // No stored credentials, prompt them to log in first
                        self.alertMessage = "Please log in with email and password first to enable biometric authentication"
                        self.showAlert = true
                    }
                } else {
                    // Authentication failed
                    if let error = authenticationError as? LAError {
                        switch error.code {
                        case .userCancel:
                            self.alertMessage = "Authentication was cancelled"
                        case .userFallback:
                            self.alertMessage = "Authentication failed. Please try again"
                        case .biometryNotAvailable:
                            self.alertMessage = "Biometric authentication is not available"
                        case .biometryNotEnrolled:
                            self.alertMessage = "No biometric authentication is set up on this device"
                        case .biometryLockout:
                            self.alertMessage = "Biometric authentication is locked. Please try again later"
                        default:
                            self.alertMessage = "Authentication failed: \(error.localizedDescription)"
                        }
                    } else {
                        self.alertMessage = "Authentication failed. Please try again"
                    }
                    self.showAlert = true
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
