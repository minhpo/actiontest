import UIKit

extension UIView {
    
    func addShadow() {
        layer.shadowColor = StyleGuide.Colors.GreyTones.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    func rotate(degree: CGFloat) {
        let radians: CGFloat = degree / 180 * CGFloat.pi
        let newTransform = transform.rotated(by: radians)
        transform = newTransform
    }
}
