import UIKit

public protocol ImageDestinationTransitionType: UIViewController {
    var imageView: UIImageView { get }
}

public protocol ImageSourceTransitionType: UIView {
    var imageView: UIImageView { get }
}
