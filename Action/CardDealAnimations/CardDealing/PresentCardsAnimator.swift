import UIKit

final class PresentCardsAnimator {
    
    private var animator: UIViewPropertyAnimator = UIViewPropertyAnimator()
    
    func present(contexts: [DealingContext]) {
        animator = UIViewPropertyAnimator(duration: 0.1, curve: .easeInOut) {
            contexts.forEach { context in
                context.card.transform = context.transform
            }
        }
        animator.startAnimation()
    }
}
