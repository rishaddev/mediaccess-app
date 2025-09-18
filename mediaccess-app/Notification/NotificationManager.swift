import UIKit
import Foundation
import UserNotifications

class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    
    // Key for storing notification preference
    private let notificationsEnabledKey = "pushNotificationsEnabled"
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Check if notifications are enabled when about to present
        if isNotificationEnabled {
            completionHandler([.banner, .sound, .badge])
        } else {
            // Don't show notification if disabled by user preference
            print("Notification blocked - user has disabled notifications")
            completionHandler([])
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    var isNotificationEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: notificationsEnabledKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: notificationsEnabledKey)
        }
    }
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    print("Notification permission granted")
                } else if let error = error {
                    print("Notification permission denied: \(error.localizedDescription)")
                    self.isNotificationEnabled = false
                }
            }
        }
    }
    
    func scheduleAppointmentReminder(
        patientName: String,
        doctorName: String,
        specialty: String,
        appointmentDate: String,
        appointmentTime: String,
        completion: @escaping (Bool) -> Void
    ) {
        guard let appointmentDateTime = parseDateTime(date: appointmentDate, time: appointmentTime) else {
            print("Failed to parse appointment date/time")
            completion(false)
            return
        }
        
        scheduleReminders(
            appointmentDateTime: appointmentDateTime,
            patientName: patientName,
            doctorName: doctorName,
            specialty: specialty,
            completion: completion
        )
    }
    
    private func scheduleReminders(
        appointmentDateTime: Date,
        patientName: String,
        doctorName: String,
        specialty: String,
        completion: @escaping (Bool) -> Void
    ) {
        let calendar = Calendar.current
        let now = Date()
        
        let reminderTimes: [(minutes: Int, title: String)] = [
            (1440, "Tomorrow"),
            (60, "1 Hour"),
            (15, "15 Minutes")
        ]
        
        var scheduledCount = 0
        var totalReminders = 0
        
        for reminder in reminderTimes {
            let reminderDate = calendar.date(byAdding: .minute, value: -reminder.minutes, to: appointmentDateTime)
            
            guard let reminderDate = reminderDate, reminderDate > now else {
                continue
            }
            
            totalReminders += 1
            
            let content = UNMutableNotificationContent()
            content.title = "Appointment Reminder"
            content.body = createReminderMessage(
                patientName: patientName,
                doctorName: doctorName,
                specialty: specialty,
                reminderType: reminder.title
            )
            content.sound = .default
            content.badge = 1
            
            content.userInfo = [
                "type": "appointment_reminder",
                "patientName": patientName,
                "doctorName": doctorName,
                "specialty": specialty,
                "appointmentDate": appointmentDateTime.timeIntervalSince1970
            ]
            
            let triggerDate = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            
            let identifier = "appointment_\(patientName)_\(reminder.minutes)min_\(Int(appointmentDateTime.timeIntervalSince1970))"
            
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                DispatchQueue.main.async {
                    if error == nil {
                        scheduledCount += 1
                        print("Scheduled \(reminder.title) reminder for \(patientName)")
                    } else {
                        print("Failed to schedule \(reminder.title) reminder: \(error?.localizedDescription ?? "Unknown error")")
                    }
                    
                    if scheduledCount + (totalReminders - scheduledCount) == totalReminders {
                        completion(scheduledCount > 0)
                    }
                }
            }
        }
        
        if totalReminders == 0 {
            completion(false)
        }
    }
    
    private func createReminderMessage(
        patientName: String,
        doctorName: String,
        specialty: String,
        reminderType: String
    ) -> String {
        switch reminderType {
        case "Tomorrow":
            return "Don't forget! \(patientName) has an appointment with Dr. \(doctorName) (\(specialty)) tomorrow."
        case "1 Hour":
            return "Appointment in 1 hour! \(patientName) - Dr. \(doctorName) (\(specialty))"
        case "15 Minutes":
            return "Appointment starting soon! \(patientName) - Dr. \(doctorName) (\(specialty)) in 15 minutes."
        default:
            return "Appointment reminder for \(patientName) with Dr. \(doctorName) (\(specialty))"
        }
    }
    
    private func parseDateTime(date: String, time: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = TimeZone.current
        
        let dateTimeString = "\(date) \(time)"
        return formatter.date(from: dateTimeString)
    }
    
    func cancelAppointmentNotifications(patientName: String, appointmentDateTime: Date) {
        let appointmentTimestamp = Int(appointmentDateTime.timeIntervalSince1970)
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let identifiersToCancel = requests.compactMap { request -> String? in
                if request.identifier.contains("appointment_\(patientName)") &&
                   request.identifier.contains("\(appointmentTimestamp)") {
                    return request.identifier
                }
                return nil
            }
            
            if !identifiersToCancel.isEmpty {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiersToCancel)
                print("Cancelled \(identifiersToCancel.count) notifications for \(patientName)")
            }
        }
    }
    
    func getPendingNotifications(completion: @escaping ([UNNotificationRequest]) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            DispatchQueue.main.async {
                completion(requests)
            }
        }
    }
    
    func clearAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().setBadgeCount(0) { _ in }
    }
}
