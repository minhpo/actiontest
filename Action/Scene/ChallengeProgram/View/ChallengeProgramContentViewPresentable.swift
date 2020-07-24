import UIKit

protocol ChallengeProgramContentViewPresentable {
    var backgroundColor: UIColor { get }
    var icon: UIImage { get }
    var text: NSAttributedString { get }
}
