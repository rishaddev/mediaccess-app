import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingNotifications = false
    @State private var showingPrivacySettings = false
    @State private var showingTerms = false
    @State private var showingLogoutAlert = false
    
    let onLogout: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            
            ScrollView {
                VStack(spacing: 24) {
                    accountSection
                    preferencesSection
                    Spacer(minLength: 120)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            
            logoutButton
        }
        .background(Color(.systemGroupedBackground))
        .fullScreenCover(isPresented: $showingNotifications) {
            NotificationsSettingsView()
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
            
            Text("Settings")
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
    
    private var accountSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 35, height: 35)
                    
                    Image(systemName: "person.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.blue)
                }
                
                Text("Account")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
            }
            
            // User Info Card
            HStack(spacing: 16) {
                // User Avatar with gradient
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.blue.opacity(0.6)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 60, height: 60)
                        .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    
                    Text(getUserInitials())
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(getDisplayName())
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text(getUserEmail())
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 8, height: 8)
                        
                        Text("Online")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.green)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(12)
                }
                
                Spacer()
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
        }
    }
    
    private var preferencesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.purple.opacity(0.1))
                        .frame(width: 35, height: 35)
                    
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 16))
                        .foregroundColor(.purple)
                }
                
                Text("Preferences")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
            }
            
            VStack(spacing: 0) {
                ModernSettingsRow(
                    icon: "bell.fill",
                    iconColor: .orange,
                    title: "Notifications",
                    subtitle: "Manage how you receive updates and reminders",
                    action: {
                        showingNotifications = true
                    }
                )
                
                Divider()
                    .padding(.leading, 70)
                
                ModernSettingsRow(
                    icon: "shield.fill",
                    iconColor: .blue,
                    title: "Privacy",
                    subtitle: "Control your privacy settings",
                    action: {
                        showingPrivacySettings = true
                    }
                )
                
                Divider()
                    .padding(.leading, 70)
                
                ModernSettingsRow(
                    icon: "doc.text.fill",
                    iconColor: .green,
                    title: "Terms of Service",
                    subtitle: "Review our terms and conditions",
                    action: {
                        showingTerms = true
                    }
                )
            }
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
        }
    }
    
    private var logoutButton: some View {
        VStack {
            Button(action: {
                showingLogoutAlert = true
            }) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.red.opacity(0.1))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.red)
                    }
                    
                    Text("Log Out")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.red)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color.white)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.red.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: .red.opacity(0.1), radius: 3, x: 0, y: 2)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .padding(.top, 10)
        }
        .background(Color(.systemGroupedBackground))
    }
    
    private func getUserEmail() -> String {
        return UserDefaults.standard.string(forKey: "email") ?? "user@email.com"
    }
    
    private func getDisplayName() -> String {
        return UserDefaults.standard.string(forKey: "name") ?? "user"
    }
    
    private func getUserInitials() -> String {
        let name = getDisplayName()
        let components = name.components(separatedBy: " ")
        let initials = components.compactMap { $0.first }.map { String($0) }
        return initials.prefix(2).joined().uppercased()
    }
    
    private func performLogout() {
        // Clear all user data from UserDefaults
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        dismiss()
        
        onLogout()
    }
}

struct ModernSettingsRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Modern Icon with gradient background
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.1))
                        .frame(width: 45, height: 45)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(iconColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                    
                    if !subtitle.isEmpty {
                        Text(subtitle)
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.leading)
                    }
                }
                
                Spacer()
                
                // Modern arrow with background
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: 30, height: 30)
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(onLogout: {})
    }
}
