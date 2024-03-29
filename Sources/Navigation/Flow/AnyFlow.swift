#if !os(macOS)
import UIKit
import Utility

@MainActor
open class AnyFlow<Flow: FlowBase>: UIViewController, FlowController, FlowDelegate,
    FlowAlertPresentable where Flow.T == NavigationController
{
    open var childProvider: (Flow.Child) -> UIViewController {{ _ in
        .init(nibName: nil, bundle: nil)
    }}

    open var asyncChildProvider: ((Child) async -> UIViewController)? { nil }

    public weak var delegate: FlowDelegate?

    public var navigation: Flow.T

    public let root: Flow.Child

    public let from: any FlowController.Type

    public let present: Bool

    public required init(
        navigation: NavigationController,
        root: Flow.Child,
        from: any FlowController.Type,
        present: Bool
    ) {
        self.navigation = navigation
        self.root = root
        self.from = from
        self.present = present
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        if self.asyncChildProvider == nil {
            self.start()
        } else if self.navigation.viewControllers.isEmpty == false {
            self.start()
        }
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if self.navigation.viewControllers.isEmpty == true {
            self.start()
        }
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        children.first?.view.frame = view.bounds
    }

    override open func viewDidDisappear(_ animated: Bool) {
        if self.present {
            clear()
        }

        super.viewDidDisappear(animated)
    }

    override open func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard let presentationController else {
            return
        }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }

    open func start() {
        show(self.root, root: true)
    }

    open func didErrorOccured(error: AppError) {
        show(error: error)
    }

    open func didFinished() {}
}
#endif
