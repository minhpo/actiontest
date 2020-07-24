import UIKit

extension UIScrollView {
    
    var currentPage:CGFloat {
        return (contentOffset.x + (0.5 * frame.width)) / frame.width
    }
}
