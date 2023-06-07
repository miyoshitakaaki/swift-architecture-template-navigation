import UIKit
import WebKit

extension UIViewController {
    func scrollToTop() {
        func scrollToTop(view: UIView?) {
            guard let view else { return }

            switch view {
            case let scrollView as UIScrollView:
                if scrollView.scrollsToTop == true {
                    scrollView.setContentOffset(
                        CGPoint(x: 0.0, y: -scrollView.contentInset.top),
                        animated: true
                    )
                    return
                }
            default:
                break
            }

            for subView in view.subviews {
                scrollToTop(view: subView)
            }
        }

        scrollToTop(view: view)
    }

    var isScrolledToTop: Bool {
        for subView in view.subviews {
            if let scrollView = subView as? UIScrollView {
                return scrollView.contentOffset.y == 0
            }

            if let webview = subView as? WKWebView {
                return webview.scrollView.contentOffset.y == 0
            }
        }

        return true
    }

    func findWebView() -> WKWebView? {
        for subView in view.subviews {
            return subView as? WKWebView
        }

        return nil
    }
}
