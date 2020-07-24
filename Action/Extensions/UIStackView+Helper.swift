import UIKit

extension UIStackView {
    
    func addArrangedSubviews(_ subviews: [UIView]) {
        subviews.forEach({ addArrangedSubview($0) })
    }
    
    func removeArrangedSubviews(where shouldRemove: ((UIView) -> Bool)? = nil) {
        arrangedSubviews.forEach({
            guard shouldRemove == nil || shouldRemove?($0) == true else { return }
            removeArrangedSubview($0)
            $0.removeFromSuperview()
        })
    }
}
