//
//  AppDelegate.swift
//  nafidhalbasayra
//
//  Created by muhammad on 23/03/2025.
//


import Foundation
import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // تعيين هذا الكلاس كمندوب للإشعارات
        UNUserNotificationCenter.current().delegate = self
        
        // طلب إذن الإشعارات من المستخدم
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if error != nil {
              //  print("❌ خطأ في طلب إذن الإشعارات: \(error.localizedDescription)")
            } else if granted {
               // print("✅ تم منح إذن الإشعارات")
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            } else {
              //  print("⚠️ تم رفض إذن الإشعارات، لكن سيتم تسجيل الجهاز في APNs")
            }
        }
        
        return true
    }
    
    // تم تسجيل الجهاز بنجاح مع APNs
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        
        // تخزين التوكن في UserDefaults لاستخدامه لاحقًا
        UserDefaults.standard.set(tokenString, forKey: "deviceToken")
        
        // طباعة التوكن بصيغة سهلة للنسخ
       // print("🔹 APNs Token:\n\(tokenString)")
    }
    
    // حدث خطأ أثناء التسجيل في APNs
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
       // print("❌ فشل تسجيل الجهاز مع APNs: \(error.localizedDescription)")
    }

    // استقبال الإشعارات أثناء تشغيل التطبيق بناءً على `loginState`
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let loginState = UserDefaults.standard.integer(forKey: "loginState")

        if loginState == 1 || loginState == 2 {
            completionHandler([.banner, .sound, .badge])
        } else {
            completionHandler([]) // منع الإشعار
        }
    }
    
    // التعامل مع الإشعار عند فتح التطبيق
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        _ = response.notification.request.content.userInfo
       // print("📩 تم فتح الإشعار: \(userInfo)")
        completionHandler()
    }
    
    // وظيفة لإلغاء تسجيل الجهاز من APNs
    func unregisterFromPushNotifications() {
        // إزالة التوكن من UserDefaults
        UserDefaults.standard.removeObject(forKey: "deviceToken")
        
        // إلغاء التسجيل من APNs
        UIApplication.shared.unregisterForRemoteNotifications()
        
      //  print("❌ تم إلغاء التسجيل من الإشعارات")
    }
    
    // أضف هذه الدالة لتقييد الاتجاهات ↓
      func application(
          _ application: UIApplication,
          supportedInterfaceOrientationsFor window: UIWindow?
      ) -> UIInterfaceOrientationMask {
          return .portrait // التطبيق يعمل بالوضع العمودي فقط
      }
    
    
}




//// في المشهد الذي تريد السماح بالدوران فيه:
//struct VideoPlayerView: View {
//    var body: some View {
//        // ...
//    }
//    // أضف هذه الدالة ↓
//    func shouldAllowRotation() -> some View {
//        self.onAppear {
//            AppDelegate.orientationLock = .allButUpsideDown
//        }
//        .onDisappear {
//            AppDelegate.orientationLock = .portrait
//        }
//    }
//}
//
//// في AppDelegate:
//class AppDelegate: NSObject, UIApplicationDelegate {
//    static var orientationLock = UIInterfaceOrientationMask.portrait
//    
//    func application(
//        _ application: UIApplication,
//        supportedInterfaceOrientationsFor window: UIWindow?
//    ) -> UIInterfaceOrientationMask {
//        return AppDelegate.orientationLock
//    }
//}
//







