import UIKit
import Utility

@MainActor
public protocol FlowDelegate: AnyObject {
    func didFinished()
}

public enum ShowType {
    case modal(
        navigation: NavigationController,
        modalPresentationStyle: UIModalPresentationStyle? = nil
    ),
        push
}

@MainActor
public protocol FlowController: UIViewController, FlowBase, FlowAlertPresentable {
    var delegate: FlowDelegate? { get set }
    var childProvider: (Child) -> UIViewController { get }
    var asyncChildProvider: ((Child) async -> UIViewController)? { get }
    func start()
    func clear()
}

@MainActor
public extension FlowController {
    var childProvider: (Child) -> UIViewController {{ _ in
        UIViewController(nibName: nil, bundle: nil)
    }}

    var asyncChildProvider: ((Child) async -> UIViewController)? { nil }

    func showApplication(url: String) {
        if let url = URL(string: url), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:])
        }
    }
}

@MainActor
public extension FlowController where T == Never {
    func start<F: FlowController>(
        flowType _: F.Type,
        root: F.Child,
        delegate: FlowDelegate,
        showType: ShowType,
        alertMessageAlignment: NSTextAlignment?,
        alertTintColor: UIColor?
    ) where F.T == NavigationController {
        switch showType {
        case let .modal(navigation, style):
            let flow = F(
                navigation: navigation,
                root: root,
                from: Self.self,
                present: true,
                alertMessageAlignment: alertMessageAlignment,
                alertTintColor: alertTintColor
            )

            if let style {
                flow.modalPresentationStyle = style
            }

            flow.delegate = delegate

            if let target = self.presentedViewController as? any FlowController {
                target.present(flow, animated: true)
            } else {
                self.present(flow, animated: true)
            }

        case .push:
            fatalError("has not been implemented")
        }
    }

    func show(error: AppError, okAction: ((UIAlertAction) -> Void)? = nil) {
        switch error {
        case let .normal(title, message):

            if let okAction {
                present(
                    title: title,
                    message: message,
                    messageAlignment: alertMessageAlignment,
                    tintColor: alertTintColor,
                    action: okAction
                )
            } else {
                present(
                    title: title,
                    message: message,
                    messageAlignment: alertMessageAlignment,
                    tintColor: alertTintColor
                ) { _ in }
            }

        case let .auth(title, message):

            if let okAction {
                present(
                    title: title,
                    message: message,
                    messageAlignment: alertMessageAlignment,
                    tintColor: alertTintColor,
                    action: okAction
                )
            } else {
                present(
                    title: title,
                    message: message,
                    messageAlignment: alertMessageAlignment,
                    tintColor: alertTintColor
                ) { [weak self] _ in

                    guard let self else { return }

                    self.clear()

                    dismiss(animated: true) {
                        self.delegate?.didFinished()
                    }
                }
            }

        case let .notice(title, message):
            if let okAction {
                present(
                    title: title,
                    message: message,
                    messageAlignment: alertMessageAlignment,
                    tintColor: alertTintColor,
                    action: okAction
                )
            } else {
                present(
                    title: title,
                    message: message,
                    messageAlignment: alertMessageAlignment,
                    tintColor: alertTintColor
                ) { _ in }
            }

        case .none:
            break
        }
    }
}

@MainActor
public extension FlowController where T == NavigationController {
    func clear() {
        navigation.viewControllers = []
    }

    var rootViewController: UIViewController? {
        navigation.viewControllers.first
    }

    func show(_ child: Child, root: Bool = false) {
        if let provider = asyncChildProvider {
            Task { @MainActor in
                let vc = await provider(child)

                if root {
                    if self.navigation.viewControllers.isEmpty {
                        self.add(self.navigation)
                        self.navigation.viewControllers = [vc]
                    } else {
                        self.add(vc)
                    }
                } else {
                    self.navigation.pushViewController(vc, animated: true)
                }
            }
        } else {
            let vc = self.childProvider(child)

            if root {
                if navigation.viewControllers.isEmpty {
                    add(navigation)
                    navigation.viewControllers = [vc]
                } else {
                    add(vc)
                }
            } else {
                navigation.pushViewController(vc, animated: true)
            }
        }
    }

    func start<F: FlowController>(
        flowType _: F.Type,
        root: F.Child,
        delegate: FlowDelegate,
        showType: ShowType,
        alertMessageAlignment: NSTextAlignment?,
        alertTintColor: UIColor?
    ) where F.T == NavigationController {
        switch showType {
        case let .modal(navigation, style):
            let flow = F(
                navigation: navigation,
                root: root,
                from: Self.self,
                present: true,
                alertMessageAlignment: alertMessageAlignment,
                alertTintColor: alertTintColor
            )

            if let style {
                flow.modalPresentationStyle = style
            }

            flow.delegate = delegate

            if let target = self.presentedViewController as? any FlowController {
                target.present(flow, animated: true)
            } else {
                flow.presentationController?.delegate = self
                    .rootViewController as? UIAdaptivePresentationControllerDelegate
                flow.navigation.presentationController?.delegate = self
                    .rootViewController as? UIAdaptivePresentationControllerDelegate
                self.present(flow, animated: true)
            }

        case .push:
            let flow = F(
                navigation: navigation,
                root: root,
                from: Self.self,
                present: false,
                alertMessageAlignment: alertMessageAlignment,
                alertTintColor: alertTintColor
            )
            flow.delegate = delegate
            navigation.pushViewController(flow, animated: true)
        }
    }

    func show(error: AppError, okAction: ((UIAlertAction) -> Void)? = nil) {
        switch error {
        case let .normal(title, message):

            if let okAction {
                present(
                    title: title,
                    message: message,
                    messageAlignment: alertMessageAlignment,
                    tintColor: alertTintColor,
                    action: okAction
                )
            } else {
                present(
                    title: title,
                    message: message,
                    messageAlignment: alertMessageAlignment,
                    tintColor: alertTintColor
                ) { [weak self] _ in
                    guard let self else { return }

                    if navigation.viewControllers.count == 1 {
                        dismiss(animated: true)
                    } else {
                        _ = navigation.popViewController(animated: true)
                    }
                }
            }

        case let .auth(title, message):

            if let okAction {
                present(
                    title: title,
                    message: message,
                    messageAlignment: alertMessageAlignment,
                    tintColor: alertTintColor,
                    action: okAction
                )
            } else {
                present(
                    title: title,
                    message: message,
                    messageAlignment: alertMessageAlignment,
                    tintColor: alertTintColor
                ) { [weak self] _ in

                    guard let self else { return }

                    self.clear()

                    dismiss(animated: true) {
                        self.delegate?.didFinished()
                    }
                }
            }

        case let .notice(title, message):
            if let okAction {
                present(
                    title: title,
                    message: message,
                    messageAlignment: alertMessageAlignment,
                    tintColor: alertTintColor,
                    action: okAction
                )
            } else {
                present(
                    title: title,
                    message: message,
                    messageAlignment: alertMessageAlignment,
                    tintColor: alertTintColor
                ) { _ in }
            }

        case .none:
            break
        }
    }
}

@MainActor
public extension FlowController where T == TabBarController {
    func clear() {
        navigation.viewControllers = []
    }

    var rootViewController: UIViewController? {
        navigation.viewControllers?.first
    }

    func start<F: FlowController>(
        flowType _: F.Type,
        root: F.Child,
        delegate: FlowDelegate,
        showType: ShowType,
        alertMessageAlignment: NSTextAlignment?,
        alertTintColor: UIColor?
    ) where F.T == NavigationController {
        switch showType {
        case let .modal(navigation, style):
            let flow = F(
                navigation: navigation,
                root: root,
                from: Self.self,
                present: true,
                alertMessageAlignment: alertMessageAlignment,
                alertTintColor: alertTintColor
            )

            if let style {
                flow.modalPresentationStyle = style
            }

            flow.delegate = delegate

            if let target = self.presentedViewController as? any FlowController {
                target.present(flow, animated: true)
            } else {
                self.present(flow, animated: true)
            }

        case .push:
            fatalError("has not been implemented")
        }
    }
}
