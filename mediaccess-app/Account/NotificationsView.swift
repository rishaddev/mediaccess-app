import SwiftUI

struct NotificationsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var pushNotificationsEnabled = true
    @State private var emailNotificationsEnabled = false
    @State private var appointmentRemindersEnabled = true
    @State private var medicationRemindersEnabled = true
    @State private var pharmacyUpdatesEnabled = false
    
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
                
                Text("Notifications")
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
                VStack(alignment: .leading, spacing: 24) {
                    // Notification Settings Section
                    VStack(alignment: .leading, spacing: 16) {
                        
                        VStack(spacing: 0) {
                            NotificationToggleRow(
                                title: "Push Notifications",
                                subtitle: "Receive notifications on your device",
                                isEnabled: $pushNotificationsEnabled
                            )
                            
                            Divider()
                                .padding(.leading, 20)
                            
                            NotificationToggleRow(
                                title: "Email Notifications",
                                subtitle: "Receive notifications via email",
                                isEnabled: $emailNotificationsEnabled
                            )
                            
                            Divider()
                                .padding(.leading, 20)
                            
                            NotificationToggleRow(
                                title: "Appointment Reminders",
                                subtitle: "Get reminded about upcoming appointments",
                                isEnabled: $appointmentRemindersEnabled
                            )
                            
                            Divider()
                                .padding(.leading, 20)
                            
                            NotificationToggleRow(
                                title: "Medication Reminders",
                                subtitle: "Get reminded to take your medications",
                                isEnabled: $medicationRemindersEnabled
                            )
                            
                            Divider()
                                .padding(.leading, 20)
                            
                            NotificationToggleRow(
                                title: "Pharmacy Updates",
                                subtitle: "Get updates about your pharmacy orders",
                                isEnabled: $pharmacyUpdatesEnabled
                            )
                        }
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.horizontal, 0)
                        .padding(.top, 20)
                    }
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .background(Color.white)
    }
}

struct NotificationToggleRow: View {
    let title: String
    let subtitle: String
    @Binding var isEnabled: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
                
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Toggle("", isOn: $isEnabled)
                .toggleStyle(SwitchToggleStyle(tint: .blue))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}

#Preview {
    NotificationsView()
}
