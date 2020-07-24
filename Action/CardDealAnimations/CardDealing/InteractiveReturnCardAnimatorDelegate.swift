import Foundation

protocol InteractiveReturnCardAnimatorDelegate: AnyObject {
    func returnCardAnimator(_ animator: InteractiveReturnCardAnimator, willReturn card: CardDealable)
    func returnCardAnimator(_ animator: InteractiveReturnCardAnimator, didReturn card: CardDealable)
}
