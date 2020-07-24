import Foundation

protocol InteractiveDrawCardAnimatorDelegate: AnyObject {
    func drawCardAnimator(_ animator: InteractiveDrawCardAnimator, willDraw card: CardDealable)
    func drawCardAnimator(_ animator: InteractiveDrawCardAnimator, didDraw card: CardDealable)
    func drawCardAnimator(_ animator: InteractiveDrawCardAnimator, didCancelDraw card: CardDealable)
}
