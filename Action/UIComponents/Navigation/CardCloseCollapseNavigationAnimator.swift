import UIKit

final class CardCloseCollapseNavigationAnimator: NSObject {
    
    private let cardCollapseAnimator = CardCollapseNavigationAnimator()
    private let closeCardAnimator = InteractiveCloseCardAnimator()
    
    private var transitionContext: UIViewControllerContextTransitioning?
    private var frontSide: CardDealable?
    private var backSide: CardDealable?
}

// MARK: - UIViewControllerAnimatedTransitioning -

extension CardCloseCollapseNavigationAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return cardCollapseAnimator.transitionDuration(using: transitionContext) + InteractiveCloseCardAnimator.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transitionContext.viewController(forKey: .from)?.beginAppearanceTransition(false, animated: true)
        transitionContext.viewController(forKey: .to)?.beginAppearanceTransition(true, animated: true)
        
        self.transitionContext = transitionContext
        cardCollapseAnimator.transit(using: transitionContext) { [weak self] in
            self?.closeCard(using: transitionContext)
        }
    }
}

// MARK: - Private methods -

private extension CardCloseCollapseNavigationAnimator {
    
    func closeCard(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        let collapseAnimatableContext: CardCloseCollapseAnimatableContext? = transitionContext.appearingViewController()
        
        guard let backSide = collapseAnimatableContext?.backSide, let frontSide = collapseAnimatableContext?.frontSide, let position = collapseAnimatableContext?.position else { return }
        
        self.frontSide = frontSide
        self.backSide = backSide
        
        frontSide.frame = position
        container.addSubview(frontSide)
        
        backSide.frame = position
        container.addSubview(backSide)
        
        closeCardAnimator.setupFrontSide(frontSide)
        closeCardAnimator.attach(to: backSide)
        closeCardAnimator.delegate = self
        
        closeCardAnimator.closeCard()
    }
}

// MARK: - InteractiveCloseCardAnimatorDelegate -

extension CardCloseCollapseNavigationAnimator: InteractiveCloseCardAnimatorDelegate {
    
    func closeCardAnimator(_ animator: InteractiveCloseCardAnimator, didClose card: CardDealable) {
        guard let transitionContext = self.transitionContext else { return }
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        
        transitionContext.viewController(forKey: .from)?.endAppearanceTransition()
        transitionContext.viewController(forKey: .to)?.endAppearanceTransition()
        
        frontSide?.removeFromSuperview()
        backSide?.removeFromSuperview()
    }
}
