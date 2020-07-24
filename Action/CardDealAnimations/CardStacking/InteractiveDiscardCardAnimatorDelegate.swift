import Foundation

protocol InteractiveDiscardCardAnimatorDelegate: AnyObject {
    func discardCardAnimator(_ animator: InteractiveDiscardCardAnimator, didDiscard card: CardStackable)
}
