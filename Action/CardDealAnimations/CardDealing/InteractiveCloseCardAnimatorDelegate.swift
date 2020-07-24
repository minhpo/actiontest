import Foundation

protocol InteractiveCloseCardAnimatorDelegate: AnyObject {
    func closeCardAnimator(_ animator: InteractiveCloseCardAnimator, willClose card: CardDealable)
    func closeCardAnimator(_ animator: InteractiveCloseCardAnimator, didClose card: CardDealable)
}

extension InteractiveCloseCardAnimatorDelegate {
    func closeCardAnimator(_ animator: InteractiveCloseCardAnimator, willClose card: CardDealable) { }
    func closeCardAnimator(_ animator: InteractiveCloseCardAnimator, didClose card: CardDealable) { }
}
