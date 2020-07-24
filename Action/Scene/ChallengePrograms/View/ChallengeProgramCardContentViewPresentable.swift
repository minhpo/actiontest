import UIKit

protocol ChallengeProgramCardContentViewPresentable {
    var title: String { get }
    var color: UIColor { get }
    var imageUrl: URL? { get }
}
