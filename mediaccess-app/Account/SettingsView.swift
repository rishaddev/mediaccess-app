import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingNotifications = false
    @State private var showingPrivacySettings = false
    @State private var showingTerms = false
    
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
                    // Preferences Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Preferences")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 30)
                        
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
                    // TODO: Implement logout functionality
                }) {
                    Text("Log Out")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                
                // Bottom Navigation
                //                HStack {
                //                    BottomNavItem(icon: "house", title: "Home", isSelected: false)
                //                    BottomNavItem(icon: "calendar", title: "Appointments", isSelected: false)
                //                    BottomNavItem(icon: "cross.case", title: "Pharmacy", isSelected: false)
                //                    BottomNavItem(icon: "person.2", title: "Family", isSelected: false)
                //                }
                //                .padding(.horizontal, 20)
                //                .padding(.vertical, 12)
                //                .background(Color.white)
                //                .overlay(
                //                    Rectangle()
                //                        .frame(height: 1)
                //                        .foregroundColor(Color.gray.opacity(0.2)),
                //                    alignment: .top
                //                )
            }
        }
        .background(Color.white)
        .fullScreenCover(isPresented: $showingNotifications) {
            NotificationsView()
        }
        .fullScreenCover(isPresented: $showingPrivacySettings) {
            PrivacySettingsView()
        }
        .fullScreenCover(isPresented: $showingTerms) {
            TermsOfServiceView()
        }
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

//struct BottomNavItem: View {
//    let icon: String
//    let title: String
//    let isSelected: Bool
//
//    var body: some View {
//        VStack(spacing: 4) {
//            Image(systemName: icon)
//                .font(.system(size: 20))
//                .foregroundColor(isSelected ? .blue : .gray)
//
//            Text(title)
//                .font(.system(size: 12))
//                .foregroundColor(isSelected ? .blue : .gray)
//        }
//        .frame(maxWidth: .infinity)
//    }
//}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
