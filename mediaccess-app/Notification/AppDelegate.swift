//
//  AppDelegate.swift
//  mediaccess-app
//
//  Created by Rishad 009 on 2025-09-15.
//

import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    let notificationDelegate = NotificationDelegate()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = notificationDelegate
        
        UNUserNotificationCenter.current().setBadgeCount(0) { _ in }
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UNUserNotificationCenter.current().setBadgeCount(0) { _ in }
    }
}
