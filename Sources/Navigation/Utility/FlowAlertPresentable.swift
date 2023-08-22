#if !os(macOS)
import UIKit

public protocol FlowAlertPresentable: UIViewController {}

public extension FlowAlertPresentable {
    func present(
        title: String,
        message: String,
        okButtonTitle: String = "OK",
        action: @escaping (UIAlertAction) -> Void
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(
            .init(
                title: okButtonTitle,
                style: .default,
                handler: action
            )
        )
        self.present(alert, animated: true)
    }

    func present(
        title: String,
        message: String,
        okButtonTitle: String = "OK",
        cancelButtonTitle: String = "キャンセル",
        okAction: @escaping (UIAlertAction) -> Void,
        cancelAction: @escaping (UIAlertAction) -> Void
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(
            .init(
                title: cancelButtonTitle,
                style: .cancel,
                handler: cancelAction
            )
        )
        alert.addAction(
            .init(
                title: okButtonTitle,
                style: .default,
                handler: okAction
            )
        )
        self.present(alert, animated: true)
    }
}
#endif
