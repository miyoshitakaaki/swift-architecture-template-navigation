import UIKit

open class TabFlow: UIViewController, FlowController {
    public enum Child {
        case none
    }

    private let flows: [any FlowController]

    public weak var delegate: FlowDelegate?

    public var selectedIndex = 0 {
        didSet {
            self.navigation.selectedIndex = self.selectedIndex
        }
    }

    public let navigation: TabBarController

    public let root: Child = .none

    public let from: any FlowController.Type

    public let present = false

    public let alertMessageAlignment: NSTextAlignment?

    public let alertTintColor: UIColor?

    public required init(
        navigation: TabBarController,
        root: Child,
        from: any FlowController.Type,
        present: Bool,
        alertMessageAlignment: NSTextAlignment?,
        alertTintColor: UIColor?
    ) {
        fatalError("has not been implemented")
    }

    public init(
        navigation: TabBarController,
        from: any FlowController.Type,
        alertMessageAlignment: NSTextAlignment?,
        alertTintColor: UIColor?,
        flows: [any FlowController]
    ) {
        self.navigation = navigation
        self.from = from
        self.flows = flows
        self.alertMessageAlignment = alertMessageAlignment
        self.alertTintColor = alertTintColor

        super.init(nibName: nil, bundle: nil)

        self.navigation.delegate = self
        self.flows.forEach { $0.delegate = self }
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.start()
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if self.navigation.viewControllers?.isEmpty == true {
            self.start()
        }
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        children.first?.view.frame = view.bounds
    }

    open func start() {
        self.navigation.setViewControllers(self.flows, animated: false)
        self.navigation.selectedIndex = self.selectedIndex
        add(self.navigation)
    }

    public func clear() {
        self.flows.forEach { $0.clear() }
        self.navigation.viewControllers = []
    }
}

extension TabFlow: FlowDelegate {
    public func didFinished() {
        self.delegate?.didFinished()
    }
}

extension TabFlow: UITabBarControllerDelegate {
    public func tabBarController(
        _ tabBarController: UITabBarController,
        didSelect viewController: UIViewController
    ) {
        self.selectedIndex = self.navigation.selectedIndex
    }

    public func tabBarController(
        _: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {
        guard let flow = viewController as? (any FlowController) else { return true }

        guard let nav = flow.navigation as? UINavigationController else { return true }

        guard let topController = nav.viewControllers.last else { return true }

        guard
            let index = self.navigation.viewControllers?.firstIndex(of: viewController),
            index == selectedIndex else { return true }

        if !topController.isScrolledToTop {
            topController.scrollToTop()
            return true
        } else {
            if let webView = topController.findWebView() {
                webView.goBack()
            } else {
                nav.popViewController(animated: true)
            }

            return true
        }
    }
}
