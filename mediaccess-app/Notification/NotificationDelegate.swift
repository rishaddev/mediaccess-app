//
//  NotificationDelegate.swift
//  mediaccess-app
//
//  Created by Rishad 009 on 2025-09-15.
//

import UIKit
import UserNotifications

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.banner, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        if let notificationType = userInfo["type"] as? String,
           notificationType == "appointment_reminder" {
            
            let patientName = userInfo["patientName"] as? String ?? ""
            let doctorName = userInfo["doctorName"] as? String ?? ""
            let specialty = userInfo["specialty"] as? String ?? ""
            
            print("User tapped appointment reminder for \(patientName)")
            handleAppointmentNotificationTap(
                patientName: patientName,
                doctorName: doctorName,
                specialty: specialty
            )
        }
        
        completionHandler()
    }
    
    private func handleAppointmentNotificationTap(patientName: String, doctorName: String, specialty: String) {
        NotificationCenter.default.post(
            name: Notification.Name("AppointmentReminderTapped"),
            object: nil,
            userInfo: [
                "patientName": patientName,
                "doctorName": doctorName,
                "specialty": specialty
            ]
        )
    }
}
