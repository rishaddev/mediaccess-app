import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingNotifications = false
    @State private var showingPrivacySettings = false
    @State private var showingTerms = false
    @State private var showingLogoutAlert = false
    
    // Closure to handle logout action - needs to be passed from parent
    let onLogout: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Text("Settings")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                // Empty space to balance the header
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .foregroundColor(.clear)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            ScrollView {
                VStack(spacing: 24) {
                    // User Info Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Account")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 30)
                        
                        // Current User Info
                        VStack(spacing: 12) {
                            HStack(spacing: 16) {
                                // User Avatar
                                ZStack {
                                    Circle()
                                        .fill(Color.blue.opacity(0.1))
                                        .frame(width: 60, height: 60)
                                    
                                    Text(getUserInitials())
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.blue)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(getDisplayName())
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.black)
                                    
                                    Text(getUserEmail())
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                    
                                    Text("Logged in")
                                        .font(.system(size: 12))
                                        .foregroundColor(.green)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 2)
                                        .background(Color.green.opacity(0.1))
                                        .cornerRadius(4)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(Color.white)
                            .cornerRadius(12)
                        }
                    }
                    
                    // Preferences Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Preferences")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(spacing: 0) {
                            SettingsRow(
                                icon: "bell",
                                title: "Notifications",
                                subtitle: "Manage how you receive updates and reminders",
                                action: {
                                    showingNotifications = true
                                }
                            )
                            
                            Divider()
                                .padding(.leading, 70)
                            
                            SettingsRow(
                                icon: "shield",
                                title: "Privacy",
                                subtitle: "Control your privacy settings",
                                action: {
                                    showingPrivacySettings = true
                                }
                            )
                            
                            Divider()
                                .padding(.leading, 70)
                            
                            SettingsRow(
                                icon: "doc.text",
                                title: "Terms of Service",
                                subtitle: "",
                                action: {
                                    showingTerms = true
                                }
                            )
                        }
                        .background(Color.white)
                        .cornerRadius(12)
                    }
                    
                    Spacer(minLength: 200)
                }
            }
            
            // Log Out Button
            VStack {
                Button(action: {
                    showingLogoutAlert = true
                }) {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .font(.system(size: 16))
                        
                        Text("Log Out")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.red.opacity(0.3), lineWidth: 1)
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            }
        }
        .background(Color(.systemGroupedBackground))
        .fullScreenCover(isPresented: $showingNotifications) {
            NotificationsView()
        }
        .fullScreenCover(isPresented: $showingPrivacySettings) {
            PrivacySettingsView()
        }
        .fullScreenCover(isPresented: $showingTerms) {
            TermsOfServiceView()
        }
        .alert("Log Out", isPresented: $showingLogoutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Log Out", role: .destructive) {
                performLogout()
            }
        } message: {
            Text("Are you sure you want to log out?")
        }
    }
    
    // MARK: - Helper Functions
    
    private func getUserEmail() -> String {
        return UserDefaults.standard.string(forKey: "userEmail") ?? "user@email.com"
    }
    
    private func getDisplayName() -> String {
        let email = getUserEmail()
        if email.contains("@") {
            let username = String(email.split(separator: "@").first ?? "User")
            return username.replacingOccurrences(of: ".", with: " ")
                          .replacingOccurrences(of: "_", with: " ")
                          .capitalized
        }
        return email.capitalized
    }
    
    private func getUserInitials() -> String {
        let name = getDisplayName()
        let components = name.components(separatedBy: " ")
        let initials = components.compactMap { $0.first }.map { String($0) }
        return initials.prefix(2).joined().uppercased()
    }
    
    private func performLogout() {
        // Clear all user data from UserDefaults
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        
        // Clear any other user-related data you might have stored
        // UserDefaults.standard.removeObject(forKey: "userToken")
        // UserDefaults.standard.removeObject(forKey: "userProfile")
        
        // Dismiss this view and trigger logout in parent
        dismiss()
        
        // Call the logout closure passed from parent
        onLogout()
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                }
                
                // Content
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                    
                    if !subtitle.isEmpty {
                        Text(subtitle)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.leading)
                    }
                }
                
                Spacer()
                
                // Arrow
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(onLogout: {})
    }
}
