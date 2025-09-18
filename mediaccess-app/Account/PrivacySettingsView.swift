import SwiftUI

struct PrivacySettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var showCurrentPassword = false
    @State private var showNewPassword = false
    @State private var showConfirmPassword = false
    @State private var isLoading = false
    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var alertType: AlertType = .error
    
    // Get patient data from UserDefaults
    private var patientId: String {
        UserDefaults.standard.string(forKey: "patientId") ?? ""
    }
    
    private var patientEmail: String {
        UserDefaults.standard.string(forKey: "userEmail") ?? ""
    }
    
    enum AlertType {
        case success, error
    }
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            
            ScrollView {
                VStack(spacing: 24) {
                    passwordSection
                    securityInfoCard
                    Spacer(minLength: 120)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            
            updateButton
        }
        .background(Color(.systemGroupedBackground))
        .alert(alertType == .success ? "Success" : "Error", isPresented: $showAlert) {
            Button("OK") {
                if alertType == .success {
                    clearFields()
                    dismiss()
                }
            }
        } message: {
            Text(alertMessage)
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 40, height: 40)
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                    
                    Image(systemName: "arrow.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                }
            }
            
            Spacer()
            
            Text("Privacy Settings")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
            
            Spacer()
            
            // Balance the header
            Circle()
                .fill(Color.clear)
                .frame(width: 40, height: 40)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 5)
        .background(Color(.systemGroupedBackground))
    }
    
    private var passwordSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 35, height: 35)
                    
                    Image(systemName: "key.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.blue)
                }
                
                Text("Change Password")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
            }
            
            VStack(spacing: 16) {
                // Current Password Field
                ModernPasswordField(
                    title: "Current Password",
                    text: $currentPassword,
                    showPassword: $showCurrentPassword,
                    icon: "lock.fill",
                    iconColor: .orange
                )
                
                // New Password Field
                ModernPasswordField(
                    title: "New Password",
                    text: $newPassword,
                    showPassword: $showNewPassword,
                    icon: "key.fill",
                    iconColor: .green
                )
                
                // Confirm Password Field
                ModernPasswordField(
                    title: "Confirm New Password",
                    text: $confirmPassword,
                    showPassword: $showConfirmPassword,
                    icon: "checkmark.shield.fill",
                    iconColor: .blue
                )
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
    
    private var securityInfoCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.1))
                        .frame(width: 35, height: 35)
                    
                    Image(systemName: "shield.checkered")
                        .font(.system(size: 16))
                        .foregroundColor(.green)
                }
                
                Text("Security Guidelines")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 12) {
                SecurityRequirement(
                    icon: "textformat.123",
                    iconColor: .blue,
                    title: "At least 8 characters",
                    description: "Use a mix of letters and numbers",
                    isValid: newPassword.count >= 8
                )
                
                SecurityRequirement(
                    icon: "textformat.abc.dottedunderline",
                    iconColor: .purple,
                    title: "Include special characters",
                    description: "Use symbols like @, !, #, $, etc.",
                    isValid: containsSpecialCharacter(newPassword)
                )
                
                SecurityRequirement(
                    icon: "eye.slash.fill",
                    iconColor: .red,
                    title: "Keep it private",
                    description: "Don't share with others",
                    isValid: true
                )
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
    
    private var updateButton: some View {
        VStack {
            Button(action: {
                updatePassword()
            }) {
                HStack(spacing: 12) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 35, height: 35)
                            
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                        }
                    }
                    
                    Text(isLoading ? "Updating..." : "Update Password")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(16)
                .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 3)
            }
            .disabled(isLoading || !canUpdatePassword)
            .opacity(canUpdatePassword ? 1.0 : 0.6)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .padding(.top, 10)
        }
        .background(Color(.systemGroupedBackground))
    }
    
    private var canUpdatePassword: Bool {
        return !currentPassword.isEmpty && !newPassword.isEmpty && !confirmPassword.isEmpty
    }
    
    private func containsSpecialCharacter(_ password: String) -> Bool {
        let specialCharacterSet = CharacterSet(charactersIn: "@$!%*#?&")
        return password.rangeOfCharacter(from: specialCharacterSet) != nil
    }
    
    private func updatePassword() {
        guard validateFields() else { return }
        
        isLoading = true
        
        let requestData: [String: Any] = [
            "id": patientId,
            "email": patientEmail,
            "oldPassword": currentPassword,
            "newPassword": newPassword,
            "confirmPassword": confirmPassword
        ]
        
        // Make API call
        changePassword(requestData: requestData)
    }
    
    private func validateFields() -> Bool {
        // Check if user data is available
        if patientId.isEmpty || patientEmail.isEmpty {
            showError("User session expired. Please login again.")
            return false
        }
        
        // Check if all fields are filled
        if currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty {
            showError("All fields are required")
            return false
        }
        
        // Check if new passwords match
        if newPassword != confirmPassword {
            showError("New password and confirm password do not match")
            return false
        }
        
        // Check password strength (client-side validation)
        if !isValidPassword(newPassword) {
            showError("Password must be at least 8 characters long and include letters, numbers, and symbols")
            return false
        }
        
        // Check if new password is different from current
        if newPassword == currentPassword {
            showError("New password must be different from current password")
            return false
        }
        
        return true
    }
    
    private func changePassword(requestData: [String: Any]) {
        guard let url = URL(string: "https://mediaccess.vercel.app/api/patient/change-password") else {
            showError("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestData)
        } catch {
            showError("Failed to encode request data")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                
                if let error = error {
                    showError("Network error: \(error.localizedDescription)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    showError("Invalid response")
                    return
                }
                
                if let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                           let message = json["message"] as? String {
                            
                            if httpResponse.statusCode == 200 {
                                showSuccess(message)
                            } else {
                                showError(message)
                            }
                        } else {
                            showError("Invalid response format")
                        }
                    } catch {
                        showError("Failed to parse response")
                    }
                } else {
                    showError("No response data")
                }
            }
        }.resume()
    }
    
    private func showError(_ message: String) {
        alertMessage = message
        alertType = .error
        showAlert = true
    }
    
    private func showSuccess(_ message: String) {
        alertMessage = message
        alertType = .success
        showAlert = true
    }
    
    private func clearFields() {
        currentPassword = ""
        newPassword = ""
        confirmPassword = ""
        showCurrentPassword = false
        showNewPassword = false
        showConfirmPassword = false
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
}

struct ModernPasswordField: View {
    let title: String
    @Binding var text: String
    @Binding var showPassword: Bool
    let icon: String
    let iconColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.1))
                        .frame(width: 28, height: 28)
                    
                    Image(systemName: icon)
                        .font(.system(size: 12))
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
                
                Spacer()
            }
            
            HStack(spacing: 12) {
                Group {
                    if showPassword {
                        TextField(title, text: $text)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    } else {
                        SecureField(title, text: $text)
                    }
                }
                .font(.system(size: 16))
                .foregroundColor(.black)
                
                Button(action: {
                    showPassword.toggle()
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.gray.opacity(0.1))
                            .frame(width: 32, height: 32)
                        
                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

struct SecurityRequirement: View {
    let icon: String
    let iconColor: Color
    let title: String
    let description: String
    let isValid: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.1))
                    .frame(width: 35, height: 35)
                
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(iconColor)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.black)
                
                Text(description)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            ZStack {
                Circle()
                    .fill(isValid ? Color.green.opacity(0.1) : Color.gray.opacity(0.1))
                    .frame(width: 24, height: 24)
                
                Image(systemName: isValid ? "checkmark" : "minus")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(isValid ? .green : .gray)
            }
        }
        .padding(.vertical, 4)
    }
}
