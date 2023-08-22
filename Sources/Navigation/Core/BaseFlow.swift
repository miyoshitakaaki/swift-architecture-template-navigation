#if !os(macOS)
import UIKit

@MainActor
open class BaseFlow<Child>: FlowBase {
    public let root: Child
    public let from: any FlowController.Type
    public let present: Bool
    public let navigation: NavigationController

    public required nonisolated init(
        navigation: NavigationController,
        root: Child,
        from: any FlowController.Type,
        present: Bool
    ) {
        self.navigation = navigation
        self.root = root
        self.from = from
        self.present = present
    }
}
#endif
