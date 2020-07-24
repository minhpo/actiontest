import UIKit

struct ChallengeProgramViewModel {
    
    let largeCardContent: CardContentViewModel
    let smallCardContent: CardContentViewModel
    
    struct CardContentViewModel: ChallengeProgramContentViewPresentable {
        let backgroundColor: UIColor
        let icon: UIImage
        let text: NSAttributedString
    }
}
