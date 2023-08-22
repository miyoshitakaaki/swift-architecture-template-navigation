#if !os(macOS)
import UIKit

@MainActor
public protocol FlowBase {
    associatedtype T
    associatedtype Child

    var root: Child { get }
    var navigation: T { get }
    var from: any FlowController.Type { get }
    var present: Bool { get }

    init(
        navigation: T,
        root: Child,
        from: any FlowController.Type,
        present: Bool
    )
}
#endif
