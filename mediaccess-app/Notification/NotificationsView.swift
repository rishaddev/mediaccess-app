import SwiftUI
import UserNotifications

struct NotificationsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var pendingNotifications: [UNNotificationRequest] = []
    @State private var deliveredNotifications: [UNNotification] = []
    @State private var isLoading = true
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showClearConfirmation = false
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            
            if isLoading {
                loadingView
            } else {
                notificationsList
            }
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color(.systemGroupedBackground), Color.white.opacity(0.9)]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .onAppear {
            fetchNotifications()
        }
        .alert("Clear All Notifications", isPresented: $showClearConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Clear All", role: .destructive) {
                clearAllNotifications()
            }
        } message: {
            Text("This will clear all pending and delivered notifications. This action cannot be undone.")
        }
        .alert("Error", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
        .accessibilityLabel("Notifications screen")
    }
    
    private var headerView: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 40, height: 40)
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                }
                .accessibilityLabel("Close notifications")
                
                Spacer()
                
                VStack(spacing: 2) {
                    Text("Notifications")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                    
                    if !isLoading {
                        let totalCount = pendingNotifications.count + deliveredNotifications.count
                        Text("\(totalCount) notification\(totalCount == 1 ? "" : "s")")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                if !pendingNotifications.isEmpty || !deliveredNotifications.isEmpty {
                    Button(action: {
                        showClearConfirmation = true
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.red.opacity(0.1))
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "trash")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.red)
                        }
                    }
                    .accessibilityLabel("Clear all notifications")
                } else {
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 40, height: 40)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 20)
            
            if !isLoading && (!pendingNotifications.isEmpty || !deliveredNotifications.isEmpty) {
                notificationSummaryBar
            }
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color(.systemGroupedBackground)]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    
    private var notificationSummaryBar: some View {
        HStack(spacing: 16) {
            if !pendingNotifications.isEmpty {
                VStack(spacing: 2) {
                    Text("\(pendingNotifications.count)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.orange)
                    Text("Upcoming")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.orange)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(12)
            }
            
            if !deliveredNotifications.isEmpty {
                VStack(spacing: 2) {
                    Text("\(deliveredNotifications.count)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.green)
                    Text("Recent")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.green)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.green.opacity(0.1))
                .cornerRadius(12)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
    
    private var loadingView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .stroke(Color.blue.opacity(0.2), lineWidth: 8)
                    .frame(width: 80, height: 80)
                
                Circle()
                    .trim(from: 0, to: 0.3)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(-90))
                    .animation(
                        Animation.linear(duration: 1.5).repeatForever(autoreverses: false),
                        value: isLoading
                    )
            }
            
            VStack(spacing: 8) {
                Text("Loading notifications...")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.black)
                
                Text("Please wait while we gather your reminders")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            
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
                    LazyVStack(spacing: 20) {
                        if !pendingNotifications.isEmpty {
                            upcomingNotificationsSection
                        }
                        
                        if !deliveredNotifications.isEmpty {
                            recentNotificationsSection
                        }
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
            }
        }
    }
    
    private var emptyNotificationsView: some View {
        VStack(spacing: 32) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Image(systemName: "bell.badge.fill")
                    .font(.system(size: 48, weight: .light))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            VStack(spacing: 16) {
                Text("All Caught Up!")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.black)
                
                Text("You have no pending reminders or recent notifications. We'll notify you when there's something important.")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("No notifications available")
        .accessibilityValue("You're all caught up")
    }
    
    private var upcomingNotificationsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.orange)
                    
                    Text("Upcoming Reminders")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Text("\(pendingNotifications.count)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.orange)
                    .cornerRadius(8)
            }
            .padding(.horizontal, 4)
            .accessibilityAddTraits(.isHeader)
            
            ForEach(Array(pendingNotifications.enumerated()), id: \.element.identifier) { index, notification in
                NotificationCard(
                    notification: notification,
                    isPending: true,
                    onCancel: {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            cancelNotification(notification)
                        }
                    }
                )
                .accessibilityLabel("Upcoming reminder \(index + 1)")
            }
        }
    }
    
    private var recentNotificationsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.green)
                    
                    Text("Recent Notifications")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Text("\(deliveredNotifications.count)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green)
                    .cornerRadius(8)
            }
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
            withAnimation(.easeOut(duration: 0.5)) {
                self.isLoading = false
            }
            
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
        
        withAnimation(.easeOut(duration: 0.5)) {
            pendingNotifications.removeAll()
            deliveredNotifications.removeAll()
        }
        
        // Announce to VoiceOver users
        UIAccessibility.post(notification: .announcement, argument: "All notifications cleared")
    }
}

struct NotificationCard: View {
    let notification: UNNotificationRequest?
    let deliveredNotification: UNNotification?
    let isPending: Bool
    var onCancel: (() -> Void)?
    @State private var isPressed = false
    
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
    
    private var notificationColors: [Color] {
        if content.userInfo["type"] as? String == "appointment_reminder" {
            return [Color.blue, Color.indigo]
        }
        return [Color.orange, Color.red]
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Enhanced Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: notificationColors.map { $0.opacity(0.15) }),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: notificationColors.map { $0.opacity(0.3) }),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                
                Image(systemName: notificationIcon)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: notificationColors),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .accessibilityHidden(true)
            
            // Content
            VStack(alignment: .leading, spacing: 6) {
                Text(content.title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.black)
                    .lineLimit(2)
                
                Text(content.body)
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
                
                if let date = scheduledDate {
                    HStack(spacing: 6) {
                        Image(systemName: isPending ? "clock.fill" : "checkmark.circle.fill")
                            .font(.system(size: 11))
                            .foregroundColor(isPending ? .orange : .green)
                        
                        Text(isPending ? "Scheduled for \(formatDate(date))" : "Delivered \(formatDate(date))")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(isPending ? .orange : .green)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background((isPending ? Color.orange : Color.green).opacity(0.1))
                    .cornerRadius(20)
                }
            }
            
            Spacer()
            
            // Enhanced Action button for pending notifications
            if isPending, let onCancel = onCancel {
                Button(action: onCancel) {
                    ZStack {
                        Circle()
                            .fill(Color.red.opacity(0.1))
                            .frame(width: 36, height: 36)
                            .overlay(
                                Circle()
                                    .stroke(Color.red.opacity(0.2), lineWidth: 1)
                            )
                        
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.red)
                    }
                }
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: isPressed)
                .accessibilityLabel("Cancel notification")
                .accessibilityHint("Double tap to cancel this reminder")
                .accessibilityAddTraits(.isButton)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(
                    color: Color.black.opacity(0.08),
                    radius: 8,
                    x: 0,
                    y: 4
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.white, Color.gray.opacity(0.1)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
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
