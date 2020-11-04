//
//  AppDelegate.swift
//  ContentNotification
//
//  Created by Michael Kao on 04.11.20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    UNUserNotificationCenter.current().delegate = self

    let acceptAction = UNNotificationAction(
      identifier: "ACCEPT_ACTION",
      title: "Accept",
      options: UNNotificationActionOptions(rawValue: 0)
    )
    let declineAction = UNNotificationAction(
      identifier: "DECLINE_ACTION",
      title: "Decline",
      options: UNNotificationActionOptions(rawValue: 0)
    )

    let category =
      UNNotificationCategory(
        identifier: "SOME_CATEGORY",
        actions: [acceptAction, declineAction],
        intentIdentifiers: [],
        hiddenPreviewsBodyPlaceholder: "",
        options: []
      )

    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.setNotificationCategories([category])

    registerForPushNotifications()

    return true
  }

  func registerForPushNotifications() {
    UNUserNotificationCenter.current()
      .requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
        print("Permission granted: \(granted)")
      }
  }

  func application(_ application: UIApplication,
                   configurationForConnecting connectingSceneSession: UISceneSession,
                   options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {

    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
}


extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

    completionHandler([.banner, .list, .badge])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {

    print("response.actionIdentifier: \(response.actionIdentifier)")
    completionHandler()
  }
}
