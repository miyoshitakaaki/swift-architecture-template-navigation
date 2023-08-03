#if !os(macOS)
import UIKit

@MainActor
open class BaseFlow<Child>: FlowBase {
    public let root: Child
    public let from: any FlowController.Type
    public let present: Bool
    public let navigation: NavigationController
    public let alertMessageAlignment: NSTextAlignment?
    public let alertTintColor: UIColor?

    public required nonisolated init(
        navigation: NavigationController,
        root: Child,
        from: any FlowController.Type,
        present: Bool,
        alertMessageAlignment: NSTextAlignment?,
        alertTintColor: UIColor?
    ) {
        self.navigation = navigation
        self.root = root
        self.from = from
        self.present = present
        self.alertMessageAlignment = alertMessageAlignment
        self.alertTintColor = alertTintColor
    }
}
#endif
