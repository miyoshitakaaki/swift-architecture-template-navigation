import UIKit
import Utility

@MainActor
open class ApplicationFlow: UIViewController, FlowController, FlowAlertPresentable {
    public enum Child {
        case none
    }

    public let root: Child = .none

    public let from: any FlowController.Type = ApplicationFlow.self

    public let present = false

    public var navigation: Never { fatalError("has not been implemented") }

    public weak var delegate: FlowDelegate?

    public var alertMessageAlignment: NSTextAlignment? = nil

    public var alertTintColor: UIColor? = nil

    public init() {
        super.init(nibName: nil, bundle: nil)

        AnalyticsService.log("start")
    }

    public required init(
        navigation: Never,
        root: Child,
        from: any FlowController.Type,
        present: Bool,
        alertMessageAlignment: NSTextAlignment?,
        alertTintColor: UIColor?
    ) {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        children.first?.view.frame = view.bounds
    }

    open func clear() {}
}
