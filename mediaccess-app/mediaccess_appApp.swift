import SwiftUI

@main
struct mediaccess_appApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
                    ContentView()
                        .onAppear {
                            UNUserNotificationCenter.current().delegate = appDelegate.notificationDelegate
                        }
                }
    }
}
