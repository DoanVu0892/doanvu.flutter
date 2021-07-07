import UIKit
import Flutter
import Firebase
import AVFoundation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        GeneratedPluginRegistrant.register(with: self)
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
//    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        let deviceTokenString = deviceToken.hexString
//        print("deviceToken-APNs: ",deviceTokenString)
//        Messaging.messaging().apnsToken = deviceToken
//        print("deviceToken-FCM: ",Messaging.messaging().fcmToken!)
//        super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
//    }
//    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        print("userInfo: ",userInfo)
//    }
}
//extension Data {
//    var hexString: String {
//        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
//        return hexString
//    }
//}
