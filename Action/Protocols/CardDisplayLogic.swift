import UIKit
import EasyPeasy

protocol CardDisplayLogic {
    var cardLayoutGuide: UILayoutGuide { get }
    
    func setupCardLayout(margin: CGFloat)
    func applyCardLayout(to card: CardDealable)
}

extension CardDisplayLogic {
    
    func setupCardLayout(margin: CGFloat = 32) {
        cardLayoutGuide.easy.layout(
            Leading(margin),
            Trailing(margin),
            Height(*1.5).like(cardLayoutGuide, .width),
            CenterY()
        )
    }
    
    func applyCardLayout(to card: CardDealable) {
        card.easy.layout(
            Leading().to(cardLayoutGuide, .leading),
            Trailing().to(cardLayoutGuide, .trailing),
            Top().to(cardLayoutGuide, .top),
            Bottom().to(cardLayoutGuide, .bottom)
        )
    }
}
