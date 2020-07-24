import UIKit

protocol CardCollapseAnimatableContext: UIViewController {
    var collapsible: UIView? { get }
    var destination: CGRect { get }
}
