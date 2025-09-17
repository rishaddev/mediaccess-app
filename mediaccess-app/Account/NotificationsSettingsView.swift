import SwiftUI
import UserNotifications

struct NotificationsSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var pushNotificationsEnabled = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            
            ScrollView {
                VStack(spacing: 24) {
                    notificationSection
                    informationSection
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .background(Color(.systemGroupedBackground))
        .onAppear {
            loadNotificationSettings()
        }
        .alert("Notification Settings", isPresented: $showAlert) {
            Button("OK") { }
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
            .accessibilityLabel("Back")
            .accessibilityHint("Return to settings")
            
            Spacer()
            
            Text("Notifications")
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
    
    private var notificationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.orange.opacity(0.1))
                        .frame(width: 35, height: 35)
                    
                    Image(systemName: "bell.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.orange)
                }
                
                Text("Push Notifications")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
            }
            
            // Main notification toggle card
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [Color.orange.opacity(0.8), Color.orange.opacity(0.6)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 60, height: 60)
                        .shadow(color: .orange.opacity(0.3), radius: 8, x: 0, y: 4)
                    
                    Image(systemName: pushNotificationsEnabled ? "bell.fill" : "bell.slash.fill")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Push Notifications")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text(pushNotificationsEnabled ? "You'll receive all notifications" : "All notifications are disabled")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 6) {
                        Circle()
                            .fill(pushNotificationsEnabled ? Color.green : Color.red)
                            .frame(width: 8, height: 8)
                        
                        Text(pushNotificationsEnabled ? "Enabled" : "Disabled")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(pushNotificationsEnabled ? .green : .red)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background((pushNotificationsEnabled ? Color.green : Color.red).opacity(0.1))
                    .cornerRadius(12)
                }
                
                Toggle("", isOn: $pushNotificationsEnabled)
                    .toggleStyle(SwitchToggleStyle(tint: .orange))
                    .onChange(of: pushNotificationsEnabled) { oldValue, newValue in
                        handleNotificationToggle(newValue)
                    }
                    .accessibilityLabel("Push notifications toggle")
                    .accessibilityHint(pushNotificationsEnabled ? "Currently enabled, toggle to disable all notifications" : "Currently disabled, toggle to enable all notifications")
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
            .accessibilityElement(children: .contain)
        }
    }
    
    private var informationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 35, height: 35)
                    
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.blue)
                }
                
                Text("What You'll Receive")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
            }
            
            VStack(spacing: 0) {
                NotificationInfoRow(
                    icon: "stethoscope",
                    iconColor: .blue,
                    title: "Appointment Reminders",
                    description: "Notifications 1 day, 1 hour, and 15 minutes before your appointments"
                )
                
                Divider()
                    .padding(.leading, 70)
                
                NotificationInfoRow(
                    icon: "pills.fill",
                    iconColor: .green,
                    title: "Pharmacy Updates",
                    description: "Order confirmations, processing updates, and ready for pickup notifications"
                )
                
                Divider()
                    .padding(.leading, 70)
                
                NotificationInfoRow(
                    icon: "house.fill",
                    iconColor: .purple,
                    title: "Home Visit Updates",
                    description: "Confirmations and status updates for home visit appointments"
                )
            }
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
            .opacity(pushNotificationsEnabled ? 1.0 : 0.5)
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Notification types information")
            .accessibilityHint(pushNotificationsEnabled ? "These are the types of notifications you will receive" : "These are the types of notifications that are currently disabled")
        }
    }
    
    private func loadNotificationSettings() {
        // Load the user preference first
        pushNotificationsEnabled = NotificationManager.shared.isNotificationEnabled
        
        // Also check system permission status to keep UI in sync
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                // If system permission is denied, disable the toggle
                if settings.authorizationStatus == .denied {
                    pushNotificationsEnabled = false
                    NotificationManager.shared.isNotificationEnabled = false
                }
            }
        }
    }
    
    private func handleNotificationToggle(_ isEnabled: Bool) {
        // Update the preference immediately
        NotificationManager.shared.isNotificationEnabled = isEnabled
        
        if isEnabled {
            // Request notification permission
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                DispatchQueue.main.async {
                    if granted {
                        NotificationManager.shared.isNotificationEnabled = true
                        pushNotificationsEnabled = true
                        alertMessage = "Push notifications enabled! You'll receive appointment reminders and order updates."
                        showAlert = true
                        
                        // Announce to VoiceOver users
                        UIAccessibility.post(notification: .announcement, argument: "Push notifications enabled")
                    } else {
                        NotificationManager.shared.isNotificationEnabled = false
                        pushNotificationsEnabled = false
                        alertMessage = "Notifications are disabled in Settings. Please go to Settings > Notifications > MediaAccess to enable them."
                        showAlert = true
                    }
                }
            }
        } else {
            // Disable notifications by clearing all scheduled ones and updating preference
            NotificationManager.shared.clearAllNotifications()
            NotificationManager.shared.isNotificationEnabled = false
            
            alertMessage = "All notifications have been disabled and cleared."
            showAlert = true
            
            // Announce to VoiceOver users
            UIAccessibility.post(notification: .announcement, argument: "Push notifications disabled")
        }
    }
}

struct NotificationInfoRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.1))
                    .frame(width: 45, height: 45)
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(iconColor)
            }
            .accessibilityHidden(true)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                
                Text(description)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(description)")
    }
}

struct NotificationsSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsSettingsView()
    }
}
