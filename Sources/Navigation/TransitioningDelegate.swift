import UIKit

public final class TransitioningDelegate<
    Presenting: UIViewController,
    Presented: ImageDestinationTransitionType
>: NSObject, UIViewControllerTransitioningDelegate {
    weak var targetView: ImageSourceTransitionType?

    public init(targetView: ImageSourceTransitionType) {
        self.targetView = targetView
    }

    public func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        ImagePresentedAnimator<Presenting, Presented>(
            targetView: self.targetView!
        )
    }

    public func animationController(forDismissed dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning?
    {
        ImageDismissedAnimator<Presenting, Presented>(
            targetView: self.targetView!
        )
    }
}
