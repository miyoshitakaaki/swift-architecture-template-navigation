import UIKit

class ImagePresentedAnimator<
    Presenting: UIViewController,
    Presented: ImageDestinationTransitionType
>: NSObject, UIViewControllerAnimatedTransitioning {
    weak var targetView: ImageSourceTransitionType?

    private let duration: TimeInterval = 1

    init(targetView: ImageSourceTransitionType) {
        self.targetView = targetView
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?)
        -> TimeInterval
    {
        self.duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let presented = transitionContext
            .viewController(forKey: UITransitionContextViewControllerKey.to)

        let presenting = transitionContext
            .viewController(forKey: UITransitionContextViewControllerKey.from)

        guard
            let presenting = presenting as? Presenting,
            let presented = presented as? Presented,
            let targetView
        else {
            transitionContext.cancelInteractiveTransition()
            return
        }

        let containerView = transitionContext.containerView

        presented.view.frame = transitionContext.finalFrame(for: presented)
        presented.view.layoutIfNeeded()
        presented.view.alpha = 0

        containerView.addSubview(presented.view)

        let animationView = UIView(frame: presenting.view.frame)
        animationView.backgroundColor = .white.withAlphaComponent(0)

        let frame = targetView.imageView.superview!.convert(
            targetView.imageView.frame,
            to: animationView
        )

        let imageView = UIImageView(frame: frame)
        imageView.image = targetView.imageView.image
        imageView.contentMode = targetView.imageView.contentMode
        animationView.addSubview(imageView)
        containerView.addSubview(animationView)

        let animation = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
            imageView.frame = presented.imageView.frame
            animationView.backgroundColor = .white.withAlphaComponent(1)
        }

        animation.addCompletion { _ in
            presented.view.alpha = 1
            animationView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
        animation.startAnimation()
    }
}
