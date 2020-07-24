import Foundation

protocol InteractiveOpenCardAnimatorDelegate: AnyObject {
    func openCardAnimator(_ animator: InteractiveOpenCardAnimator, willOpen card: CardDealable)
    func openCardAnimator(_ animator: InteractiveOpenCardAnimator, didOpen card: CardDealable)
}

extension InteractiveOpenCardAnimatorDelegate {
    func openCardAnimator(_ animator: InteractiveOpenCardAnimator, willOpen card: CardDealable) { }
    func openCardAnimator(_ animator: InteractiveOpenCardAnimator, didOpen card: CardDealable) { }
}
