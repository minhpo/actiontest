import UIKit

final class RetractCardsAnimator {
    
    private var animator: UIViewPropertyAnimator = UIViewPropertyAnimator()
    
    func retract(cards: [CardDealable], partial: Bool = false) {
        if partial {
            let minPosition: CGFloat = cards.reduce(CGFloat.greatestFiniteMagnitude) { result, card -> CGFloat in
                return min(result, card.frame.maxY)
            }
            
            let endPosition = minPosition / 10
            
            animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
                cards.forEach { card in
                    let displacement = card.frame.maxY - endPosition
                    card.transform = card.transform.translatedBy(x: 0, y: -displacement)
                }
            }
            animator.startAnimation()
        } else {
            animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
                cards.forEach { card in
                    let displacement = card.frame.height * 1.5
                    card.transform = card.transform.translatedBy(x: 0, y: -displacement)
                }
            }
            animator.startAnimation()
        }
    }
}
