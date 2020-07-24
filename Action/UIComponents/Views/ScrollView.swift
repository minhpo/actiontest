import UIKit

final class ScrollView: UIScrollView {
    
    var hitAreaInsets: UIEdgeInsets = .zero
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let hitArea = bounds.inset(by: hitAreaInsets)
        return hitArea.contains(point)
    }
}
