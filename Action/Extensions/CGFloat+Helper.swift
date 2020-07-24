import UIKit

extension CGFloat {
    
    static func radians(degrees: CGFloat) -> CGFloat {
        return degrees / 180 * CGFloat.pi
    }
}
