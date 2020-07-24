import UIKit

protocol CardExpandAnimatableContext: UIViewController {
    var expandable: UIView? { get }
    var origin: CGRect? { get }
}
