import UIKit

protocol ChallengeProgramInfoViewPresentable {
    var title: String { get }
    var text: String { get }
    var color: UIColor { get }
    var hasReadMoreUrl: Bool { get }
}
