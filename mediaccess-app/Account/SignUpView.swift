import SwiftUI

struct SignUpView: View {
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var phoneNumber = ""
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showPassword = false
    
    // Animation states
    @State private var animateContent = false
    @State private var animateFields = false
    @State private var animateButton = false
    
    let onBackTapped: () -> Void
    let onSignUpSuccess: () -> Void
    let onLoginTapped: () -> Void
    
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
                
                FloatingRegistrationElements()
                
                VStack(spacing: 0) {
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
                                Text("Join MediAccess")
                                    .font(.system(size: 28, weight: .bold, design: .rounded))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [Color(red: 0.1, green: 0.4, blue: 0.8), Color(red: 0.2, green: 0.6, blue: 0.9)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                
                                Text("Create your account")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            // Invisible spacer for balance
                            Circle()
                                .fill(Color.clear)
                                .frame(width: 44, height: 44)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                        .opacity(animateContent ? 1.0 : 0.0)
                        .offset(y: animateContent ? 0 : -20)
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            
                            
                            // Welcome Message
                            VStack(spacing: 8) {
                                Text("Welcome to better healthcare")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.black.opacity(0.7))
                                
                                Text("Fill in your details to get started")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                            .padding(.top, 20)
                            .padding(.bottom, 32)
                            .opacity(animateContent ? 1.0 : 0.0)
                            .offset(y: animateContent ? 0 : -10)
                            
                            // Form Fields
                            VStack(spacing: 20) {
                                // Full Name Field
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Full Name")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.black.opacity(0.8))
                                    
                                    HStack(spacing: 12) {
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 18))
                                            .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.8))
                                            .frame(width: 24)
                                        
                                        TextField("Enter your full name", text: $fullName)
                                            .font(.system(size: 16))
                                            .foregroundColor(.black)
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 18)
                                    .background(Color.white)
                                    .cornerRadius(16)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(
                                                fullName.isEmpty ? Color.gray.opacity(0.2) : Color(red: 0.1, green: 0.4, blue: 0.8).opacity(0.3),
                                                lineWidth: 1.5
                                            )
                                    )
                                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                                }
                                .opacity(animateFields ? 1.0 : 0.0)
                                .offset(x: animateFields ? 0 : -50)
                                
                                // Email Field
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
                                
                                // Password Field
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
                                            } else {
                                                SecureField("Enter your password", text: $password)
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
                                    
                                    // Password requirements
                                    if !password.isEmpty {
                                        HStack(spacing: 8) {
                                            Image(systemName: password.count >= 6 ? "checkmark.circle.fill" : "xmark.circle.fill")
                                                .font(.system(size: 12))
                                                .foregroundColor(password.count >= 6 ? .green : .red)
                                            
                                            Text("At least 6 characters")
                                                .font(.system(size: 12))
                                                .foregroundColor(password.count >= 6 ? .green : .red)
                                            
                                            Spacer()
                                        }
                                        .padding(.horizontal, 4)
                                    }
                                }
                                .opacity(animateFields ? 1.0 : 0.0)
                                .offset(x: animateFields ? 0 : -50)
                                
                                // Phone Number Field
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Phone Number")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.black.opacity(0.8))
                                    
                                    HStack(spacing: 12) {
                                        Image(systemName: "phone.fill")
                                            .font(.system(size: 18))
                                            .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.8))
                                            .frame(width: 24)
                                        
                                        TextField("Enter your phone number", text: $phoneNumber)
                                            .font(.system(size: 16))
                                            .keyboardType(.phonePad)
                                            .foregroundColor(.black)
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 18)
                                    .background(Color.white)
                                    .cornerRadius(16)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(
                                                phoneNumber.isEmpty ? Color.gray.opacity(0.2) : Color(red: 0.1, green: 0.4, blue: 0.8).opacity(0.3),
                                                lineWidth: 1.5
                                            )
                                    )
                                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                                }
                                .opacity(animateFields ? 1.0 : 0.0)
                                .offset(x: animateFields ? 0 : -50)
                            }
                            .padding(.horizontal, 24)
                            
                            // Terms and Conditions
                            HStack(spacing: 8) {
                                Image(systemName: "info.circle.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.8))
                                
                                Text("By signing up, you agree to our Terms of Service and Privacy Policy")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 24)
                            .opacity(animateFields ? 1.0 : 0.0)
                            
                            // Sign Up Button
                            Button(action: {
                                signUpUser()
                            }) {
                                HStack(spacing: 12) {
                                    if isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                            .scaleEffect(0.9)
                                    } else {
                                        Image(systemName: "person.badge.plus.fill")
                                            .font(.system(size: 16, weight: .semibold))
                                    }
                                    
                                    Text(isLoading ? "Creating Account..." : "Create Account")
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
                            .padding(.horizontal, 24)
                            .padding(.top, 32)
                            .scaleEffect(animateButton ? 1.0 : 0.9)
                            .opacity(animateButton ? 1.0 : 0.0)
                            
                            // Login Link
                            VStack(spacing: 12) {
                                Text("Already have an account?")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                                
                                Button(action: {
                                    onLoginTapped()
                                }) {
                                    Text("Sign In Instead")
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
                            .padding(.top, 24)
                            .padding(.bottom, max(geometry.safeAreaInsets.bottom + 20, 40))
                            .opacity(animateButton ? 1.0 : 0.0)
                            .offset(y: animateButton ? 0 : 20)
                        }
                    }
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
            
            withAnimation(.easeOut(duration: 0.6).delay(0.5)) {
                animateButton = true
            }
        }
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

struct FloatingRegistrationElements: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            ForEach(0..<10, id: \.self) { index in
                FloatingRegistrationIcon(
                    icon: ["person.badge.plus", "heart.text.square", "doc.text.fill", "calendar.badge.plus", "stethoscope", "cross.case", "pills", "bandage", "leaf.fill", "drop.fill"][index],
                    delay: Double(index) * 0.2
                )
            }
        }
    }
}

struct FloatingRegistrationIcon: View {
    let icon: String
    let delay: Double
    @State private var animate = false
    
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: CGFloat.random(in: 14...22), weight: .light))
            .foregroundColor(Color.blue.opacity(0.06))
            .offset(
                x: animate ? CGFloat.random(in: -120...120) : CGFloat.random(in: -40...40),
                y: animate ? CGFloat.random(in: -250...250) : CGFloat.random(in: -80...80)
            )
            .scaleEffect(animate ? CGFloat.random(in: 0.4...1.0) : 0.6)
            .rotationEffect(.degrees(animate ? Double.random(in: 0...180) : 0))
            .opacity(animate ? Double.random(in: 0.02...0.08) : 0.04)
            .animation(
                .easeInOut(duration: Double.random(in: 15...25))
                .repeatForever(autoreverses: true)
                .delay(delay),
                value: animate
            )
            .onAppear {
                animate = true
            }
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
