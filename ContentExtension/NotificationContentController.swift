//
//  NotificationViewController.swift
//  ContentExtension
//
//  Created by Michael Kao on 04.11.20.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import ComposableArchitecture
import struct ComposableUserNotifications.Notification
import Common
import Combine
import Library

final class NotificationContentController: UIViewController, UNNotificationContentExtension {
  let subject = PassthroughSubject<NotificationContentExtension.Action, Never>()
  var notificationViewController: NotificationViewController!

  required init?(coder: NSCoder) {
    super.init(coder: coder)

    let contentExtension = NotificationContentExtension { self.subject.eraseToEffect() }
    notificationViewController = NotificationViewController.create(contentExtension: contentExtension)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    addChild(notificationViewController)
    view.addSubview(notificationViewController.view)
    notificationViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    notificationViewController.didMove(toParent: self)
  }

  func didReceive(_ notification: UNNotification) {
    subject.send(.didReceiveNotification(Notification(rawValue: notification)))
  }

  func didReceive(_ response: UNNotificationResponse,
                  completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {

    let wrappedResponse = Notification.Response(rawValue: response)
    subject.send(.didReceiveResponse(wrappedResponse, completion: completion))
  }

  func mediaPlay() {
    subject.send(.mediaPlay)
  }

  func mediaPause() {
    subject.send(.mediaPause)
  }

  var mediaPlayPauseButtonType: UNNotificationContentExtensionMediaPlayPauseButtonType {
    notificationViewController.mediaPlayPauseButtonType
  }

  var mediaPlayPauseButtonFrame: CGRect {
    notificationViewController.mediaPlayPauseButtonFrame
  }

  var mediaPlayPauseButtonTintColor: UIColor {
    notificationViewController.mediaPlayPauseButtonTintColor
  }
}
