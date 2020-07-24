import UIKit

struct ChallengeProgramsViewModel: ChallengeProgramCardContentViewPresentable, ChallengeProgramInfoViewPresentable {
    let title: String
    let text: String
    let color: UIColor
    let imageUrl: URL?
    let hasReadMoreUrl: Bool
}
