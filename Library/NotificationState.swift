//
//  State.swift
//  Library
//
//  Created by Michael Kao on 04.11.20.
//

import Foundation
import ComposableArchitecture
import UserNotificationsUI
import struct ComposableUserNotifications.Notification

public struct NotificationContentExtension {
  public var start: () -> Effect<Action, Never> = {
    _unimplemented("start")
  }

  public init(start: @escaping () -> Effect<Action, Never>) {
    self.start = start
  }

  public enum Action {
    case didReceiveNotification(Notification)
    case didReceiveResponse(Notification.Response,
                            completion: (UNNotificationContentExtensionResponseOption) -> Void)
    case mediaPause
    case mediaPlay
  }
}

public struct NotificationState: Equatable {
  public var title: String?

  public init(title: String? = nil) {
    self.title = title
  }
}

public enum NotificationAction: Equatable {
  case viewDidLoad
  case notification(NotificationContentExtension.Action)
}

public struct NotificationEnvironment {
  public var notificationExtension: NotificationContentExtension

  public init(notificationExtension: NotificationContentExtension) {
    self.notificationExtension = notificationExtension
  }
}

public let notificationReducer = Reducer<NotificationState, NotificationAction, NotificationEnvironment> { state, action, environment in

  switch action {
  case .viewDidLoad:
    return environment.notificationExtension.start()
      .map(NotificationAction.notification)

  case let .notification(.didReceiveNotification(notification)):
    state.title = notification.request.content.title()
    return .none
    
  case let .notification(.didReceiveResponse(response, completion)):
    return .fireAndForget {
      completion(.dismissAndForwardAction)
    }
    
  case .notification(.mediaPause):
    return .none
    
  case .notification(.mediaPlay):
    return .none
  }
}

extension NotificationContentExtension.Action: Equatable {
  public static func == (lhs: NotificationContentExtension.Action, rhs: NotificationContentExtension.Action) -> Bool {
    switch (lhs, rhs) {
    case let (.didReceiveNotification(lhs), .didReceiveNotification(rhs)):
      return lhs == rhs
    case let (.didReceiveResponse(lhs, _), .didReceiveResponse(rhs, _)):
      return lhs == rhs
    case (.mediaPause, .mediaPause):
      return true
    case (.mediaPlay, .mediaPlay):
      return true
    default:
      return false
    }
  }
}

public func _unimplemented(
  _ function: StaticString, file: StaticString = #file, line: UInt = #line
) -> Never {
  fatalError(
    """
    `\(function)` was called but is not implemented. Be sure to provide an implementation for
    this endpoint when creating the mock.
    """,
    file: file,
    line: line
  )
}
