import SwiftUI
import LocalAuthentication

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
    var dependent: [Dependent]?
    
    var phoneNumber: String? {
        return phone ?? contactNumber
    }
}

struct Dependent: Codable, Identifiable {
    let id: String
    let name: String
    let relationship: String
    let dob: String
}

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = "Login"
    @State private var isFaceIDLoading = false
    
    @State private var unlocked = false
    @State private var text = "LOCKED"
    
    let onBackTapped: () -> Void
    let onLoginSuccess: () -> Void
    let onSignUpTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
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
                
                Button(action: {}) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .opacity(0)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            VStack(spacing: 20) {
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
            
            VStack(spacing: 16) {
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
                
                Button(action: {
                    handleBiometricAuth()
                }) {
                    HStack {
                        if isFaceIDLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "faceid")
                                .font(.system(size: 16))
                        }
                        Text(isFaceIDLoading ? "Authenticating..." : "Face ID")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(isFaceIDLoading ? Color.green.opacity(0.7) : Color.green)
                    .cornerRadius(12)
                }
                .disabled(isFaceIDLoading)

            }
            .padding(.horizontal, 20)
            
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
        .alert(alertTitle, isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func loginUser() {
        guard !email.isEmpty, !password.isEmpty else {
            showAlert(title: "Login", message: "Please fill in both email and password")
            return
        }
        
        guard email.contains("@") && email.contains(".") else {
            showAlert(title: "Login", message: "Please enter a valid email address")
            return
        }
        
        isLoading = true
        
        authenticateWithAPI(email: email, password: password)
    }
    
    private func authenticateWithAPI(email: String, password: String) {
        guard let url = URL(string: "https://mediaccess.vercel.app/api/patient/login") else {
            DispatchQueue.main.async {
                self.isLoading = false
                self.showAlert(title: "Error", message: "Invalid API endpoint")
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: String] = [
            "email": email,
            "password": password
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            DispatchQueue.main.async {
                self.isLoading = false
                self.showAlert(title: "Error", message: "Failed to prepare request")
            }
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    self.showAlert(title: "Network Error", message: error.localizedDescription)
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        if let data = data {
                            do {
                                let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                                
                                self.storeUserData(patient: loginResponse.patient)
                                
                                self.onLoginSuccess()
                                
                            } catch {
                                self.showAlert(title: "Error", message: "Failed to parse server response")
                            }
                        }
                    } else if httpResponse.statusCode == 401 {
                        self.showAlert(title: "Login Failed", message: "Invalid email or password")
                    } else if httpResponse.statusCode == 400 {
                        self.showAlert(title: "Login Failed", message: "Please check your email and password")
                    } else {
                        self.showAlert(title: "Server Error", message: "Please try again later")
                    }
                }
            }
        }.resume()
    }
    
    private func storeUserData(patient: Patient) {
        UserDefaults.standard.set(patient.email, forKey: "email")
        UserDefaults.standard.set(patient.email, forKey: "userEmail")
        UserDefaults.standard.set(patient.id, forKey: "id")
        UserDefaults.standard.set(patient.id, forKey: "patientId")
        UserDefaults.standard.set(patient.name, forKey: "name")
        UserDefaults.standard.set(patient.name, forKey: "userName")
        UserDefaults.standard.set(patient.phoneNumber, forKey: "contactNumber")
        UserDefaults.standard.set(patient.phoneNumber, forKey: "userPhone")
        UserDefaults.standard.set(patient.dob, forKey: "dob")
        UserDefaults.standard.set(patient.address, forKey: "address")
        UserDefaults.standard.set(patient.bloodType, forKey: "bloodType")
        UserDefaults.standard.set(patient.allergy, forKey: "allergy")
        UserDefaults.standard.set(patient.medications, forKey: "medications")
        UserDefaults.standard.set(patient.nicNo, forKey: "nicNo")
        UserDefaults.standard.set(patient.gender, forKey: "gender")
        
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        
        if let patientData = try? JSONEncoder().encode(patient) {
            UserDefaults.standard.set(patientData, forKey: "patientData")
        }

        if let dependents = patient.dependent,
       let dependentsData = try? JSONEncoder().encode(dependents) {
        UserDefaults.standard.set(dependentsData, forKey: "dependents")
    }
    }
    
    
    private func handleBiometricAuth() {
        guard biometricAuthenticationAvailable() else {
            showAlert(title: "Face ID Not Available", message: "Biometric authentication is not available on this device.")
            return
        }
        
        isFaceIDLoading = true
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        authenticateWithBiometrics { result in
            DispatchQueue.main.async {
                self.isFaceIDLoading = false
                
                switch result {
                case .success(_):
                    let successFeedback = UINotificationFeedbackGenerator()
                    successFeedback.notificationOccurred(.success)
                    
                    self.checkUserOnboardingStatus()
                case .failure(let error):
                    let errorFeedback = UINotificationFeedbackGenerator()
                    errorFeedback.notificationOccurred(.error)
                    
                    let errorMessage = self.handleBiometricError(error)
                    self.showAlert(title: "Face ID Authentication Failed", message: errorMessage)
                }
            }
        }
    }
    
    private func checkUserOnboardingStatus() {
        if let _ = UserDefaults.standard.string(forKey: "userEmail") {
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            self.onLoginSuccess()
        } else {
            self.showAlert(title: "Setup Required", message: "Please log in with email and password first to enable Face ID authentication")
        }
    }
    
    private func authenticateWithBiometrics(completion: @escaping (Result<Bool, Error>) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        context.localizedFallbackTitle = "Use Passcode"
        context.localizedCancelTitle = "Cancel"
        
        let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        print("Can evaluate biometrics: \(canEvaluate)")
        if let error = error {
            print("Biometric evaluation error: \(error.localizedDescription)")
        }
        print("Biometry type: \(context.biometryType.rawValue)")
        
        guard canEvaluate else {
            print("Cannot evaluate biometric policy")
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(BiometricError.notAvailable))
            }
            return
        }
        
        let reason = "Use Face ID to log into your account"
        
        print("Starting biometric evaluation...")
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
            print("Biometric evaluation completed - Success: \(success)")
            
            if let authError = authenticationError {
                print("Authentication error: \(authError.localizedDescription)")
                if let laError = authError as? LAError {
                    print("LAError code: \(laError.code.rawValue)")
                }
            }
            
            if success {
                completion(.success(true))
            } else {
                if let error = authenticationError {
                    completion(.failure(error))
                } else {
                    completion(.failure(BiometricError.authenticationFailed))
                }
            }
        }
    }
    
    private func handleBiometricError(_ error: Error) -> String {
        if let laError = error as? LAError {
            switch laError.code {
            case .userCancel:
                return "Authentication was cancelled"
            case .userFallback:
                return "Authentication failed. Please try again"
            case .biometryNotAvailable:
                return "Face ID is not available on this device"
            case .biometryNotEnrolled:
                return "No Face ID is set up on this device. Please set up Face ID in Settings"
            case .biometryLockout:
                return "Face ID is locked. Please try again later or use your passcode"
            case .authenticationFailed:
                return "Face ID authentication failed. Please try again"
            case .invalidContext:
                return "Authentication context is invalid"
            case .notInteractive:
                return "Authentication failed because user interaction is not allowed"
            default:
                return "Authentication failed: \(laError.localizedDescription)"
            }
        } else {
            return "Authentication failed. Please try again"
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
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}

enum BiometricError: Error {
    case notAvailable
    case authenticationFailed
    case notEnrolled
    
    var localizedDescription: String {
        switch self {
        case .notAvailable:
            return "Biometric authentication is not available"
        case .authenticationFailed:
            return "Authentication failed"
        case .notEnrolled:
            return "No biometric authentication is enrolled"
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
