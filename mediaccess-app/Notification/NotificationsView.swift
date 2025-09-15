import SwiftUI
import UserNotifications

struct NotificationsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var pendingNotifications: [UNNotificationRequest] = []
    @State private var deliveredNotifications: [UNNotification] = []
    @State private var isLoading = true
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if isLoading {
                    loadingView
                } else {
                    notificationsList
                }
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear All") {
                        clearAllNotifications()
                    }
                    .disabled(pendingNotifications.isEmpty && deliveredNotifications.isEmpty)
                }
            }
            .onAppear {
                fetchNotifications()
            }
            .alert("Error", isPresented: $showAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
        .accessibilityLabel("Notifications screen")
    }
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            Spacer()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .scaleEffect(1.5)
            
            Text("Loading notifications...")
                .font(.system(size: 16))
                .foregroundColor(.gray)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Loading notifications")
    }
    
    private var notificationsList: some View {
        Group {
            if pendingNotifications.isEmpty && deliveredNotifications.isEmpty {
                emptyNotificationsView
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        if !pendingNotifications.isEmpty {
                            upcomingNotificationsSection
                        }
                        
                        if !deliveredNotifications.isEmpty {
                            recentNotificationsSection
                        }
                        
                        Spacer(minLength: 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
            }
        }
    }
    
    private var emptyNotificationsView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "bell.slash")
                    .font(.system(size: 36))
                    .foregroundColor(.gray)
            }
            
            Text("No Notifications")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.black)
            
            Text("You're all caught up! No notifications to display.")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("No notifications available")
        .accessibilityValue("You're all caught up")
    }
    
    private var upcomingNotificationsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Upcoming Reminders")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
                .padding(.horizontal, 4)
                .accessibilityAddTraits(.isHeader)
            
            ForEach(Array(pendingNotifications.enumerated()), id: \.element.identifier) { index, notification in
                NotificationCard(
                    notification: notification,
                    isPending: true,
                    onCancel: {
                        cancelNotification(notification)
                    }
                )
                .accessibilityLabel("Upcoming reminder \(index + 1)")
            }
        }
    }
    
    private var recentNotificationsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Notifications")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
                .padding(.horizontal, 4)
                .accessibilityAddTraits(.isHeader)
            
            ForEach(Array(deliveredNotifications.enumerated()), id: \.element.request.identifier) { index, notification in
                NotificationCard(
                    deliveredNotification: notification,
                    isPending: false
                )
                .accessibilityLabel("Recent notification \(index + 1)")
            }
        }
    }
    
    private func fetchNotifications() {
        isLoading = true
        
        let group = DispatchGroup()
        
        // Fetch pending notifications
        group.enter()
        NotificationManager.shared.getPendingNotifications { notifications in
            DispatchQueue.main.async {
                self.pendingNotifications = notifications.sorted { notification1, notification2 in
                    guard let trigger1 = notification1.trigger as? UNCalendarNotificationTrigger,
                          let trigger2 = notification2.trigger as? UNCalendarNotificationTrigger,
                          let date1 = Calendar.current.date(from: trigger1.dateComponents),
                          let date2 = Calendar.current.date(from: trigger2.dateComponents) else {
                        return false
                    }
                    return date1 < date2
                }
                group.leave()
            }
        }
        
        // Fetch delivered notifications
        group.enter()
        UNUserNotificationCenter.current().getDeliveredNotifications { notifications in
            DispatchQueue.main.async {
                self.deliveredNotifications = notifications.sorted { $0.date > $1.date }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.isLoading = false
            
            // Announce to VoiceOver users
            let totalCount = self.pendingNotifications.count + self.deliveredNotifications.count
            if totalCount > 0 {
                UIAccessibility.post(notification: .announcement,
                                   argument: "\(totalCount) notifications loaded")
            }
        }
    }
    
    private func cancelNotification(_ notification: UNNotificationRequest) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notification.identifier])
        
        // Remove from local array
        pendingNotifications.removeAll { $0.identifier == notification.identifier }
        
        // Announce cancellation to VoiceOver users
        UIAccessibility.post(notification: .announcement, argument: "Notification cancelled")
    }
    
    private func clearAllNotifications() {
        NotificationManager.shared.clearAllNotifications()
        pendingNotifications.removeAll()
        deliveredNotifications.removeAll()
        
        // Announce to VoiceOver users
        UIAccessibility.post(notification: .announcement, argument: "All notifications cleared")
    }
}

struct NotificationCard: View {
    let notification: UNNotificationRequest?
    let deliveredNotification: UNNotification?
    let isPending: Bool
    var onCancel: (() -> Void)?
    
    init(notification: UNNotificationRequest, isPending: Bool, onCancel: @escaping () -> Void) {
        self.notification = notification
        self.deliveredNotification = nil
        self.isPending = isPending
        self.onCancel = onCancel
    }
    
    init(deliveredNotification: UNNotification, isPending: Bool) {
        self.notification = nil
        self.deliveredNotification = deliveredNotification
        self.isPending = isPending
        self.onCancel = nil
    }
    
    private var content: UNNotificationContent {
        return notification?.content ?? deliveredNotification?.request.content ?? UNMutableNotificationContent()
    }
    
    private var scheduledDate: Date? {
        if let notification = notification,
           let trigger = notification.trigger as? UNCalendarNotificationTrigger {
            return Calendar.current.date(from: trigger.dateComponents)
        } else if let deliveredNotification = deliveredNotification {
            return deliveredNotification.date
        }
        return nil
    }
    
    private var notificationIcon: String {
        if content.userInfo["type"] as? String == "appointment_reminder" {
            return "stethoscope"
        }
        return "bell.fill"
    }
    
    private var notificationColor: Color {
        if content.userInfo["type"] as? String == "appointment_reminder" {
            return .blue
        }
        return .orange
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(notificationColor.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: notificationIcon)
                    .font(.system(size: 20))
                    .foregroundColor(notificationColor)
            }
            .accessibilityHidden(true)
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(content.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                
                Text(content.body)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(3)
                
                if let date = scheduledDate {
                    HStack {
                        Image(systemName: isPending ? "clock" : "checkmark.circle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(isPending ? .orange : .green)
                        
                        Text(isPending ? "Scheduled for \(formatDate(date))" : "Delivered \(formatDate(date))")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
            }
            
            Spacer()
            
            // Action button for pending notifications
            if isPending, let onCancel = onCancel {
                Button(action: onCancel) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.gray.opacity(0.6))
                }
                .accessibilityLabel("Cancel notification")
                .accessibilityHint("Double tap to cancel this reminder")
                .accessibilityAddTraits(.isButton)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(content.title). \(content.body)")
        .accessibilityValue(scheduledDate != nil ? (isPending ? "Scheduled for \(formatDate(scheduledDate!))" : "Delivered \(formatDate(scheduledDate!))") : "")
        .accessibilityAddTraits(isPending ? [] : .isStaticText)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        
        if Calendar.current.isDateInToday(date) {
            formatter.dateFormat = "h:mm a"
            return "today at \(formatter.string(from: date))"
        } else if Calendar.current.isDateInTomorrow(date) {
            formatter.dateFormat = "h:mm a"
            return "tomorrow at \(formatter.string(from: date))"
        } else if Calendar.current.isDate(date, equalTo: Date(), toGranularity: .weekOfYear) {
            formatter.dateFormat = "EEEE 'at' h:mm a"
            return formatter.string(from: date)
        } else {
            formatter.dateFormat = "MMM d 'at' h:mm a"
            return formatter.string(from: date)
        }
    }
}
