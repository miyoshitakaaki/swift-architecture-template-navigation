import UIKit

open class NavigationController: UINavigationController, FlowAlertPresentable {
    public enum CloseButtonPosition {
        case left, right
    }

    private let closeButton: UIButton

    private let hideBackButtonText: Bool

    private let showCloseButton: Bool

    private let closeButtonPosition: CloseButtonPosition

    private let navigationTintColor: UIColor

    private let closeConfirmAlertMessage: String?

    public init(
        hideBackButtonText: Bool = false,
        showCloseButton: Bool = false,
        closeButtonTitle: String,
        closeButtonFontSize: CGFloat,
        closeButtonPosition: CloseButtonPosition,
        closeButtonColor: UIColor,
        navigationTintColor: UIColor,
        closeConfirmAlertMessage: String? = nil
    ) {
        self.hideBackButtonText = hideBackButtonText
        self.showCloseButton = showCloseButton
        self.closeButtonPosition = closeButtonPosition
        self.navigationTintColor = navigationTintColor
        self.closeConfirmAlertMessage = closeConfirmAlertMessage

        self.closeButton = {
            let button = UIButton()
            button.titleLabel?.font = .systemFont(ofSize: closeButtonFontSize)
            button.setTitle(closeButtonTitle, for: .normal)
            button.setTitleColor(closeButtonColor, for: .normal)
            return button
        }()
        super.init(nibName: nil, bundle: nil)
    }

    public init(
        rootViewController: UIViewController,
        hideBackButtonText: Bool = false,
        showCloseButton: Bool = false,
        closeButtonTitle: String,
        closeButtonFontSize: CGFloat,
        closeButtonPosition: CloseButtonPosition,
        closeButtonColor: UIColor,
        navigationTintColor: UIColor,
        closeConfirmAlertMessage: String? = nil
    ) {
        self.hideBackButtonText = hideBackButtonText
        self.showCloseButton = showCloseButton
        self.closeButtonPosition = closeButtonPosition
        self.navigationTintColor = navigationTintColor
        self.closeConfirmAlertMessage = closeConfirmAlertMessage

        self.closeButton = {
            let button = UIButton()
            button.titleLabel?.font = .systemFont(ofSize: closeButtonFontSize)
            button.setTitle(closeButtonTitle, for: .normal)
            button.setTitleColor(closeButtonColor, for: .normal)
            return button
        }()

        super.init(rootViewController: rootViewController)
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        navigationBar.tintColor = self.navigationTintColor
        self.closeButton.addTarget(self, action: #selector(self.close), for: .touchUpInside)
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if self.showCloseButton {
            let closeButtonItem = UIBarButtonItem(customView: closeButton)

            switch self.closeButtonPosition {
            case .left:
                viewControllers.first?.navigationItem.leftBarButtonItem = closeButtonItem
            case .right:
                viewControllers.first?.navigationItem.rightBarButtonItem = closeButtonItem
            }
        }
    }

    override public func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard let presentationController else {
            return
        }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }

    @objc func close() {
        if let closeConfirmAlertMessage {
            present(
                title: "",
                message: closeConfirmAlertMessage
            ) { [weak self] _ in
                self?.dismiss(animated: true)
            } cancelAction: { _ in }

        } else {
            self.dismiss(animated: true)
        }
    }
}

extension NavigationController: UINavigationControllerDelegate {
    public func navigationController(
        _: UINavigationController,
        willShow viewController: UIViewController,
        animated _: Bool
    ) {
        if self.hideBackButtonText {
            let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
            viewController.navigationItem.backBarButtonItem = item
        }
    }
}
