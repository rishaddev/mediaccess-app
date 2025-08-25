import SwiftUI

struct PrivacySettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var showCurrentPassword = false
    @State private var showNewPassword = false
    @State private var showConfirmPassword = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Text("Privacy Settings")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .foregroundColor(.clear)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Change Password")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                            .padding(.top, 30)
                        
                        VStack(spacing: 16) {
                            HStack {
                                if showCurrentPassword {
                                    TextField("Current Password", text: $currentPassword)
                                        .font(.system(size: 16))
                                        .foregroundColor(.black)
                                } else {
                                    SecureField("Current Password", text: $currentPassword)
                                        .font(.system(size: 16))
                                        .foregroundColor(.black)
                                }
                                
                                Button(action: {
                                    showCurrentPassword.toggle()
                                }) {
                                    Image(systemName: showCurrentPassword ? "eye.slash" : "eye")
                                        .font(.system(size: 16))
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            
                            HStack {
                                if showNewPassword {
                                    TextField("New Password", text: $newPassword)
                                        .font(.system(size: 16))
                                        .foregroundColor(.black)
                                } else {
                                    SecureField("New Password", text: $newPassword)
                                        .font(.system(size: 16))
                                        .foregroundColor(.black)
                                }
                                
                                Button(action: {
                                    showNewPassword.toggle()
                                }) {
                                    Image(systemName: showNewPassword ? "eye.slash" : "eye")
                                        .font(.system(size: 16))
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            
                            // Confirm New Password Field
                            HStack {
                                if showConfirmPassword {
                                    TextField("Confirm New Password", text: $confirmPassword)
                                        .font(.system(size: 16))
                                        .foregroundColor(.black)
                                } else {
                                    SecureField("Confirm New Password", text: $confirmPassword)
                                        .font(.system(size: 16))
                                        .foregroundColor(.black)
                                }
                                
                                Button(action: {
                                    showConfirmPassword.toggle()
                                }) {
                                    Image(systemName: showConfirmPassword ? "eye.slash" : "eye")
                                        .font(.system(size: 16))
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        }
                        .padding(.horizontal, 20)
                        
                        // Password Requirements
                        Text("Password must be at least 8 characters long and include a mix of letters, numbers, and symbols.")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                    }
                    
                    Spacer(minLength: 100)
                }
            }
            
            // Update Password Button
            VStack {
                Button(action: {
                    // TODO: Implement password update functionality
                    updatePassword()
                }) {
                    Text("Update Password")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
        .background(Color.white)
    }
    
    private func updatePassword() {
        // TODO: Add validation logic
        guard !currentPassword.isEmpty,
              !newPassword.isEmpty,
              !confirmPassword.isEmpty else {
            // Show error: All fields are required
            return
        }
        
        guard newPassword == confirmPassword else {
            // Show error: Passwords don't match
            return
        }
        
        guard isValidPassword(newPassword) else {
            // Show error: Password doesn't meet requirements
            return
        }
        
        // TODO: API call to update password
        // updatePasswordAPI(current: currentPassword, new: newPassword)
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        // Password validation: at least 8 characters, mix of letters, numbers, and symbols
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
}
