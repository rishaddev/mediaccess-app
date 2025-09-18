import Foundation
import UserNotifications
import Combine

class NotificationBadgeManager: ObservableObject {
    static let shared = NotificationBadgeManager()
    
    @Published var notificationCount: Int = 0
    
    private init() {}
    
    // This function gets the total number of notifications
    func fetchNotificationCount() {
        let group = DispatchGroup()
        var pendingCount = 0
        var deliveredCount = 0
        
        // Fetch pending notifications
        group.enter()
        NotificationManager.shared.getPendingNotifications { notifications in
            DispatchQueue.main.async {
                pendingCount = notifications.count
                group.leave()
            }
        }
        
        // Fetch delivered notifications
        group.enter()
        UNUserNotificationCenter.current().getDeliveredNotifications { notifications in
            DispatchQueue.main.async {
                deliveredCount = notifications.count
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.notificationCount = pendingCount + deliveredCount
        }
    }
    
    // This function updates the notification count
    func refreshBadgeCount() {
        fetchNotificationCount()
    }
    
    // This function removes all notification count
    func clearBadgeCount() {
        DispatchQueue.main.async {
            self.notificationCount = 0
        }
    }
}
