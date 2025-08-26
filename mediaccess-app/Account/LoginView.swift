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
    @State private var showPassword = false
    
    @State private var unlocked = false
    @State private var text = "LOCKED"
    
    @State private var animateContent = false
    @State private var animateFields = false
    @State private var animateButtons = false
    
    let onBackTapped: () -> Void
    let onLoginSuccess: () -> Void
    let onSignUpTapped: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.95, green: 0.98, blue: 1.0),
                        Color(red: 0.9, green: 0.95, blue: 1.0),
                        Color.white
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                FloatingMedicalElements()
                
                VStack(spacing: 0) {
                    HStack {
                        Button(action: {
                            onBackTapped()
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 44, height: 44)
                                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                                
                                Image(systemName: "arrow.left")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.8))
                            }
                        }
                        
                        Spacer()
                        
                        VStack(spacing: 4) {
                            Text("Welcome Back")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color(red: 0.1, green: 0.4, blue: 0.8), Color(red: 0.2, green: 0.6, blue: 0.9)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                            
                            Text("Sign in to your account")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Circle()
                            .fill(Color.clear)
                            .frame(width: 44, height: 44)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : -20)
                    
                    Spacer(minLength: 40)
                    
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Email Address")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black.opacity(0.8))
                            
                            HStack(spacing: 12) {
                                Image(systemName: "envelope.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.8))
                                    .frame(width: 24)
                                
                                TextField("Enter your email", text: $email)
                                    .font(.system(size: 16))
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .foregroundColor(.black)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 18)
                            .background(Color.white)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(
                                        email.isEmpty ? Color.gray.opacity(0.2) : Color(red: 0.1, green: 0.4, blue: 0.8).opacity(0.3),
                                        lineWidth: 1.5
                                    )
                            )
                            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                        }
                        .opacity(animateFields ? 1.0 : 0.0)
                        .offset(x: animateFields ? 0 : -50)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Password")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black.opacity(0.8))
                            
                            HStack(spacing: 12) {
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.8))
                                    .frame(width: 24)
                                
                                Group {
                                    if showPassword {
                                        TextField("Enter your password", text: $password)
                                            .autocapitalization(.none)
                                            .textInputAutocapitalization(.never)
                                            .disableAutocorrection(true)
                                    } else {
                                        SecureField("Password", text: $password)
                                            .autocapitalization(.none)
                                            .textInputAutocapitalization(.never)
                                            .disableAutocorrection(true)
                                    }
                                }
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                                
                                Button(action: {
                                    showPassword.toggle()
                                }) {
                                    Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 18)
                            .background(Color.white)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(
                                        password.isEmpty ? Color.gray.opacity(0.2) : Color(red: 0.1, green: 0.4, blue: 0.8).opacity(0.3),
                                        lineWidth: 1.5
                                    )
                            )
                            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                        }
                        .opacity(animateFields ? 1.0 : 0.0)
                        .offset(x: animateFields ? 0 : -50)
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer(minLength: 40)
                    
                    VStack(spacing: 16) {
                        Button(action: {
                            loginUser()
                        }) {
                            HStack(spacing: 12) {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.9)
                                } else {
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                                
                                Text(isLoading ? "Signing In..." : "Sign In")
                                    .font(.system(size: 18, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                LinearGradient(
                                    colors: isLoading ?
                                    [Color.blue.opacity(0.7), Color.blue.opacity(0.5)] :
                                        [Color(red: 0.1, green: 0.4, blue: 0.8), Color(red: 0.2, green: 0.6, blue: 0.9)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                            .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .disabled(isLoading)
                        .scaleEffect(animateButtons ? 1.0 : 0.9)
                        .opacity(animateButtons ? 1.0 : 0.0)
                        
                        HStack {
                            VStack { Divider().background(Color.gray.opacity(0.3)) }
                            Text("OR")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                                .padding(.horizontal, 16)
                            VStack { Divider().background(Color.gray.opacity(0.3)) }
                        }
                        .padding(.vertical, 8)
                        .opacity(animateButtons ? 1.0 : 0.0)
                        
                        Button(action: {
                            handleBiometricAuth()
                        }) {
                            HStack(spacing: 12) {
                                if isFaceIDLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.9)
                                } else {
                                    Image(systemName: "faceid")
                                        .font(.system(size: 20, weight: .medium))
                                }
                                
                                Text(isFaceIDLoading ? "Authenticating..." : "Continue with Face ID")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                LinearGradient(
                                    colors: isFaceIDLoading ?
                                    [Color.green.opacity(0.7), Color.green.opacity(0.5)] :
                                        [Color(red: 0.2, green: 0.7, blue: 0.4), Color(red: 0.1, green: 0.6, blue: 0.3)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                            .shadow(color: Color.green.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .disabled(isFaceIDLoading)
                        .scaleEffect(animateButtons ? 1.0 : 0.9)
                        .opacity(animateButtons ? 1.0 : 0.0)
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer(minLength: 20)
                    
                    VStack(spacing: 12) {
                        Text("Don't have an account?")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                        
                        Button(action: {
                            onSignUpTapped()
                        }) {
                            Text("Create Account")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color(red: 0.1, green: 0.4, blue: 0.8), Color(red: 0.2, green: 0.6, blue: 0.9)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        }
                    }
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom + 20, 40))
                    .opacity(animateButtons ? 1.0 : 0.0)
                    .offset(y: animateButtons ? 0 : 20)
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                animateContent = true
            }
            
            withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                animateFields = true
            }
            
            withAnimation(.easeOut(duration: 0.6).delay(0.4)) {
                animateButtons = true
            }
        }
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
        
        guard canEvaluate else {
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(BiometricError.notAvailable))
            }
            return
        }
        
        let reason = "Use Face ID to log into your account"
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
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

struct FloatingMedicalElements: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            ForEach(0..<8, id: \.self) { index in
                FloatingMedicalIcon(
                    icon: ["heart.fill", "cross.case.fill", "pills.fill", "drop.fill", "bandage.fill", "stethoscope", "cross.fill", "leaf.fill"][index],
                    delay: Double(index) * 0.3
                )
            }
        }
    }
}

struct FloatingMedicalIcon: View {
    let icon: String
    let delay: Double
    @State private var animate = false
    
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: CGFloat.random(in: 16...24), weight: .light))
            .foregroundColor(Color.blue.opacity(0.08))
            .offset(
                x: animate ? CGFloat.random(in: -150...150) : CGFloat.random(in: -50...50),
                y: animate ? CGFloat.random(in: -300...300) : CGFloat.random(in: -100...100)
            )
            .scaleEffect(animate ? CGFloat.random(in: 0.3...1.2) : 0.5)
            .rotationEffect(.degrees(animate ? Double.random(in: 0...360) : 0))
            .opacity(animate ? Double.random(in: 0.03...0.1) : 0.05)
            .animation(
                .easeInOut(duration: Double.random(in: 12...20))
                .repeatForever(autoreverses: true)
                .delay(delay),
                value: animate
            )
            .onAppear {
                animate = true
            }
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
