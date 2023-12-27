import UIKit
import Flutter
import CoreSpotlight
import MobileCoreServices
import UniformTypeIdentifiers
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      let searchableItemAttributeSet =
           CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
    UNUserNotificationCenter.current().delegate = self

      searchableItemAttributeSet.title = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
      searchableItemAttributeSet.keywords = [
        "Zid",
        "Apps bunches",
        "زد",
        "عناقيد التطبيقات",
       ]

      let searchableItem = CSSearchableItem(uniqueIdentifier: Bundle.main.bundleIdentifier, domainIdentifier: Bundle.main.bundleIdentifier, attributeSet: searchableItemAttributeSet)

      CSSearchableIndex.default().indexSearchableItems([searchableItem]) { (error) -> Void in
      if let error = error {
            print(error)
      } else {
            print("Content Indexed Successfully")
        }
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
         super.userNotificationCenter(center, willPresent: notification, withCompletionHandler: completionHandler)
     }

     override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
         super.userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)
     }
}
