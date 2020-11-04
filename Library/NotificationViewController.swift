//
//  Controller.swift
//  Library
//
//  Created by Michael Kao on 04.11.20.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import ComposableArchitecture
import Common
import Combine

public final class NotificationViewController: UIViewController {

  @IBOutlet private var label: UILabel!

  private let store: Store<NotificationState, NotificationAction>
  private var cancellables = Set<AnyCancellable>()

  public init(store: Store<NotificationState, NotificationAction>) {
    self.store = store
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder, store: Store<NotificationState, NotificationAction>) {
    self.store = store
    super.init(coder: coder)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func viewDidLoad() {
    super.viewDidLoad()

    let viewStore = ViewStore(self.store)

    viewStore.publisher[keyPath: \.title]
      .sink { [weak label] title in
        label?.text = title
      }.store(in: &cancellables)

    viewStore.send(.viewDidLoad)
  }

  public var mediaPlayPauseButtonType: UNNotificationContentExtensionMediaPlayPauseButtonType {
    .none
  }

  public var mediaPlayPauseButtonFrame: CGRect {
    .zero
  }

  public var mediaPlayPauseButtonTintColor: UIColor {
    .clear
  }
  
  public static func create(contentExtension: NotificationContentExtension) -> NotificationViewController {
    let store = Store<NotificationState, NotificationAction>(
      initialState: NotificationState(),
      reducer: notificationReducer,
      environment: NotificationEnvironment(notificationExtension: contentExtension)
    )
    return create(store: store)
  }

  public static func create(store: Store<NotificationState, NotificationAction>) -> NotificationViewController {
    let storyboardBundle = Bundle(for: NotificationViewController.self)
    let storyboard = UIStoryboard(name: "Notification", bundle: storyboardBundle)

    let viewController = storyboard.instantiateViewController(identifier: "NotificationViewController") {
      NotificationViewController(coder: $0, store: store)
    }

    return viewController
  }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct UIViewRepresented<UIViewType>: UIViewRepresentable where UIViewType: UIView {
  let makeUIView: (Context) -> UIViewType
  let updateUIView: (UIViewType, Context) -> Void = { _, _ in }

  func makeUIView(context: Context) -> UIViewType {
    self.makeUIView(context)
  }

  func updateUIView(_ uiView: UIViewType, context: Context) {
    self.updateUIView(uiView, context)
  }

}

struct ViewController_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      preview(with: NotificationState(title: "foo"))
    }
  }
  static func preview(with state: NotificationState) -> some View {
    let viewController = NotificationViewController.create(
      store: Store(
        initialState: state,
        reducer: .empty,
        environment: ()
      )
    )
    return UIViewRepresented(makeUIView: { _ in viewController.view })
  }
}
#endif
